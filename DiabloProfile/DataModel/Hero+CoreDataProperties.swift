//
//  Hero+CoreDataProperties.swift
//  DiabloProfile
//
//  Created by Andy Xu on 8/29/16.
//  Copyright © 2016 Andy Xu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Hero {

    @NSManaged var battleTag: String?
    @NSManaged var dead: NSNumber?
    @NSManaged var gender: NSNumber?
    @NSManaged var hardcore: NSNumber?
    @NSManaged var heroClass: String?
    @NSManaged var id: NSNumber?
    @NSManaged var lastUpdated: NSNumber?
    @NSManaged var level: NSNumber?
    @NSManaged var locale: String?
    @NSManaged var name: String?
    @NSManaged var paragonLevel: NSNumber?
    @NSManaged var region: String?
    @NSManaged var seasonal: NSNumber?
    @NSManaged var seasonCreated: NSNumber?
    @NSManaged var activeSkills: NSOrderedSet?
    @NSManaged var items: NSSet?
    @NSManaged var passiveSkills: NSOrderedSet?
    @NSManaged var stats: Stats?

}
