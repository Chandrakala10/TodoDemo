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
    dynamic var name = ""
    dynamic var createdAt = Date()
    dynamic var notes = ""
    dynamic var priority: Priority = .three
    
    override static func primaryKey() -> String? {
        return "name"
    }
}
