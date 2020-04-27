//
//  CaloriesViewModel.swift
//  fit-swift-client
//
//  Created by admin on 13/01/2020.
//  Copyright © 2020 Dominik Urbaez Gomez. All rights reserved.
//

import Foundation
import UIKit

class CaloriesViewModel {
    private weak var vc: CaloriesViewController?
    private var store: DataStore?
    
    var caloriesArray = [Record]()
    
    init() {
        store = mainStore.dataStore
        if let store = store {
            caloriesArray = store.caloriesData
            store.caloriesViewModel = self
        }
        updateData()
    }
    
    func fetchCaloriesData() -> [Record] {
        return caloriesArray
    }
    
    func fetchCaloriesDataForCell(forIndex index: Int) -> Record {
        let record = caloriesArray[index]
        return record
    }
    
    func updateData() {
        if let store = store {
            caloriesArray = store.caloriesData
        }
    }
}
