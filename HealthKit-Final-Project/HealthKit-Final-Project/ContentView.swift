

import SwiftUI
import HealthKit

struct ContentView: View {
    @State private var heartRate: Double = 0
    
    // Create an instance of the HealthKit store
    private let healthStore = HKHealthStore()
    
    var body: some View {
        VStack {
            Text("Heart Rate: \(heartRate, specifier: "%.1f")")
                .font(.largeTitle)
            
            Button("Request Access") {
                requestAccessToHealthData()
            }
        }
        .padding()
    }
    
    // Function to request authorization for heart rate data
    private func requestAccessToHealthData() {
        guard HKHealthStore.isHealthDataAvailable() else { return }
        
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        
        healthStore.requestAuthorization(toShare: [], read: [heartRateType]) { success, error in
            if success {
                // Fetch and display the heart rate data
                fetchHeartRateData()
            } else {
                // Handle authorization error
                print("Authorization failed: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    // Function to fetch heart rate data from HealthKit
    private func fetchHeartRateData() {
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        
        // Create a query to fetch the most recent heart rate data
        let query = HKSampleQuery(sampleType: heartRateType, predicate: nil, limit: 1, sortDescriptors: nil) { query, samples, error in
            if let sample = samples?.first as? HKQuantitySample {
                // Update the heart rate on the main thread
                DispatchQueue.main.async {
                    self.heartRate = sample.quantity.doubleValue(for: HKUnit(from: "count/min"))
                }
            } else {
                // Handle data fetch error
                print("Error fetching heart rate data: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
        
        // Execute the query
        healthStore.execute(query)
    }
}
