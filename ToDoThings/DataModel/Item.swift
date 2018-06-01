//
//  Item.swift
//  ToDoThings
//
//  Created by User on 31/05/18.
//  Copyright © 2018 Kranthikiran. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
   @objc dynamic var title: String = ""
   @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    
    var parentCategory = LinkingObjects(fromType: Categories.self, property:"items")
}
