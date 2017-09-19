//
//  helper.swift
//  Todo app with realm
//
//  Created by samet sahin on 18.09.2017.
//  Copyright © 2017 samet sahin. All rights reserved.
//

import Foundation
import RealmSwift

class helper {
    
    
    func AppFinishLoading()
    {
        
        // populating lists and priorities 
        
            populatePriorities()
            populateLists()
        
    }
    
    func populateLists()
    {
        let realm = try! Realm()
        let lists : Results<list> = { realm.objects(list.self) } ()
        
        if lists.count == 0
        {
            try! realm.write() {
                let defaultLists = ["To-Do", "Watch list", "Groceries" ]
                
                for listItem in defaultLists
                {
                    let newListItem = list()
                    newListItem.name = listItem
                    realm.add(newListItem)
                }
            }
        }
        
    }
    
    func populatePriorities() {
        let realm = try! Realm()
        let priorities: Results<priority> = { realm.objects(priority.self) }()
        
        if priorities.count == 0
        {
            try! realm.write() {
                
                let defaultPriorities = ["1", "2", "3" ]
                
                for priorityLevel in defaultPriorities {
                    let newPriority = priority()
                    newPriority.level = priorityLevel
                    realm.add(newPriority)
                 }
            }
        }
    }
    
}
