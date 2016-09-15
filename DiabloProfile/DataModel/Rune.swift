//
//  Rune.swift
//  DiabloProfile
//
//  Created by Andy Xu on 8/15/16.
//  Copyright © 2016 Andy Xu. All rights reserved.
//

import Foundation
import CoreData

class Rune: Spell {

// Insert code here to add functionality to your managed object subclass
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    override init(dictionary: [String : AnyObject], entityName: String, context: NSManagedObjectContext) {
        super.init(dictionary: dictionary, entityName: entityName, context: context)
        
        if let type = dictionary[Keys.RuneType] as? String {
            self.runeType = type
        }
        if let skill = dictionary[Keys.Skill] as? Skill {
            self.skill = skill
        }
    }
    
    func runeIconImagePath() -> String? {
        if let runeType = runeType {
            return "rune_\(runeType).png"
        } else {
            return nil
        }
    }
}

extension Rune {
    struct Keys {
        static let EntityName = "Rune"
        static let Skill = "skill"
        static let RuneType = "type"
    }
}
