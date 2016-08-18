//
//  Rune+CoreDataProperties.swift
//  DiabloProfile
//
//  Created by Andy Xu on 8/18/16.
//  Copyright © 2016 Andy Xu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Rune {

    @NSManaged var runeType: String?
    @NSManaged var skill: Skill?

}
