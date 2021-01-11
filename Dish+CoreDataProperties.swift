//
//  Dish+CoreDataProperties.swift
//  LunchAndDinner
//
//  Created by 満尾希美 on 4/1/21.
//
//

import Foundation
import CoreData


extension Dish {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Dish> {
        return NSFetchRequest<Dish>(entityName: "Dish")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var type: String?
    @NSManaged public var name: String?
    @NSManaged public var last: Date?

}

extension Dish : Identifiable {

}
