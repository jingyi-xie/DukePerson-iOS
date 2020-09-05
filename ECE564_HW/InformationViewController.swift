//
//  InformationViewController.swift
//  ECE564_HW
//
//  Created by Jingyi on 2020/8/30.
//  Copyright © 2020 ECE564. All rights reserved.
//

import UIKit
import CoreData

class InformationViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

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
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var currentPerson : DukePerson? = nil
    
    let genders = ["Male", "Female"]
    var genderPickerView = UIPickerView()
    
    let roles = ["Professor", "TA", "Student"]
    var rolePickerView = UIPickerView()
        
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
        
        first_input.delegate = self
        last_input.delegate = self
        from_input.delegate = self
        program_input.delegate = self
        hobbies_input.delegate = self
        languages_input.delegate = self
        team_input.delegate = self
        email_input.delegate = self
        gender_input.delegate = self
        role_input.delegate = self
        
        //self.clearInput()
        
        if self.saveBtn.title == "Edit" {
            autoPopulate()
            changeMode(canEdit: false)
        }
    }
    
    func autoPopulate() {
        if (self.currentPerson == nil) {
            return
        }
        let person = self.currentPerson!
        first_input.text = person.firstName
        last_input.text = person.lastName
        from_input.text = person.whereFrom
        program_input.text = person.program
        hobbies_input.text = person.hobbies == nil ? "" : person.hobbies!.joined(separator: ", ")
        languages_input.text = person.languages == nil ? "" : person.languages!.joined(separator: ", ")
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
    }
    
    func changeMode(canEdit: Bool) {
        first_input.isEnabled = canEdit
        last_input.isEnabled = canEdit
        from_input.isEnabled = canEdit
        program_input.isEnabled = canEdit
        hobbies_input.isEnabled = canEdit
        languages_input.isEnabled = canEdit
        team_input.isEnabled = canEdit
        email_input.isEnabled = canEdit
        gender_input.isEnabled = canEdit
        role_input.isEnabled = canEdit
    }
    
    func checkEmail() -> Bool {
        if email_input.text == nil || email_input.text == "" {
            return true
        }
        let email = email_input.text
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if !emailPred.evaluate(with: email) {
            let alert = UIAlertController(title: "Error", message: "Please provide a valid email.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    func checkName() -> Bool {
        if first_input.text == "" || last_input.text == "" || gender_input.text == "" {
            let alert = UIAlertController(title: "Error", message: "Please provide first name, last name and gender.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        return true
    }

    func addPerson(first: String, last: String, whereFrom: String, program: String, hobbies: String, languages: String, team: String, email: String, gender: String, role: String) {
        let newPerson = DukePerson(context: self.context)
        newPerson.firstName = first.trimmingCharacters(in: .whitespacesAndNewlines)
        newPerson.lastName = last.trimmingCharacters(in: .whitespacesAndNewlines)
        newPerson.whereFrom = whereFrom
        newPerson.program = program
        newPerson.hobbies = hobbies.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines)}
        newPerson.languages = languages.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines)}
        newPerson.team = team
        newPerson.email = email
        newPerson.gender = gender == "Male" ? Gender.Male : Gender.Female
        newPerson.role = role == "Professor" ? DukeRole.Professor : (role == "TA" ? DukeRole.TA : DukeRole.Student)
        try! self.context.save()
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
    

    @IBAction func clickBtn(_ sender: Any) {
        let title = (sender as! UIBarButtonItem).title
        if title == "Add" {
            self.clickAdd()
        }
        else if title == "Edit" {
            self.saveBtn.title = "Update/Add"
            changeMode(canEdit: true)
        }
        else if title == "Update/Add" {
            self.clickEdit()
        }
    }
    
    func clickAdd() {
        if !self.checkName() || !self.checkEmail() {
            return
        }
        addPerson(first: first_input.text!, last: last_input.text!, whereFrom: from_input.text!, program: program_input.text!, hobbies: hobbies_input.text!, languages: languages_input.text!, team: team_input.text!, email: email_input.text!, gender: gender_input.text!, role: role_input.text!)
        self.performSegue(withIdentifier: "returnFromInformation", sender: self)
    }
    
    func clickEdit() {
        if first_input.text == self.currentPerson?.firstName && last_input.text == self.currentPerson?.lastName {
            // update person
            return
        }
        // if change the name, add a new person
        if self.checkName() && self.checkEmail() {
            addPerson(first: first_input.text!, last: last_input.text!, whereFrom: from_input.text!, program: program_input.text!, hobbies: hobbies_input.text!, languages: languages_input.text!, team: team_input.text!, email: email_input.text!, gender: gender_input.text!, role: role_input.text!)
            let alert = UIAlertController(title: "Message", message: "You changed the name field, a new person is added!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
                self.performSegue(withIdentifier: "returnFromInformation", sender: self)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
//    @IBAction func clickFind(_ sender: Any) {
//        if first_input.text == nil || last_input.text == nil || first_input.text == "" || last_input.text == "" {
//            result_label.text = "Error: Please provide a first name and last name"
//            result_label.textColor = .red
//        }
//        else {
//            let result = findPerson(first: first_input.text!, last: last_input.text!)
//            result_label.text = result.0
//            result_label.textColor = UIColor(red: 0/255.0, green: 255/255.0, blue: 0/255.0, alpha: 1)
//            if (result.1 == nil) {
//                image.image = UIImage()
//                result_label.textColor = .red
//                return
//            }
//            let person = result.1!
//            from_input.text = person.whereFrom
//            program_input.text = person.program
//            hobbies_input.text = person.hobbies == nil ? "" : person.hobbies!.joined(separator: ", ")
//            languages_input.text = person.languages == nil ? "" : person.languages!.joined(separator: ", ")
//            team_input.text = person.team
//            email_input.text = person.email
//            switch (person.gender) {
//            case Gender.Male:
//                gender_input.text = "Male"
//            case Gender.Female:
//                gender_input.text = "Female"
//
//            }
//            switch (person.role) {
//            case DukeRole.Professor:
//                role_input.text = "Professor"
//            case DukeRole.TA:
//                role_input.text = "TA"
//            case DukeRole.Student:
//                role_input.text = "Student"
//            }
//            if person.firstName == "Jingyi" && person.lastName == "Xie" {
//                image.image = UIImage(named: "jingyi.jpeg")
//            }
//            else {
//                image.image = UIImage()
//            }
//
//        }
//
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            return genders.count
        }
        else if pickerView.tag == 1 {
            return roles.count
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0 {
            return genders[row]
        }
        else if pickerView.tag == 1 {
            return roles[row]
        }
        return "Data not found"
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
