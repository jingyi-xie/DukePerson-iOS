//
//  InformationViewController.swift
//  ECE564_HW
//
//  Created by Jingyi on 2020/8/30.
//  Copyright © 2020 ECE564. All rights reserved.
//

import UIKit
import CoreData

class InformationViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    @IBOutlet weak var imgBtn: UIButton!
    
    // context for core data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // store the current person
    var currentPerson : DukePerson? = nil
    
    // picker view for gender
    let genders = ["Male", "Female"]
    var genderPickerView = UIPickerView()
    
    // picker view for role
    let roles = ["Professor", "TA", "Student"]
    var rolePickerView = UIPickerView()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up delegate of picker views
        genderPickerView.delegate = self
        genderPickerView.dataSource = self
        genderPickerView.tag = 0
        gender_input.inputView = genderPickerView
        
        rolePickerView.delegate = self
        rolePickerView.dataSource = self
        rolePickerView.tag = 1
        role_input.inputView = rolePickerView
        
        // set up delegate of text fields
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
        // if click "add" button in table view, show the default image
        if self.saveBtn.title == "Add" {
            image.image = UIImage(named: "default.png")
        }
        // if click a cell in table view, show the image of the person
        else if self.currentPerson != nil && self.currentPerson?.img != nil {
            image.image = UIImage(data: self.currentPerson!.img!)
        }
        else {
            image.image = UIImage(named: "default.png")
        }
        
        // if click a cell in table view, populate all the text fields on this person
        if self.saveBtn.title == "Edit" {
            autoPopulate()
            // view only mode
            changeMode(canEdit: false)
        }
        
        // tap gesture to dismiss the keyboard
        let Tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(Tap);
        
        // swipe gestures to flip the page
        let swipeLeft : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(showBack))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        view.addGestureRecognizer(swipeLeft)
        
        let swipeRight : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(showBack))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        view.addGestureRecognizer(swipeRight)
    }
    
    // when click anywhere outside of the keyboard, dismiss the keyboard
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    // when swipe, perform the "show back" segue
    @objc func showBack() {
        // if in the view to add a person, cannot flip the page
        if self.saveBtn.title == "Add" {
            return
        }
        performSegue(withIdentifier: "showBack", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showBack"){
            // pass the person to back view
            let dest = segue.destination as! BackViewController
            dest.currentPerson = self.currentPerson
        }
    }
    
    // auto populate the information of the current person in the text fields
    func autoPopulate() {
        if (self.currentPerson == nil) {
            return
        }
        let person = self.currentPerson!
        first_input.text = person.firstName
        last_input.text = person.lastName
        from_input.text = person.whereFrom
        program_input.text = person.program
        hobbies_input.text = person.hobbies.joined(separator: ", ")
        languages_input.text = person.languages.joined(separator: ", ")
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
    
    // change the mode: ready-only or edit
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
        imgBtn.isHidden = !canEdit
    }
    
    // use regular expression to check if the email if valid
    func checkEmail() -> Bool {
        if email_input.text == nil || email_input.text == "" {
            return true
        }
        let email = email_input.text
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        // if email is invalid, create a alert
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
    
    // check if the name in empty
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
        // parse the hobbies and languages into array
        newPerson.hobbies = hobbies.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines)}
        newPerson.languages = languages.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines)}
        newPerson.team = team
        newPerson.email = email
        newPerson.gender = gender == "Male" ? Gender.Male : Gender.Female
        newPerson.role = role == "Professor" ? DukeRole.Professor : (role == "TA" ? DukeRole.TA : DukeRole.Student)
        // store the image in binary format and compress the picture
        newPerson.img = self.image.image?.jpegData(compressionQuality: 0.25)
        do {
            try self.context.save()
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func updatePerson(person: DukePerson,first: String, last: String, whereFrom: String, program: String, hobbies: String, languages: String, team: String, email: String, gender: String, role: String) {
        person.whereFrom = whereFrom
        person.program = program
        person.hobbies = hobbies.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines)}
        person.languages = languages.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines)}
        person.team = team
        person.email = email
        person.gender = gender == "Male" ? Gender.Male : Gender.Female
        person.role = role == "Professor" ? DukeRole.Professor : (role == "TA" ? DukeRole.TA : DukeRole.Student)
        person.img = self.image.image?.jpegData(compressionQuality: 0.25)
        do {
            try self.context.save()
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    // clear all text fields
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
    

    // when click the button
    @IBAction func clickBtn(_ sender: Any) {
        let title = (sender as! UIBarButtonItem).title
        // if in the view to add a new person, add the person
        if title == "Add" {
            self.clickAdd()
        }
        // if in read-only view, unlock the text fields
        else if title == "Edit" {
            self.saveBtn.title = "Update/Add"
            changeMode(canEdit: true)
        }
        // if in edit mode, update the current person or add a new one
        else if title == "Update/Add" {
            self.clickUpdateOrAdd()
        }
    }
    
    // when click the choose image button, get picture from camera or the photo library
    @IBAction func clickImgBtn(_ sender: Any) {
        let imgPickerController = UIImagePickerController()
        imgPickerController.delegate = self
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imgPickerController.sourceType = .camera
                self.present(imgPickerController, animated: true, completion: nil)
            }
            else {
                let camera_alert = UIAlertController(title: "Error", message: "No camera found", preferredStyle: .alert)
                camera_alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    camera_alert.dismiss(animated: true, completion: nil)
                }))
                self.present(camera_alert, animated: true, completion: nil)
            }
            
        }))
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            imgPickerController.sourceType = .photoLibrary
            self.present(imgPickerController, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // check if the role if Professor or TA, disable the team field
    @IBAction func changeRole(_ sender: Any) {
        if self.saveBtn.title == "Add" {
            if role_input.text! == "Professor" || role_input.text! == "TA" {
                self.team_input.isEnabled = false
            }
            else {
                self.team_input.isEnabled = true
            }
        }
    }
    
    // when click add to add a new person
    func clickAdd() {
        // if name is empty or email is invalid, create alert and return
        if !self.checkName() || !self.checkEmail() {
            return
        }
        addPerson(first: first_input.text!, last: last_input.text!, whereFrom: from_input.text!, program: program_input.text!, hobbies: hobbies_input.text!, languages: languages_input.text!, team: team_input.text!, email: email_input.text!, gender: gender_input.text!, role: role_input.text!)
        // return to table view
        self.performSegue(withIdentifier: "returnFromInformation", sender: self)
    }
    
    func clickUpdateOrAdd() {
        var message : String = ""
        // if the name is unchanged, update the person
        if self.currentPerson != nil && first_input.text == self.currentPerson!.firstName && last_input.text == self.currentPerson!.lastName {
            // update person
            updatePerson(person: self.currentPerson!, first: first_input.text!, last: last_input.text!, whereFrom: from_input.text!, program: program_input.text!, hobbies: hobbies_input.text!, languages: languages_input.text!, team: team_input.text!, email: email_input.text!, gender: gender_input.text!, role: role_input.text!)
            message = "Person is updated!"
        }
        // if change the name, add a new person
        else if self.checkName() && self.checkEmail() {
            addPerson(first: first_input.text!, last: last_input.text!, whereFrom: from_input.text!, program: program_input.text!, hobbies: hobbies_input.text!, languages: languages_input.text!, team: team_input.text!, email: email_input.text!, gender: gender_input.text!, role: role_input.text!)
            message = "You changed the name field, a new person is added!"
        }
        // use alert to display the result
        let alert = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            self.performSegue(withIdentifier: "returnFromInformation", sender: self)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // when click "return" on the keyboard, dismiss the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - picker view

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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let source = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.image.image = source
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
