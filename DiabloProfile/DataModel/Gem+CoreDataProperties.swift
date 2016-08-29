//
//  Gem+CoreDataProperties.swift
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

extension Gem {

    @NSManaged var isGem: NSNumber?
    @NSManaged var isJewel: NSNumber?
    @NSManaged var jewelRank: NSNumber?
    @NSManaged var jewelSecondaryEffectUnlockRank: NSNumber?
    @NSManaged var attributes: NSOrderedSet?
    @NSManaged var basicItem: BasicItem?

}
