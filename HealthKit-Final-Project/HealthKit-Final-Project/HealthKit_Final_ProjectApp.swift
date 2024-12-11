// HealthKit_Final_ProjectApp.swift
import SwiftUI
import HealthKit

@main
struct HealthKit_Final_ProjectApp: App {
    // Initialize HealthStore
    let healthStore = HKHealthStore()

    var body: some Scene {
        WindowGroup {
            WelcomeView()
                .environmentObject(HealthKitManager(healthStore: healthStore))
        }
    }
}


