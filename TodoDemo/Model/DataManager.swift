//
//  DataManager.swift
//  TodoDemo
//
//  Created by Chandrakala Neerukonda on 9/18/17.
//  Copyright © 2017 Chandrakala Neerukonda. All rights reserved.
//

import Foundation

enum SortOptions: Int {
    case creadtedDate
    case hightoLowPriority
    case lowtoHignPriority
    case none
    
    func keyAndAscending() -> (String, Bool) {
        switch self {
        case .creadtedDate:
            return ("createdAt", false)
        case .hightoLowPriority:
            return ("priority", false)
        case .lowtoHignPriority:
            return ("priority", true)
        case .none:
            return ("", false)
        }
    }
}

enum StorageType {
    case realm
    // case local (for local storage)
    // case coreData (for local storage)
    
    func dataManager() -> DataManager {
        switch self{
        case .realm:
            return RealmManager.shared
        }
    }
}

protocol DataManager {
    static var shared: DataManager { set get }
    func add(_ task: Task) throws
    func delete(_ task: Task) throws
    func update(old task: Task, withNew new: Task) throws
    func tasks() -> [Task]
    func sort(_ option: SortOptions)
}
