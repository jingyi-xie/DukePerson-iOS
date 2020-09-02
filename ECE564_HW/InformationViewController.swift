//
//  InformationViewController.swift
//  ECE564_HW
//
//  Created by Jingyi on 2020/8/30.
//  Copyright © 2020 ECE564. All rights reserved.
//

import UIKit
import CoreData

class InformationViewController: UIViewController {

    @IBOutlet weak var first_input: UITextField!
    @IBOutlet weak var last_input: UITextField!
    @IBOutlet weak var from_input: UITextField!
    @IBOutlet weak var program_input: UITextField!
    @IBOutlet weak var hobbies_input: UITextField!
    @IBOutlet weak var languages_input: UITextField!
    @IBOutlet weak var team_input: UITextField!
    @IBOutlet weak var email_input: UITextField!
    @IBOutlet weak var gender_input: UITextField!
    @IBOutlet weak var role_input: UITextField!
    @IBOutlet weak var result_label: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let genders = ["Male", "Female"]
    var genderPickerView = UIPickerView()
    
    let roles = ["Professor", "TA", "Student"]
    var rolePickerView = UIPickerView()
    
    var people_list = [DukePerson]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        genderPickerView.delegate = self
        genderPickerView.dataSource = self
        genderPickerView.tag = 0
        gender_input.inputView = genderPickerView
        
        rolePickerView.delegate = self
        rolePickerView.dataSource = self
        rolePickerView.tag = 1
        role_input.inputView = rolePickerView
        
        self.prePopulate()
        self.fetchData()
        self.clearInput()
        
        var people_list:[DukePerson]?
        try! people_list = context.fetch(DukePerson.fetchRequest())
        print(people_list!)
        
