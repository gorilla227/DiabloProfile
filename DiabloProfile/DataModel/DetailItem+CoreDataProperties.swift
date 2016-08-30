//
//  DetailItem+CoreDataProperties.swift
//  DiabloProfile
//
//  Created by Andy Xu on 8/30/16.
//  Copyright © 2016 Andy Xu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension DetailItem {

    @NSManaged var accountBound: NSNumber?
    @NSManaged var armor: NSNumber?
    @NSManaged var attacksPerSecond: NSNumber?
    @NSManaged var attacksPerSecondText: String?
    @NSManaged var damageRange: String?
    @NSManaged var displayColor: String?
    @NSManaged var dps: NSNumber?
    @NSManaged var elementalType: String?
    @NSManaged var flavor: String?
    @NSManaged var icon: NSData?
    @NSManaged var iconKey: String?
    @NSManaged var id: String?
    @NSManaged var itemLevel: NSNumber?
    @NSManaged var locale: String?
    @NSManaged var name: String?
    @NSManaged var requiredLevel: NSNumber?
    @NSManaged var setItemsEquipped: NSObject?
    @NSManaged var tooltipParams: String?
    @NSManaged var typeID: String?
    @NSManaged var typeName: String?
    @NSManaged var typeTwoHanded: NSNumber?
    @NSManaged var attributes: NSSet?
    @NSManaged var basicItem: BasicItem?
    @NSManaged var gems: NSSet?

}
