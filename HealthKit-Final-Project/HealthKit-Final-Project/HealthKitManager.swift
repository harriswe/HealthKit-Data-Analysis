//
//  HealthDataManager.swift
//  HealthKit-Final-Project
//
//  Created by Wesley Harrison on 12/8/24.
//

// HealthDataManager.swift
import Foundation
import HealthKit

class HealthKitManager: ObservableObject {
        private var healthStore: HKHealthStore

        init(healthStore: HKHealthStore) {
            self.healthStore = healthStore
        }

    // Request HealthKit Authorization
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false)
            return
        }

        let readTypes: Set<HKSampleType> = [
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .heartRate)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
        ]

        healthStore.requestAuthorization(toShare: nil, read: readTypes) { success, _ in
            DispatchQueue.main.async {
                completion(success)
            }
        }
    }

    // Check HealthKit Authorization Status
    func checkAuthorizationStatus(completion: @escaping (Bool) -> Void) {
        let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
        let status = healthStore.authorizationStatus(for: heartRateType)
        DispatchQueue.main.async {
            completion(status == .sharingAuthorized)
        }
    }

    // Fetch Heart Rate Data
    func fetchHeartRateData(completion: @escaping ([HKQuantitySample]?) -> Void) {
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        let predicate = HKQuery.predicateForSamples(withStart: Date().addingTimeInterval(-7 * 24 * 60 * 60), // Last 7 days
                                                     end: Date(),
                                                     options: .strictEndDate)

        let query = HKSampleQuery(sampleType: heartRateType,
                                  predicate: predicate,
                                  limit: HKObjectQueryNoLimit,
                                  sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)]) { _, samples, _ in
            DispatchQueue.main.async {
                completion(samples as? [HKQuantitySample])
            }
        }

        healthStore.execute(query)
    }
}
