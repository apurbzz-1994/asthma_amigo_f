//
//  ActionPlan+CoreDataProperties.swift
//  asthma_amigo
//
//  Created by Apurba Nath on 4/4/19.
//  Copyright © 2019 Apurba Nath. All rights reserved.
//
//

import Foundation
import CoreData


extension ActionPlan {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ActionPlan> {
        return NSFetchRequest<ActionPlan>(entityName: "ActionPlan")
    }

    @NSManaged public var type: String?
    @NSManaged public var useSpencer: Bool
    @NSManaged public var contains: NSSet?
    @NSManaged public var info: String?

}

// MARK: Generated accessors for contains
extension ActionPlan {

    @objc(addContainsObject:)
    @NSManaged public func addToContains(_ value: Medicine)

    @objc(removeContainsObject:)
    @NSManaged public func removeFromContains(_ value: Medicine)

    @objc(addContains:)
    @NSManaged public func addToContains(_ values: NSSet)

    @objc(removeContains:)
    @NSManaged public func removeFromContains(_ values: NSSet)

}