        // Do any additional setup after loading the view.
    }
    
    func prePopulate() {
        fetchData()
        if people_list.count != 0 {
            print("Found core data, no need to prepopulate")
            return
        }
        let prof = DukePerson(context: self.context)
        prof.firstName = "Ric"
        prof.lastName = "Telford"
        prof.gender = Gender.Male
        prof.role = DukeRole.Professor
        prof.program = "NA"
        prof.whereFrom = "Chatham County, NC"
        prof.hobbies = "Hiking, Swimming, Biking"
        prof.languages = "Swift, C, C++"
        prof.team = "None"
        prof.email = "rt113@duke.edu"
        
        let me = DukePerson(context: self.context)
        me.firstName = "Jingyi"
        me.lastName = "Xie"
        me.gender = Gender.Male
        me.role = DukeRole.Student
        me.program = "Grad"
        me.whereFrom = "China"
        me.hobbies = "Movies, Music"
        me.languages = "Python, Javascript, Java, C/C++"
        me.team = "NA"
        me.email = "jx95@duke.edu"
        
        let ta_1 = DukePerson(context: self.context)
        ta_1.firstName = "Haohong"
        ta_1.lastName = "Zhao"
        ta_1.gender = Gender.Male
        ta_1.role = DukeRole.TA
        ta_1.program = "Grad"
        ta_1.whereFrom = "China"
        ta_1.hobbies = ""
        ta_1.languages = ""
        ta_1.team = ""
        ta_1.email = "hz147@duke.edu"
        
        
        let ta_2 = DukePerson(context: self.context)
        ta_2.firstName = "Yuchen"
        ta_2.lastName = "Yang"
        ta_2.gender = Gender.Female
        ta_2.role = DukeRole.TA
        ta_2.program = "Grad"
        ta_2.whereFrom = "China"
        ta_2.hobbies = ""
        ta_2.languages = ""
        ta_2.team = ""
        ta_2.email = "yy227@duke.edu"
        
        do {
            try self.context.save()
        }
        catch {
            print("Error: prepopulate data")
        }
    }
    
    func fetchData() {
        do {
            self.people_list = try context.fetch(DukePerson.fetchRequest())
        }
        catch {
            print("Error: fetch data")
        }
    }
    
    func findPerson(first: String, last: String) -> (String, DukePerson?) {
        let firstName = first.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastName = last.trimmingCharacters(in: .whitespacesAndNewlines)
        for person in people_list {
            if person.firstName != nil && person.firstName!.lowercased() == firstName.lowercased() && person.lastName != nil && person.lastName!.lowercased() == lastName.lowercased() {
                return (person.description, person)
            }
        }
        return ("The person was not found", nil)
    }

    func addOrUpdatePerson(first: String, last: String, whereFrom: String, program: String, hobbies: String, languages: String, team: String, email: String, gender: String, role: String) -> String {
        var found : Bool = false
        let firstName = first.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastName = last.trimmingCharacters(in: .whitespacesAndNewlines)
        for person in people_list {
            // if in the database, update the current record
            if person.firstName!.lowercased() == firstName.lowercased() && person.lastName!.lowercased() == lastName.lowercased() {
                person.whereFrom = whereFrom
                person.program = program
                person.hobbies = hobbies
                person.languages = languages
                person.team = team
                person.email = email
                person.gender = gender == "Male" ? Gender.Male : Gender.Female
                person.role = role == "Professor" ? DukeRole.Professor : (role == "TA" ? DukeRole.TA : DukeRole.Student)
                found = true
                break
            }
        }
        if found {
            try! self.context.save()
            fetchData()
            return "The person has been updated"
        }
        // if not in the database, create a new record
        let newPerson = DukePerson(context: self.context)
        newPerson.firstName = first_input.text
        newPerson.lastName = last_input.text
        newPerson.whereFrom = whereFrom
        newPerson.program = program
        newPerson.hobbies = hobbies
        newPerson.languages = languages
        newPerson.team = team
        newPerson.email = email
        newPerson.gender = gender == "Male" ? Gender.Male : Gender.Female
        newPerson.role = role == "Professor" ? DukeRole.Professor : (role == "TA" ? DukeRole.TA : DukeRole.Student)
        try! self.context.save()
        fetchData()
        return "The person has been added"
    }
    
    func clearInput() {
        first_input.text = ""
        last_input.text = ""
        from_input.text = ""
        program_input.text = ""
        hobbies_input.text = ""
        languages_input.text = ""
        team_input.text = ""
        email_input.text = ""
        gender_input.text = ""
        role_input.text = ""
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func clickAdd(_ sender: Any) {
        if first_input.text == "" || last_input.text == "" || gender_input.text == "" {
            result_label.text = "Error: Please provide first name, last name and gender. "
            result_label.textColor = .red
        }
        else {
            let result = addOrUpdatePerson(first: first_input.text!, last: last_input.text!, whereFrom: from_input.text!, program: program_input.text!, hobbies: hobbies_input.text!, languages: languages_input.text!, team: team_input.text!, email: email_input.text!, gender: gender_input.text!, role: role_input.text!)
            result_label.text = result
            result_label.textColor = .green
            clearInput()
        }
        image.image = UIImage()
    }
    
    @IBAction func clickFind(_ sender: Any) {
        if first_input.text == nil || last_input.text == nil || first_input.text == "" || last_input.text == "" {
            result_label.text = "Error: Please provide a first name and last name"
            result_label.textColor = .red
        }
        else {
            let result = findPerson(first: first_input.text!, last: last_input.text!)
            result_label.text = result.0
            result_label.textColor = UIColor(red: 0/255.0, green: 255/255.0, blue: 0/255.0, alpha: 1)
            if (result.1 == nil) {
                image.image = UIImage()
                result_label.textColor = .red
                return
            }
            let person = result.1!
            from_input.text = person.whereFrom
            program_input.text = person.program
            hobbies_input.text = person.hobbies
            languages_input.text = person.languages
            team_input.text = person.team
            email_input.text = person.email
            switch (person.gender) {
            case Gender.Male:
                gender_input.text = "Male"
            case Gender.Female:
                gender_input.text = "Female"

            }
            switch (person.role) {
            case DukeRole.Professor:
                role_input.text = "Professor"
            case DukeRole.TA:
                role_input.text = "TA"
            case DukeRole.Student:
                role_input.text = "Student"
            }
            if person.firstName == "Jingyi" && person.lastName == "Xie" {
                image.image = UIImage(named: "jingyi.jpeg")
            }
            else {
                image.image = UIImage()
            }
            
        }
        
    }
}



extension InformationViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            return genders.count
        }
        else {
            return roles.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0 {
            return genders[row]
        }
        else {
            return roles[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            gender_input.text = genders[row]
            gender_input.resignFirstResponder()
        }
        else if pickerView.tag == 1 {
            role_input.text = roles[row]
            role_input.resignFirstResponder()
        }
        
    }
}
