//
//  DukePerson+CoreDataClass.swift
//  ECE564_HW
//
//  Created by Jaryn on 2020/8/30.
//  Copyright © 2020 ECE564. All rights reserved.
//
//

import Foundation
import CoreData

@objc(DukePerson)
public class DukePerson: NSManagedObject {
    var gender: Gender {
        get {
            return Gender(rawValue: self.genderValue!)!
        }
        set {
            self.genderValue = newValue.rawValue
        }
    }
    
    var role: DukeRole {
        get {
            return DukeRole(rawValue: self.roleValue!)!
        }
        set {
            self.roleValue = newValue.rawValue
        }
    }
}
