//
//  TaskManager.swift
//  TodoDemo
//
//  Created by Chandrakala Neerukonda on 9/18/17.
//  Copyright © 2017 Chandrakala Neerukonda. All rights reserved.
//

import Foundation
import RealmSwift

final class RealmManager: DataManager{
    static var shared: DataManager = RealmManager()
    private let realm = try! Realm()
    
    private var list: Results<Task> {
        return realm.objects(Task.self)
    }
    
    private var sortedList: Results<Task>?
    
    func add(_ task: Task) throws {
        try realm.write {
            realm.add(task, update: true)
        }
    }
    
    func delete(_ task: Task) throws {
        try realm.write {
         realm.delete(task)
        }
    }
    
    func tasks() -> [Task] {
        guard let sortedList = sortedList else {
            return list.map { return $0 }
        }
        return sortedList.map { return $0 }
    }
    
    func sort(_ option: SortOptions) {
        guard .none != option else {
            sortedList = nil
            return
        }
        let (key, ascending) = option.keyAndAscending()
        sortedList = list.sorted(byKeyPath: key, ascending: ascending)
    }
}
