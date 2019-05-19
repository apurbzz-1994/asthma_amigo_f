//
//  Diary+CoreDataProperties.swift
//  
//
//  Created by Apurba Nath on 11/5/19.
//
//

import Foundation
import CoreData


extension Diary {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Diary> {
        return NSFetchRequest<Diary>(entityName: "Diary")
    }

    @NSManaged public var comments: String?
    @NSManaged public var day: String?
    @NSManaged public var hour: String?
    @NSManaged public var humidity: String?
    @NSManaged public var lat: String?
    @NSManaged public var location: String?
    @NSManaged public var long: String?
    @NSManaged public var minute: String?
    @NSManaged public var month: String?
    @NSManaged public var quality: String?
    @NSManaged public var temp: String?
    @NSManaged public var trigger: String?
    @NSManaged public var year: String?
    @NSManaged public var hasAlert: NSSet?

}

// MARK: Generated accessors for hasAlert
extension Diary {

    @objc(addHasAlertObject:)
    @NSManaged public func addToHasAlert(_ value: WeatherAlert)

    @objc(removeHasAlertObject:)
    @NSManaged public func removeFromHasAlert(_ value: WeatherAlert)

    @objc(addHasAlert:)
    @NSManaged public func addToHasAlert(_ values: NSSet)

    @objc(removeHasAlert:)
    @NSManaged public func removeFromHasAlert(_ values: NSSet)

}
