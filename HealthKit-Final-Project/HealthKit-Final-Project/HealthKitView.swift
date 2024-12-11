import SwiftUI
import HealthKit

struct ContentView: View {
    @EnvironmentObject var healthDataManager: HealthKitManager
    @State private var isAuthorized = false
    @State private var heartRateData: [HKQuantitySample] = []
    @State private var stepCountData: [HKQuantitySample] = []
    @State private var activeEnergyBurnedData: [HKQuantitySample] = []
    @State private var selectedView: String = "Data"

    var body: some View {
        NavigationView {
            ZStack {
                // Background Gradient
                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.teal]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    // Title Section
                    Text("Health Tracker")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(radius: 3)
                        .padding(.top, 40)

                    // View Selector
                    Picker("", selection: $selectedView) {
                        Text("Data").tag("Data")
                        Text("Stats").tag("Stats")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal, 20)

                    if selectedView == "Data" {
                        // Health Data Grid
                        if isAuthorized {
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                                HealthDataCard(title: "Heart Rate", icon: "heart.fill", color: .red, data: heartRateData.map { $0.quantity.doubleValue(for: .count().unitDivided(by: .minute())) }, unit: "bpm")
                                HealthDataCard(title: "Step Count", icon: "figure.walk", color: .green, data: stepCountData.map { $0.quantity.doubleValue(for: .count()) }, unit: "steps")
                                HealthDataCard(title: "Energy Burned", icon: "flame.fill", color: .orange, data: activeEnergyBurnedData.map { $0.quantity.doubleValue(for: .kilocalorie()) }, unit: "kcal")
                            }
                        } else {
                            Text("Please grant access to HealthKit data.")
                                .multilineTextAlignment(.center)
                                .padding()

                            Button(action: requestAuthorization) {
                                Text("Grant Access")
                                    .fontWeight(.bold)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.white)
                                    .foregroundColor(.blue)
                                    .cornerRadius(10)
                                    .shadow(radius: 3)
                            }
                            .padding(.horizontal)
                        }
                    } else {
                        // HealthKit Stats View
                        VStack(spacing: 20) {
                            StatCard(title: "Total Heart Rate Data Points", value: "\(heartRateData.count)")
                            StatCard(title: "Total Step Count Data Points", value: "\(stepCountData.count)")
                            StatCard(title: "Total Energy Burned Data Points", value: "\(activeEnergyBurnedData.count)")
                        }
                        .padding(.horizontal)
                    }
                }
                .padding()
            }
        }
        .onAppear(perform: checkAuthorization)
    }

    private func requestAuthorization() {
        healthDataManager.requestAuthorization { success in
            isAuthorized = success
            if success {
                fetchHealthData()
            }
        }
    }

    private func checkAuthorization() {
        healthDataManager.requestAuthorization { success in
            isAuthorized = success
            if success {
                fetchHealthData()
            }
        }
    }

    private func fetchHealthData() {
        healthDataManager.fetchHeartRateData { data in
            if let data = data {
                heartRateData = data
            }
        }
        healthDataManager.fetchStepCountData { data in
            if let data = data {
                stepCountData = data
            }
        }
        healthDataManager.fetchActiveEnergyBurnedData { data in
            if let data = data {
                activeEnergyBurnedData = data
            }
        }
    }
}

struct HealthDataCard: View {
    let title: String
    let icon: String
    let color: Color
    let data: [Double]
    let unit: String

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: icon)
                    .font(.title)
                    .foregroundColor(color)
                    .padding(8)
                    .background(color.opacity(0.2))
                    .cornerRadius(10)

                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            .padding(.bottom, 5)

            if data.isEmpty {
                Text("No data available")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            } else {
                ForEach(Array(data.prefix(5)), id: \.self) { value in
                    HStack {
                        Text(String(format: "%.1f", value))
                            .font(.body)
                        Spacer()
                        Text(unit)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

struct StatCard: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)

            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.blue.opacity(0.8))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

