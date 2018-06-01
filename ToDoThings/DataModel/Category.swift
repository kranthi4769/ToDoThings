//
//  Category.swift
//  ToDoThings
//
//  Created by User on 31/05/18.
//  Copyright © 2018 Kranthikiran. All rights reserved.
//

import Foundation
import RealmSwift

class Categories: Object
{
    @objc dynamic var name : String = ""
    
    // here we are using the inverse relationship Items in categories and categories in item file
    let items = List<Item>()
}
