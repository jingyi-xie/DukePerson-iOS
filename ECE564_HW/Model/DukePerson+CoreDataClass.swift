//
//  DukePerson+CoreDataClass.swift
//  ECE564_HW
//
//  Created by Jingyi on 2020/9/3.
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
//        if self.firstName != nil && self.lastName != nil {
//            des = "\(self.firstName!) \(self.lastName!). "
//        }
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
        if self.hobbies.count != 0 && self.hobbies[0] != "" {
            let hobbies_str = self.hobbies.count >= 2 ? self.hobbies.dropLast().joined(separator: ", ") + " and " + self.hobbies.last! : self.hobbies[0]
            des += pronouns[0] + " likes \(hobbies_str). "
        }
        // languages
        if self.languages.count != 0 && self.languages[0] != "" {
            let languages_str = self.languages.count >= 2 ? self.languages.dropLast().joined(separator: ", ") + " and " + self.languages.last! : self.languages[0]
            des += pronouns[0] + " is proficient in \(languages_str). "
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
