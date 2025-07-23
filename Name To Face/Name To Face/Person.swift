//
//  Person.swift
//  Name To Face
//
//  Created by Dip on 22/7/25.
//

import UIKit

class Person: NSObject {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
