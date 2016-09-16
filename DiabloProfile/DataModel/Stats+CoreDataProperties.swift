//
//  Stats+CoreDataProperties.swift
//  DiabloProfile
//
//  Created by Andy on 16/9/15.
//  Copyright © 2016年 Andy Xu. All rights reserved.
//

import Foundation
import CoreData


extension Stats {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Stats> {
        return NSFetchRequest<Stats>(entityName: "Stats");
    }

    @NSManaged public var damage: NSNumber?
    @NSManaged public var dexterity: NSNumber?
    @NSManaged public var healing: NSNumber?
    @NSManaged public var intelligence: NSNumber?
    @NSManaged public var life: NSNumber?
    @NSManaged public var primaryResource: NSNumber?
    @NSManaged public var secondaryResource: NSNumber?
    @NSManaged public var strength: NSNumber?
    @NSManaged public var toughness: NSNumber?
    @NSManaged public var vitality: NSNumber?
    @NSManaged public var hero: Hero?

}
