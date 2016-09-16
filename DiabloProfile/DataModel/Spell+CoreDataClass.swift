//
//  Spell+CoreDataClass.swift
//  DiabloProfile
//
//  Created by Andy on 16/9/15.
//  Copyright © 2016年 Andy Xu. All rights reserved.
//

import Foundation
import CoreData


public class Spell: NSManagedObject {
    
    // Insert code here to add functionality to your managed object subclass
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(dictionary: [String: Any], entityName: String, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: context)!
        super.init(entity: entity, insertInto: context)
        
        if let slug = dictionary[Keys.Slug] as? String {
            self.slug = slug
        }
        
        if let name = dictionary[Keys.Name] as? String{
            self.name = name
        }
        
        if let fullDescription = dictionary[Keys.FullDescription] as? String {
            self.fullDescription = fullDescription
        }
        
        if let simpleDescription = dictionary[Keys.SimpleDescription] as? String {
            self.simpleDescription = simpleDescription
        }
    }
}

extension Spell {
    struct Keys {
        static let EntityName = "Spell"
        static let Slug = "slug"
        static let Name = "name"
        static let FullDescription = "fullDescription"
        static let SimpleDescription = "simpleDescription"
    }
}
