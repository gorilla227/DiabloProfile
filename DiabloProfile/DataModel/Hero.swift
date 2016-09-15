//
//  Hero.swift
//  DiabloProfile
//
//  Created by Andy Xu on 8/15/16.
//  Copyright © 2016 Andy Xu. All rights reserved.
//

import Foundation
import CoreData


class Hero: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(dictionary: [String: Any], context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: Keys.EntityName, in: context)!
        super.init(entity:entity, insertInto: context)
        
        if let battleTag = dictionary[Keys.BattleTag] as? String {
            self.battleTag = battleTag
        }
        
        if let region = dictionary[Keys.Region] as? String {
            self.region = region
        }
        
        if let locale = dictionary[Keys.Locale] as? String {
            self.locale = locale
        }
        
        if let id = dictionary[Keys.ID] as? NSNumber {
            self.id = id
        }
        
        if let dead = dictionary[Keys.Dead] as? Bool {
            self.dead = NSNumber(value: dead as Bool)
        }
        
        if let gender = dictionary[Keys.Gender] as? Bool {
            self.gender = NSNumber(value: gender as Bool)
        }
        
        if let hardcore = dictionary[Keys.Hardcore] as? Bool {
            self.hardcore = NSNumber(value: hardcore as Bool)
        }
        
        if let heroClass = dictionary[Keys.HeroClass] as? String {
            self.heroClass = heroClass
        }
        
        if let lastUpdated = dictionary[Keys.LastUpdated] as? NSNumber {
            self.lastUpdated = lastUpdated
        }
        
        if let level = dictionary[Keys.Level] as? NSNumber {
            self.level = level
        }
        
        if let name = dictionary[Keys.Name] as? String {
            self.name = name
        }
        
        if let paragonLevel = dictionary[Keys.ParagonLevel] as? NSNumber {
            self.paragonLevel = paragonLevel
        }
        
        if let seasonal = dictionary[Keys.Seasonal] as? Bool {
            self.seasonal = NSNumber(value: seasonal as Bool)
        }
        
        if let seasonCreated = dictionary[Keys.SeasonCreated] as? NSNumber {
            self.seasonCreated = seasonCreated
        }
        
        if let activeSkills = dictionary[Keys.ActiveSkills] as? [[String: AnyObject]] {
            var skills = [Skill]()
            for skillDict in activeSkills {
                let skill = Skill(dictionary: skillDict, entityName: "Skill", context: context)
                skills.append(skill)
            }
            self.activeSkills = NSMutableOrderedSet(array: skills)
        }
        
        if let passiveSkills = dictionary[Keys.PassiveSkills] as? [[String: AnyObject]] {
            var skills = [Skill]()
            for skillDict in passiveSkills {
                let skill = Skill(dictionary: skillDict, entityName: "Skill", context: context)
                skills.append(skill)
            }
            self.passiveSkills = NSMutableOrderedSet(array: skills)
        }
        
        if let statsDict = dictionary[Keys.Stats] as? [String: AnyObject] {
            let stats = Stats(dictionary: statsDict, context: context)
            self.stats = stats
        }
        
        if let items = dictionary[Keys.Items] as? [[String: AnyObject]] {
            var basicItems = [BasicItem]()
            for itemDict in items {
                let basicItem = BasicItem(dictionary: itemDict, context: context)
                basicItems.append(basicItem)
            }
            self.items = NSSet(array: basicItems)
        }
    }
    
    class func titleBackgroundImagePath(classKey: String, genderKey: String) -> String {
        let imageFilePath = "\(classKey)-\(genderKey)-background.jpg"
        return imageFilePath
    }
    
    func titleBackgroundImagePath() -> String? {
        if let classKey = heroClass, let gender = gender?.boolValue {
            let genderKey = gender ? "female" : "male"
            return Hero.titleBackgroundImagePath(classKey: classKey, genderKey: genderKey)
        } else {
            return nil
        }
    }
    
    class func classIconImagePath(classKey: String, genderKey: String) -> String {
        let imageFilePath = "\(classKey)_\(genderKey).png"
        return imageFilePath
    }
    
    func classIconImagePath() -> String? {
        if let classKey = heroClass, let gender = gender?.boolValue {
            let genderKey = gender ? "female" : "male"
            return Hero.classIconImagePath(classKey: classKey, genderKey: genderKey)
        } else {
            return nil
        }
    }
}

extension Hero {
    struct Keys {
        static let EntityName = "Hero"
        static let Region = "region"
        static let Locale = "locale"
        static let BattleTag = "battleTag"
        static let ID = "id"
        static let Dead = "dead"
        static let Gender = "gender"
        static let Hardcore = "hardcore"
        static let HeroClass = "heroClass"
        static let LastUpdated = "lastUpdated"
        static let Level = "level"
        static let Name = "name"
        static let ParagonLevel = "paragonLevel"
        static let Seasonal = "seasonal"
        static let SeasonCreated = "seasonCreated"
        static let ActiveSkills = "activeSkills"
        static let PassiveSkills = "passiveSkills"
        static let Stats = "stats"
        static let Items = "items"
    }
}
