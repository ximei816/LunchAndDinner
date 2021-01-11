//
//  Meal+CoreDataProperties.swift
//  LunchAndDinner
//
//  Created by 満尾希美 on 6/1/21.
//
//

import Foundation
import CoreData


extension Meal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Meal> {
        return NSFetchRequest<Meal>(entityName: "Meal")
    }

    @NSManaged public var dishes: String?
    @NSManaged public var dt: Date?
    @NSManaged public var ld: String?

}

extension Meal : Identifiable {

}
