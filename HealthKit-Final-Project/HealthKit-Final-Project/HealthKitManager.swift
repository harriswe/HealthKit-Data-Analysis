import Foundation
import HealthKit
import SwiftUI

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
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .respiratoryRate)!
        ]

        healthStore.requestAuthorization(toShare: nil, read: readTypes) { success, _ in
            DispatchQueue.main.async {
                completion(success)
            }
        }
    }

    // Fetch Heart Rate Data
    func fetchHeartRateData(completion: @escaping ([HKQuantitySample]?) -> Void) {
        let sampleType = HKObjectType.quantityType(forIdentifier: .heartRate)!
        fetchData(for: sampleType, completion: completion)
    }

    // Fetch Steps Data
    func fetchStepCountData(completion: @escaping ([HKQuantitySample]?) -> Void) {
        let sampleType = HKObjectType.quantityType(forIdentifier: .stepCount)!
        fetchData(for: sampleType, completion: completion)
    }

    // Fetch Active Energy Burned Data
    func fetchActiveEnergyBurnedData(completion: @escaping ([HKQuantitySample]?) -> Void) {
        let sampleType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
        fetchData(for: sampleType, completion: completion)
    }

    private func fetchData(for sampleType: HKSampleType, completion: @escaping ([HKQuantitySample]?) -> Void) {
        let query = HKSampleQuery(
            sampleType: sampleType,
            predicate: nil,
            limit: HKObjectQueryNoLimit,
            sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)]
        ) { query, samples, error in
            DispatchQueue.main.async {
                if let samples = samples as? [HKQuantitySample] {
                    completion(samples)
                } else {
                    completion(nil)
                }
            }
        }

        healthStore.execute(query)
    }
}

