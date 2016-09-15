//
//  Skill+CoreDataProperties.swift
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

extension Skill {

    @NSManaged var iconURL: String?
    @NSManaged var categorySlug: String?
    @NSManaged var flavor: String?
    @NSManaged var icon: Data?
    @NSManaged var rune: Rune?
    @NSManaged var heroA: Hero?
    @NSManaged var heroP: Hero?

}
