//
//  ItemAttribute+CoreDataProperties.swift
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

extension ItemAttribute {

    @NSManaged var affixType: String?
    @NSManaged var category: String?
    @NSManaged var color: String?
    @NSManaged var text: String?
    @NSManaged var gem: Gem?
    @NSManaged var item: DetailItem?
    @NSManaged var setBonus: SetBonus?

}
