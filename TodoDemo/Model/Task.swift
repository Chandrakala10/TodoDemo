//
//  Task.swift
//  TodoDemo
//
//  Created by Chandrakala Neerukonda on 9/18/17.
//  Copyright © 2017 Chandrakala Neerukonda. All rights reserved.
//

import Foundation
import RealmSwift

@objc enum Priority: Int {
    case one
    case two
    case three
}

class Task: Object {
    dynamic var name: String = ""
    dynamic var createdAt = Date()
    dynamic var notes: String = ""
    dynamic var priority: Priority = .one
    
    override static func primaryKey() -> String? {
        return "name"
    }
    
    convenience init(name: String, notes: String = "", priority: Priority = .one) {
        self.init()
        self.name = name
        self.notes = notes
        self.priority = priority
    }
}
