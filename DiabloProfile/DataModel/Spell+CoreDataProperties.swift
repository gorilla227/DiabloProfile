//
//  Spell+CoreDataProperties.swift
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

extension Spell {

    @NSManaged var slug: String?
    @NSManaged var name: String?
    @NSManaged var fullDescription: String?
    @NSManaged var simpleDescription: String?

}
