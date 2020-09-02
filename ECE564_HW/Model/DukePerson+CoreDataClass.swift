//
//  DukePerson+CoreDataClass.swift
//  ECE564_HW
//
//  Created by Jingyi on 2020/8/30.
//  Copyright © 2020 ECE564. All rights reserved.
//
//

import Foundation
import CoreData

@objc(DukePerson)
public class DukePerson: NSManagedObject {
    public override var description: String {
        var pronouns = [String]()
        if (self.gender == Gender.Male) {
            pronouns = ["He", "His"]
        }
        else {
            pronouns = ["She", "Her"]
        }
        var des : String = ""
        if self.firstName != nil && self.lastName != nil {
            des = "\(self.firstName!) \(self.lastName!). "
        }
        // where from
        if self.whereFrom != nil && self.whereFrom != "" {
            des += pronouns[0] + " is from \(self.whereFrom!). "
        }
        // role
        des += pronouns[0] + " is a \(self.role). "
        // program info
        if self.program != nil && self.program != "" && self.program != "NA" {
            des += pronouns[0] + " is working on the \(self.program!) degree. "
        }
        // hobbies
        if self.hobbies != nil && self.hobbies != "" {
            des += pronouns[0] + " likes \(self.hobbies!). "
        }
        // languages
        if self.languages != nil && self.languages != ""{
            des += pronouns[0] + " is proficient in \(self.languages!). "
        }
        // email
        if self.email != nil && self.email != "" {
            des += pronouns[1] + " email is \(self.email!). "
        }
        return des
    }
    
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
