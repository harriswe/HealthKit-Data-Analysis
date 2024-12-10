// ContentView.swift
import SwiftUI
import HealthKit

struct ContentView: View {
    @EnvironmentObject var healthDataManager: HealthKitManager
        @State private var isAuthorized = false
        @State private var heartRateData: [HKQuantitySample] = []

        var body: some View {
            VStack(spacing: 20) {
                Text("Welcome to Health Tracker")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("by Wesley Harrison and Jerod Muilenberg")
                    .font(.title3)

                if isAuthorized {
                    Text("Access Granted! Start exploring your health data.")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .padding()

                    Button(action: fetchHeartRateData) {
                        Text("View Heart Rate Data")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    .padding(.horizontal)

                    if !heartRateData.isEmpty {
                        List(heartRateData, id: \..uuid) { sample in
                            VStack(alignment: .leading) {
                                Text("Heart Rate: \(sample.quantity.doubleValue(for: HKUnit(from: "count/min"))) BPM")
                                Text("Date: \(sample.startDate, formatter: dateFormatter)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }

                } else {
                    Button(action: {
                        healthDataManager.requestAuthorization { success in
                            isAuthorized = success
                        }
                    }) {
                        Text("Request Health Data Access")
                            .font(.headline)
                            .padding(.vertical, 14)
                            .padding(.horizontal, 20)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .background(
                                LinearGradient(gradient: Gradient(colors: [
                                    Color.blue.opacity(0.8),
                                    Color.blue
                                ]), startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                            .cornerRadius(12)
                            .shadow(color: Color.blue.opacity(0.4), radius: 8, x: 0, y: 4)
                    }
                    .padding(.horizontal)
                }
            }
            .padding()
            .onAppear {
                healthDataManager.checkAuthorizationStatus { isAuthorized in
                    self.isAuthorized = isAuthorized
                }
            }
        }

        func fetchHeartRateData() {
            healthDataManager.fetchHeartRateData { samples in
                guard let samples = samples else { return }
                heartRateData = samples
            }
        }

        private var dateFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return formatter
        }
    }

    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
                .environmentObject(HealthKitManager(healthStore: HKHealthStore()))
        }
    }

