//
//  Catagory.swift
//  ToDoey
//
//  Created by Pankaj Sharma on 7/15/18.
//  Copyright © 2018 Pankaj Sharma. All rights reserved.
//

import Foundation
import RealmSwift

class Catagory: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var cellColor: String = ""
    let items = List<Item>()
    
}
