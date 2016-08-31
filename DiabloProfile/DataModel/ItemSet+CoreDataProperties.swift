//
//  ItemSet+CoreDataProperties.swift
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

extension ItemSet {

    @NSManaged var name: String?
    @NSManaged var slug: String?
    @NSManaged var items: NSSet?
    @NSManaged var setBonus: NSOrderedSet?
    @NSManaged var detailItem: DetailItem?

}
