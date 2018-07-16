//
//  Item.swift
//  ToDoey
//
//  Created by Pankaj Sharma on 7/15/18.
//  Copyright © 2018 Pankaj Sharma. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    
    var parentCatagory = LinkingObjects(fromType: Catagory.self, property: "items")
    
}
