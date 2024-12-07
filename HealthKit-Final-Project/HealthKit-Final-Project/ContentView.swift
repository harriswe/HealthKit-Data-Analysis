import SwiftUI
import HealthKit

/// Main view displaying heart rate and step count data.
struct ContentView: View {
    @State private var heartRate: Double = 0
    @State private var stepCount: Int = 0
    @State private var heartRateData: [HKQuantitySample] = []
    @State private var stepGoal: Int = 10000
    @State private var heartRateGoal: Double = 120.0

    // Instance of HealthKit store
    private let healthStore = HKHealthStore()
    
    var body: some View {
        VStack {
            // Display current heart rate
            Text("Heart Rate: \(heartRate, specifier: "%.1f")")
                .font(.largeTitle)
            
            // Display current step count
            Text("Step Count: \(stepCount)")
                .font(.title)
            
            // Display step goal progress
            Text("Step Goal: \(stepCount >= stepGoal ? "Achieved!" : "\(stepCount)/\(stepGoal)")")
                .font(.headline)
                .foregroundColor(stepCount >= stepGoal ? .green : .red)
            
            // Display heart rate goal progress
            Text("Heart Rate Goal: \(heartRate >= heartRateGoal ? "Achieved!" : "\(heartRate, specifier: "%.1f")/\(heartRateGoal, specifier: "%.1f")")")
                .font(.headline)
                .foregroundColor(heartRate >= heartRateGoal ? .green : .red)
            
            // Button to request access to HealthKit data
            Button("Request Access") {
                requestAccessToHealthData()
            }
            
            // Display heart rate chart if data is available
            if !heartRateData.isEmpty {
                HeartRateChart(heartRateData: heartRateData)
                    .frame(height: 200)
            }
        }
        .padding()
    }

    /// Request authorization to access heart rate and step count data from HealthKit.
    private func requestAccessToHealthData() {
        // Ensure HealthKit is available on the device
        guard HKHealthStore.isHealthDataAvailable() else { return }
        
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        // Request read access to heart rate and step count data
        healthStore.requestAuthorization(toShare: [], read: [heartRateType, stepCountType]) { success, error in
            if success {
                fetchHeartRateData()
                fetchStepCountData()
            } else {
                print("Authorization failed: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    /// Fetch the most recent heart rate data from HealthKit.
    private func fetchHeartRateData() {
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date()) // Last 7 days
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        // Create query to fetch heart rate data
        let query = HKSampleQuery(sampleType: heartRateType, predicate: predicate, limit: 100, sortDescriptors: [sortDescriptor]) { query, samples, error in
            if let samples = samples as? [HKQuantitySample] {
                DispatchQueue.main.async {
                    self.heartRateData = samples
                    if let latestSample = samples.first {
                        self.heartRate = latestSample.quantity.doubleValue(for: HKUnit(from: "count/min"))
                    }
                }
            } else {
                print("Error fetching heart rate data: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
        
        healthStore.execute(query)
    }

    /// Fetch the step count data from HealthKit.
    private func fetchStepCountData() {
        let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let startDate = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)

        // Create query to fetch step count data
        let query = HKStatisticsQuery(quantityType: stepCountType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            guard let result = result, let sum = result.sumQuantity() else {
                print("Error fetching step count data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            DispatchQueue.main.async {
                self.stepCount = Int(sum.doubleValue(for: HKUnit.count()))
            }
        }

        healthStore.execute(query)
    }
}

/// View to display a chart of heart rate data.
struct HeartRateChart: View {
    var heartRateData: [HKQuantitySample]

    var body: some View {
        // Implement chart using a library like SwiftUI Charts or create a custom chart
        Text("Heart Rate Chart goes here")
    }
}
