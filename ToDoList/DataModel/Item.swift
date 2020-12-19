//
//  Item.swift
//  ToDoList
//
//  Created by Gregor Kramer on 19.12.2020.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var createdDate: Date = Date()
}
