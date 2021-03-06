//
//  DataNetworkHandler.swift
//  fit-swift-client
//
//  Created by admin on 21/05/2020.
//  Copyright © 2020 Dominik Urbaez Gomez. All rights reserved.
//

import Foundation
import RxSwift

class DataNetworkHandler {
    private var apiClient: DataNetworking
    var store: DataStore!
    private var isStepsDataPosted = false
    
    init() {
        apiClient = DataNetworking()
    }
    
    private var weightDataSubject = BehaviorSubject.init(value: [Record]())
    private var caloriesDataSubject = BehaviorSubject.init(value: [Record]())
    private var trainingDataSubject = BehaviorSubject.init(value: [Record]())
    private var sleepDataSubject = BehaviorSubject.init(value: [Record]())
    private var pulseDataSubject = BehaviorSubject.init(value: [Record]())
    private var stepsDataSubject = BehaviorSubject.init(value: [Record]())
    private var measurementsDataSubject = BehaviorSubject.init(value: [BodyMeasurements]())
    
    var weightData: Observable<[Record]> {
        return weightDataSubject.asObservable()
    }
    var caloriesData: Observable<[Record]> {
        return caloriesDataSubject.asObservable()
    }
    var trainingData: Observable<[Record]> {
        return trainingDataSubject.asObservable()
    }
    var sleepData: Observable<[Record]> {
        return sleepDataSubject.asObservable()
    }
    var pulseData: Observable<[Record]> {
        return pulseDataSubject.asObservable()
    }
    var stepsData: Observable<[Record]> {
        return stepsDataSubject.asObservable()
    }
    var measurementsData: Observable<[BodyMeasurements]> {
        return measurementsDataSubject.asObservable()
    }
    
    private func currentUser() -> User? {
        return mainStore.userStore.currentUser
    }
    
    func authenticateUserProfile() -> User? {
        guard let user = currentUser() else {
            debugPrint("USER_ERROR: Failed to authenticate user profile.")
            return nil
        }
        return user
    }
    
    // MARK: Dashboard View Controller, Fetching data, Posting data
    func fetchWeightData(onComplete: @escaping(Bool) -> Void)  {
        guard let user = authenticateUserProfile() else { return }
        apiClient.fetchRegularData(forUserId: user.id, dataType: .weights) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
                onComplete(false)
            case .success(let fetchedData):
                self?.weightDataSubject.onNext(fetchedData)
                onComplete(true)
            }
            
        }
    }
    
    func fetchCaloriesData(onComplete: @escaping(Bool) -> Void)  {
        guard let user = authenticateUserProfile() else { return }
        apiClient.fetchRegularData(forUserId: user.id, dataType: .calories) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
                onComplete(false)
            case .success(let fetchedData):
                self?.caloriesDataSubject.onNext(fetchedData)
                onComplete(true)
            }
            
        }
    }
    
    func fetchTrainingData(onComplete: @escaping(Bool) -> Void)  {
        guard let user = authenticateUserProfile() else { return }
        apiClient.fetchRegularData(forUserId: user.id, dataType: .trainings) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
                onComplete(false)
            case .success(let fetchedData):
                self?.trainingDataSubject.onNext(fetchedData)
                onComplete(true)
            }
        }
    }
    
    func fetchSleepData(onComplete: @escaping(Bool) -> Void)  {
        guard let user = authenticateUserProfile() else { return }
        apiClient.fetchRegularData(forUserId: user.id, dataType: .sleep) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
                onComplete(false)
            case .success(let fetchedData):
                self?.sleepDataSubject.onNext(fetchedData)
                onComplete(true)
            }
        }
    }
    
    func fetchPulseData(onComplete: @escaping(Bool) -> Void)  {
        guard let user = authenticateUserProfile() else { return }
        apiClient.fetchRegularData(forUserId: user.id, dataType: .pulse) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
                onComplete(false)
            case .success(let fetchedData):
                self?.pulseDataSubject.onNext(fetchedData)
                onComplete(true)
            }
        }
    }
    
    func fetchStepsData(onComplete: @escaping(Bool) -> Void)  {
        guard let user = authenticateUserProfile() else { return }
        apiClient.fetchRegularData(forUserId: user.id, dataType: .steps) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
                onComplete(false)
            case .success(let fetchedData):
                self?.stepsDataSubject.onNext(fetchedData)
                onComplete(true)
            }
        }
    }
    
    func fetchMeasurementsData(onComplete: @escaping(Bool) -> Void)  {
        guard let user = authenticateUserProfile() else { return }
        apiClient.fetchBodyMeasurementsData(forUserId: user.id, dataType: .measurements) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
                onComplete(false)
            case .success(let fetchedData):
                self?.measurementsDataSubject.onNext(fetchedData)
                onComplete(true)
            }
        }
    }
    
    func postStepsData(_ steps: Int, onComplete: @escaping(Bool) -> Void) {
        guard !isStepsDataPosted else { return }
        guard let user = authenticateUserProfile() else {
            onComplete(false)
            return
        }
        guard let lastValue = store.stepsData.last?.value else {
            onComplete(false)
            return
        }
        if lastValue != Float(steps) {
            apiClient.postStepsData(steps, forId: user.id) { [weak self] result in
                // notification + "synchronised steps data"
                if result {
                    self?.fetchStepsData { result in
                        if result {
                            self?.isStepsDataPosted = true
                        }
                        onComplete(result)
                    }
                }
                else {
                    debugPrint("Failed to update steps data.")
                    onComplete(false)
                }
            }
        }
        else {
            debugPrint("Steps data not modified.")
            onComplete(false)
        }
    }
    
    func postRegularData(type: DataProvider.DataType, value: Float, date: String, onComplete: @escaping(Bool) -> Void) {
        guard let user = authenticateUserProfile() else {
            onComplete(false)
            return
        }
        apiClient.postRegularData(type: type, value: value, date: date, userId: user.id) { [weak self] result in
            if result {
                switch type {
                case .weights:
                    self?.fetchWeightData { result in
                        onComplete(result)
                    }
                case .kcal:
                    self?.fetchCaloriesData { result in
                        onComplete(result)
                    }
                case .training:
                    self?.fetchTrainingData { result in
                        onComplete(result)
                    }
                case .sleep:
                    self?.fetchSleepData { result in
                        onComplete(result)
                    }
                case .pulse:
                    self?.fetchPulseData { result in
                        onComplete(result)
                    }
                case .steps:
                    self?.fetchStepsData { result in
                        onComplete(result)
                    }
                case .measurements:
                    self?.fetchMeasurementsData { result in
                        onComplete(result)
                    }
                }
            }
            else {
                debugPrint("Failed to update \(type.rawValue) data.")
                onComplete(result)
            }
        }
    }
    
    func postBodyData(values: [Float], date: String, onComplete: @escaping(Bool) -> Void) {
        guard let user = authenticateUserProfile() else {
            onComplete(false)
            return
        }
        
        apiClient.postBodyData(values: values, forId: user.id) { [weak self] result in
            // notification + "synchronised steps data"
            if result {
                self?.fetchMeasurementsData { result2 in
                    onComplete(result2)
                }
            }
            else {
                debugPrint("Failed to update body measurements data.")
                onComplete(false)
            }
        }
    }
}
