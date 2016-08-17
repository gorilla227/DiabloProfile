//
//  Stats+CoreDataProperties.swift
//  DiabloProfile
//
//  Created by Andy Xu on 8/15/16.
//  Copyright © 2016 Andy Xu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Stats {

    @NSManaged var life: NSNumber?
    @NSManaged var damage: NSNumber?
    @NSManaged var toughness: NSNumber?
    @NSManaged var healing: NSNumber?
    @NSManaged var strength: NSNumber?
    @NSManaged var dexterity: NSNumber?
    @NSManaged var vitality: NSNumber?
    @NSManaged var intelligence: NSNumber?
    @NSManaged var primaryResource: NSNumber?
    @NSManaged var secondaryResource: NSNumber?
    @NSManaged var hero: NSManagedObject?

}
