//
//  Rune+CoreDataClass.swift
//  DiabloProfile
//
//  Created by Andy on 16/9/15.
//  Copyright © 2016年 Andy Xu. All rights reserved.
//

import Foundation
import CoreData


public class Rune: Spell {
    
    // Insert code here to add functionality to your managed object subclass
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    override init(dictionary: [String : Any], entityName: String, context: NSManagedObjectContext) {
        super.init(dictionary: dictionary, entityName: entityName, context: context)
        
        if let type = dictionary[Keys.RuneType] as? String {
            self.runeType = type
        }
        if let skill = dictionary[Keys.Skill] as? Skill {
            self.skill = skill
        }
    }
    
    func runeIconImagePath(_ small: Bool) -> String? {
        if small {
            if let runeType = runeType {
                return "rune_\(runeType)_small.png"
            } else {
                return nil
            }
        } else {
            if let runeType = runeType {
                return "rune_\(runeType).png"
            } else {
                return nil
            }
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
