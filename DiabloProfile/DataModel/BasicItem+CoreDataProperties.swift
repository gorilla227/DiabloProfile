//
//  BasicItem+CoreDataProperties.swift
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

extension BasicItem {

    @NSManaged var displayColor: String?
    @NSManaged var icon: NSData?
    @NSManaged var iconKey: String?
    @NSManaged var id: String?
    @NSManaged var name: String?
    @NSManaged var setItemsEquipped: [String]?
    @NSManaged var slot: String?
    @NSManaged var tooltipParams: String?
    @NSManaged var detailItem: DetailItem?
    @NSManaged var gem: Gem?
    @NSManaged var hero: Hero?
    @NSManaged var set: ItemSet?

}
