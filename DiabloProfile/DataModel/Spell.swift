//
//  Spell.swift
//  DiabloProfile
//
//  Created by Andy Xu on 8/15/16.
//  Copyright © 2016 Andy Xu. All rights reserved.
//

import Foundation
import CoreData


class Spell: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(dictionary: [String: AnyObject], entityName: String, context: NSManagedObjectContext) {
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
