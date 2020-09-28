//
//  DukePerson.swift
//  ECE564_HW
//
//  Created by Jingyi on 2020/9/27.
//  Copyright © 2020 ECE564. All rights reserved.
//

import Foundation

public class DukePerson: ECE564, CustomStringConvertible, Codable {
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("DukePersonJSONFile")
    
    public var firstname: String
    public var lastname: String
    public var wherefrom: String
    public var gender: String
    public var hobbies: [String]
    public var role: String
    public var degree: String
    public var languages: [String]
    public var picture: String
    public var team: String
    public var netid: String
    public var email: String
    public var department: String
    public var id: String

    public var description: String {
        // array of strings to store pronouns, based on gender
        var pronouns = [String]()
        if (self.gender == "Male") {
            pronouns = ["He", "His"]
        }
        else {
            pronouns = ["She", "Her"]
        }
        
        // string to store the description
        var des : String = ""
        // from
        if self.wherefrom != "" {
            des += pronouns[0] + " is from \(self.wherefrom). "
        }
        // role
        des += pronouns[0] + " is a \(self.role). "
        // program info
        if self.degree != "" && self.degree != "NA" {
            des += pronouns[0] + " is working on the \(self.degree) degree. "
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
        if self.email != "" {
            des += pronouns[1] + " email is \(self.email). "
        }
        // team
        if self.role == "Student" && self.team != "" {
            des += pronouns[1] + " team is \(self.team). "
        }
        return des
    }
    
    init(firstName: String, lastName: String, whereFrom: String, gender: String, hobbies: [String], role: String, degree: String, languages: [String], picture: String, team: String, netid: String, email: String) {
        self.firstname = firstName
        self.lastname = lastName
        self.wherefrom = whereFrom
        self.gender = gender
        self.hobbies = hobbies
        self.role = role != "" ? role : "Student"
        self.degree = degree
        self.languages = languages
        self.picture = picture
        self.team = team
        self.netid = netid
        self.email = email
        self.department = ""
        self.id = ""
    }

    
    // For table view search: get the comma separated string of languages
    func getLanguagesString() -> String {
        return self.languages.joined(separator: ", ")
    }
    
    // For table view search: get the comma separated string of hobbies
    func getHobbiesString() -> String {
        return self.hobbies.joined(separator: ", ")
    }
    
    static func saveDukePerson(_ personList: [DukePerson]) -> Bool {
        var outputData = Data()
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(personList) {
            if String(data: encoded, encoding: .utf8) != nil {
                outputData = encoded
            }
            else {
                return false
                
            }
            do {
                try outputData.write(to: ArchiveURL)
            } catch let error as NSError {
                print (error)
                return false
            }
            return true
        }
        else {
            return false
            
        }
    }
        
    static func loadDukePerson() -> [DukePerson]? {
        let decoder = JSONDecoder()
        var personList = [DukePerson]()
        let tempData: Data
        do {
            tempData = try Data(contentsOf: ArchiveURL)
        } catch let error as NSError {
            print(error)
            return nil
        }
        if let decoded = try? decoder.decode([DukePerson].self, from: tempData) {
            personList = decoded
        }
        else {
            print("cannot load data")
        }
        return personList
    }
}

