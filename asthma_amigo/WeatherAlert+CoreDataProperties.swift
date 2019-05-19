//
//  WeatherAlert+CoreDataProperties.swift
//  
//
//  Created by Apurba Nath on 11/5/19.
//
//

import Foundation
import CoreData


extension WeatherAlert {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherAlert> {
        return NSFetchRequest<WeatherAlert>(entityName: "WeatherAlert")
    }

    @NSManaged public var humidity: String?
    @NSManaged public var temperature: String?
    @NSManaged public var dateAndTime: String?
    @NSManaged public var qualityAir: String?
    @NSManaged public var isSeen: Bool
    @NSManaged public var belongToDiary: Diary?

}
