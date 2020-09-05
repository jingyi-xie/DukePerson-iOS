//
//  DukePerson+CoreDataProperties.swift
//  ECE564_HW
//
//  Created by Jingyi on 2020/9/3.
//  Copyright © 2020 ECE564. All rights reserved.
//
//

import Foundation
import CoreData


extension DukePerson {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DukePerson> {
        return NSFetchRequest<DukePerson>(entityName: "DukePerson")
    }

    @NSManaged public var email: String?
    @NSManaged public var firstName: String?
    @NSManaged public var genderValue: String?
    @NSManaged public var hobbies: [String]?
    @NSManaged public var languages: [String]?
    @NSManaged public var lastName: String?
    @NSManaged public var program: String?
    @NSManaged public var roleValue: String?
    @NSManaged public var team: String?
    @NSManaged public var whereFrom: String?

}
