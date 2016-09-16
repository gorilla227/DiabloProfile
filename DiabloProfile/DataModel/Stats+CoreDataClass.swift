//
//  Stats+CoreDataClass.swift
//  DiabloProfile
//
//  Created by Andy on 16/9/15.
//  Copyright © 2016年 Andy Xu. All rights reserved.
//

import Foundation
import CoreData


public class Stats: NSManagedObject {
    
    // Insert code here to add functionality to your managed object subclass
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(dictionary: [String: AnyObject], context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: "Stats", in: context)!
        super.init(entity: entity, insertInto: context)
        
        if let damage = dictionary[Keys.Damage] as? NSNumber {
            self.damage = damage
        }
        
        if let dexterity = dictionary[Keys.Dexterity] as? NSNumber {
            self.dexterity = dexterity
        }
        
        if let healing = dictionary[Keys.Healing] as? NSNumber {
            self.healing = healing
        }
        
        if let intelligence = dictionary[Keys.Intelligence] as? NSNumber {
            self.intelligence = intelligence
        }
        
        if let life = dictionary[Keys.Life] as? NSNumber {
            self.life = life
        }
        
        if let primaryResource = dictionary[Keys.PrimaryResource] as? NSNumber {
            self.primaryResource = primaryResource
        }
        
        if let secondaryResource = dictionary[Keys.SecondaryResource] as? NSNumber {
            self.secondaryResource = secondaryResource
        }
        
        if let strength = dictionary[Keys.Strength] as? NSNumber {
            self.strength = strength
        }
        
        if let toughness = dictionary[Keys.Toughness] as? NSNumber {
            self.toughness = toughness
        }
        
        if let vitality = dictionary[Keys.Vitality] as? NSNumber {
            self.vitality = vitality
        }
        
        if let hero = dictionary[Keys.Hero] as? Hero {
            self.hero = hero
        }
    }
}

extension Stats {
    struct Keys {
        static let EntityName = "Stats"
        static let Damage = "damage"
        static let Dexterity = "dexterity"
        static let Healing = "healing"
        static let Intelligence = "intelligence"
        static let Life = "life"
        static let PrimaryResource = "primaryResource"
        static let SecondaryResource = "secondaryResource"
        static let Strength = "strength"
        static let Toughness = "toughness"
        static let Vitality = "vitality"
        static let Hero = "hero"
    }
}
