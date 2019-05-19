//
//  WeatherAlert+CoreDataProperties.swift
//  asthma_amigo
//
//  Created by Apurba Nath on 19/5/19.
//  Copyright © 2019 Apurba Nath. All rights reserved.
//
//

import Foundation
import CoreData


extension WeatherAlert {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherAlert> {
        return NSFetchRequest<WeatherAlert>(entityName: "WeatherAlert")
    }

    @NSManaged public var dateAndTime: String?
    @NSManaged public var humidity: String?
    @NSManaged public var isSeen: Bool
    @NSManaged public var qualityAir: String?
    @NSManaged public var temperature: String?
    @NSManaged public var belongToDiary: Diary?

}
