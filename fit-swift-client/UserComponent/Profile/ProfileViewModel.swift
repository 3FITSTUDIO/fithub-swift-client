//
//  ProfileViewModel.swift
//  fit-swift-client
//
//  Created by admin on 18/05/2020.
//  Copyright © 2020 Dominik Urbaez Gomez. All rights reserved.
//

import Foundation

class ProfileViewModel {
    
    private var userStore: UserStore?
    private var dataStore: DataStore?
    weak var vc: ProfileViewController?
    
    init() {
        dataStore = mainStore.dataStore
        userStore = mainStore.userStore
    }
    
    func clearProfileOnLogout() {
        if let userStore = userStore, let dataStore = dataStore {
            userStore.clearProfileOnLogout()
            dataStore.clearCurrentData()
        }
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
    
    func getUserName() -> String {
        guard let user = authenticateUserProfile() else { return "" }
        return user.firstName
    }
    
    func triggerNotificationsFetch(onComplete: @escaping() -> Void) {
        dataStore?.notificationsManager.updateAllNotifications {
            onComplete()
        }
    }
    
    // MARK: Settings Handler
    
    func saveSettings(onComplete: @escaping() -> Void) {
        onComplete()
    }
}