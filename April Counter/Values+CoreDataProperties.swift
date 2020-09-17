//
//  Values+CoreDataProperties.swift
//  April Counter
//
//  Created by Chester de Wolfe on 4/2/20.
//  Copyright © 2020 Chester de Wolfe. All rights reserved.
//
//

import Foundation
import CoreData


extension Values {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Values> {
        return NSFetchRequest<Values>(entityName: "Values")
    }

    @NSManaged public var milesRun: Double
    @NSManaged public var milesBiked: Double
    @NSManaged public var pushups: Int16
    @NSManaged public var sitUps: Int16
    @NSManaged public var milesWalked: Double

}
