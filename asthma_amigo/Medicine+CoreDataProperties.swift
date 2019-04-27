//
//  Medicine+CoreDataProperties.swift
//  asthma_amigo
//
//  Created by Apurba Nath on 24/4/19.
//  Copyright © 2019 Apurba Nath. All rights reserved.
//
//

import Foundation
import CoreData


extension Medicine {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Medicine> {
        return NSFetchRequest<Medicine>(entityName: "Medicine")
    }

    @NSManaged public var dosage: String?
    @NSManaged public var freq: String?
    @NSManaged public var isTablet: Bool
    @NSManaged public var name: String?
    @NSManaged public var stock: String?
    @NSManaged public var type: String?
    @NSManaged public var isPrescribed: ActionPlan?
    @NSManaged public var hasMed: NSSet?

}

// MARK: Generated accessors for hasMed
extension Medicine {

    @objc(addHasMedObject:)
    @NSManaged public func addToHasMed(_ value: MedReminder)

    @objc(removeHasMedObject:)
    @NSManaged public func removeFromHasMed(_ value: MedReminder)

    @objc(addHasMed:)
    @NSManaged public func addToHasMed(_ values: NSSet)

    @objc(removeHasMed:)
    @NSManaged public func removeFromHasMed(_ values: NSSet)

}
