//
//  Networking.swift
//  ToDoey
//
//  Created by Pankaj Sharma on 7/14/18.
//  Copyright © 2018 Pankaj Sharma. All rights reserved.
//

import UIKit

struct Networking {
    static let shared = Networking()
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

}
