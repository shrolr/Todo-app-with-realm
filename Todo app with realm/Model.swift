//
//  Model.swift
//  Todo app with realm
//
//  Created by samet sahin on 18.09.2017.
//  Copyright © 2017 samet sahin. All rights reserved.
//

import Foundation
import RealmSwift
class todoItem: Object {
    dynamic var ID = UUID().uuidString
    dynamic var name = ""
    dynamic var priorityLevel :  priority!
    dynamic var list : list!
    dynamic var completed = false
    dynamic var shouldBeCompletedAt : Double = 0
 }


class priority: Object  {
    dynamic var level = ""
    
 }

class list : Object {
    dynamic var name = ""
}
