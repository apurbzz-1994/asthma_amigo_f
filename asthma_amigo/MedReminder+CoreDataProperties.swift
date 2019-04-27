//
//  MedReminder+CoreDataProperties.swift
//  asthma_amigo
//
//  Created by Apurba Nath on 24/4/19.
//  Copyright © 2019 Apurba Nath. All rights reserved.
//
//

import Foundation
import CoreData


extension MedReminder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MedReminder> {
        return NSFetchRequest<MedReminder>(entityName: "MedReminder")
    }

    @NSManaged public var hour: String?
    @NSManaged public var minute: String?
    @NSManaged public var second: String?
    @NSManaged public var reminderID: String?
    @NSManaged public var forMed: Medicine?

}
