// ContentView.swift
import SwiftUI
import HealthKit

struct ContentView: View {
    @EnvironmentObject var healthDataManager: HealthDataManager
    @State private var isAuthorized = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome to Health Tracker")
                .font(.largeTitle)
                .fontWeight(.bold)

            if isAuthorized {
                Text("Access Granted! Start exploring your health data.")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding()

                Button(action: {
                    // Action to fetch heart rate data
                }) {
                    Text("View Heart Rate Data")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding(.horizontal)

            } else {
                Button(action: {
                    healthDataManager.requestAuthorization { success in
                        isAuthorized = success
                    }
                }) {
                    Text("Request Health Data Access")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(HealthDataManager(healthStore: HKHealthStore()))
    }
}

