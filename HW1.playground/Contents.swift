//: This is the playground file to use for submitting HW1.  You will add your code where noted below.  Make sure you only put the code required at load time in the ``loadView()`` method.  Other code should be set up as additional methods (such as the code called when a button is pressed).
  
import UIKit
import PlaygroundSupport

enum Gender : String {
    case Male = "Male"
    case Female = "Female"
}

class Person {
    var firstName = "First"
    var lastName = "Last"
    var whereFrom = "Anywhere"  // this is just a free String - can be city, state, both, etc.
    var gender : Gender = .Male
}

enum DukeRole : String {
    case Student = "Student"
    case Professor = "Professor"
    case TA = "Teaching Assistant"
}

enum DukeProgram : String {
    case Undergrad = "Undergrad"
    case Grad = "Grad"
    case NA = "Not Applicable"
}

// You can add code here
class DukePerson : Person, CustomStringConvertible {
    var role : DukeRole = .Student
    var program : DukeProgram = .NA
    var netid: String = ""
    var description: String {
        // where from
        var des : String = "\(self.firstName) \(self.lastName) is from \(self.whereFrom). "
        // netid and role
        if self.gender == Gender.Male {
            des += "His NetID is \(self.netid). He is a \(self.role)"
        }
        else {
            des += "Her NetID is \(self.netid). She is a \(self.role)"
        }
        // program info
        if self.program != DukeProgram.NA {
            des += " working on the \(self.program) degree"
        }
        return des + "."
    }
    
    init(firstName: String, lastName: String, whereFrom: String, gender: Gender, role: DukeRole, program: DukeProgram, netid: String) {
        super.init()
        self.firstName = firstName
        self.lastName = lastName
        self.whereFrom = whereFrom
        self.gender = gender
        self.role = role
        self.program = program
        self.netid = netid
    }
}

// use array as data base
var people_list = [DukePerson]()

// add me, professor and TAs to database
people_list.append(DukePerson(firstName: "Jingyi", lastName: "Xie", whereFrom: "China", gender: .Male, role: .Student, program: .Grad, netid: "jx95"))
people_list.append(DukePerson(firstName: "Ric", lastName: "Telford", whereFrom: "Chatham County, NC", gender: .Male, role: .Professor, program: .NA, netid: "rt113"))
people_list.append(DukePerson(firstName: "Haohong", lastName: "Zhao", whereFrom: "China", gender: .Male, role: .TA, program: .Grad, netid: "hz147"))
people_list.append(DukePerson(firstName: "Yuchen", lastName: "Yang", whereFrom: "China", gender: .Female, role: .TA, program: .Grad, netid: "yy227"))

// find person in the array data base
func findPerson(first: String, last: String) -> (String, DukePerson?) {
    let firstName = first.trimmingCharacters(in: .whitespacesAndNewlines)
    let lastName = last.trimmingCharacters(in: .whitespacesAndNewlines)
    for person in people_list {
        if person.firstName.lowercased() == firstName.lowercased() && person.lastName.lowercased() == lastName.lowercased() {
            return (person.description, person)
        }
    }
    return ("The person was not found", nil)
}

func addOrUpdatePerson(first: String, last: String, whereFrom: String, gender: Gender, role: DukeRole, program: DukeProgram, netid: String) -> String {
    var found : Bool = false
    let firstName = first.trimmingCharacters(in: .whitespacesAndNewlines)
    let lastName = last.trimmingCharacters(in: .whitespacesAndNewlines)
    for person in people_list {
        // if in the database, update the current record
        if person.firstName.lowercased() == firstName.lowercased() && person.lastName.lowercased() == lastName.lowercased() {
            person.whereFrom = whereFrom
            person.gender = gender
            person.role = role
            person.program = program
            person.netid = netid
            found = true
            break
        }
    }
    if found {
        return "The person has been updated"
    }
    // if not in the database, create a new record
    people_list.append(DukePerson(firstName: firstName, lastName: lastName, whereFrom: whereFrom, gender: gender, role: role, program: program, netid: netid))
    return "The person has been added"

}

class HW1ViewController : UIViewController {
    
    // text fields to input name, from and netid
    var first_input = UITextField()
    var last_input = UITextField()
    var from_input = UITextField()
    var id_input = UITextField()
    var gender_select = UISegmentedControl()
    var role_select = UISegmentedControl()
    var program_select = UISegmentedControl()
    var add_update_btn = UIButton()
    var find_btn = UIButton()
    var result_label = UILabel()
    
    var selectedGender : Gender?
    var selectedRole : DukeRole?
    var selectedProgram : DukeProgram?
    var firstName : String?
    var lastName : String?
    var from : String?
    var netid : String?
    
    // helper function to create a new label
    func createLabel(text : String, pos : CGRect) -> UILabel {
        let label = UILabel()
        label.frame = pos
        label.text = text
        return label
    }
    
    // helper function to create a new text field
    func createTextField(pos : CGRect, target : Selector) -> UITextField {
        let textField = UITextField()
        textField.frame = pos
        textField.layer.borderWidth = 1.5
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.cornerRadius = 4.0
        textField.addTarget(self, action: target, for: .editingChanged)
        return textField
    }
    
    // helper function to create a new segmented control
    func createSegmentedControl(items: [String], pos : CGRect, target : Selector) -> UISegmentedControl {
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.frame = pos
        segmentedControl.selectedSegmentTintColor = .lightGray
        segmentedControl.addTarget(self, action: target, for: .valueChanged)
        return segmentedControl
    }
    
    // helper function to create a new button
    func createBtn(text : String , pos : CGRect, target : Selector) -> UIButton {
        let btn = UIButton()
        btn.frame = pos
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 4
        btn.setTitleColor(.black, for: .normal)
        btn.setTitle(text, for: .normal)
        btn.addTarget(self, action: target, for: .touchUpInside)
        return btn
    }
    
    override func loadView() {
// You can change color scheme if you wish
        let view = UIView()
        view.backgroundColor = .white
        
        self.view = view
        
// You can add code here
        
        let imageView = UIImageView(frame: CGRect(x: 30, y: 10, width: 80, height: 80))
        view.addSubview(imageView)

        if let sample = Bundle.main.path(forResource: "logo", ofType: "jpg") {
            let image = UIImage(contentsOfFile: sample)
            imageView.image = image
        }
        
        let label = UILabel()
        label.frame = CGRect(x: 150, y: 45, width: 200, height: 20)
        label.text = "Duke Internal Directory"
        label.textColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 204/255.0, alpha: 1)
        label.font = UIFont(name: "Poppins-Regular", size: 30.0)
        view.addSubview(label)
        
        
        // First Name
        view.addSubview(createLabel(text: "First Name",
                                    pos: CGRect(x: 40, y: 100, width: 200, height: 25)))
        
        first_input = createTextField(pos: CGRect(x: 150, y: 100, width: 180, height: 25), target: #selector(changedText(_:)))
        view.addSubview(first_input)
        
        // last name
        view.addSubview(createLabel(text: "Last Name",
                                    pos: CGRect(x: 40, y: 150, width: 200, height: 25)))
        
        last_input = createTextField(pos: CGRect(x: 150, y: 150, width: 180, height: 25), target: #selector(changedText(_:)))
        view.addSubview(last_input)
        
        // from
        view.addSubview(createLabel(text: "From",
                                    pos: CGRect(x: 40, y: 200, width: 200, height: 25)))
        
        from_input = createTextField(pos: CGRect(x: 150, y: 200, width: 180, height: 25), target: #selector(changedText(_:)))
        view.addSubview(from_input)
        
        // netid
        view.addSubview(createLabel(text: "NetID",
                                    pos: CGRect(x: 40, y: 250, width: 200, height: 25)))
        
        id_input = createTextField(pos: CGRect(x: 150, y: 250, width: 180, height: 25), target: #selector(changedText(_:)))
        view.addSubview(id_input)
        
        // segmented control to select gender
        gender_select = createSegmentedControl(items: ["Male", "Female"], pos: CGRect(x: 30, y: 300, width: 300, height: 25), target: #selector(selectGender(_:)))
        view.addSubview(gender_select)
        
        // segmented control to select role
        role_select = createSegmentedControl(items: ["Prof", "TA", "Student"], pos: CGRect(x: 30, y: 350, width: 300, height: 25), target: #selector(selectRole(_:)))
        view.addSubview(role_select)
        
        // segmented control to select program
        program_select = createSegmentedControl(items: ["Undergrad", "Grad", "NA"], pos: CGRect(x: 30, y: 400, width: 300, height: 25), target: #selector(selectProgram(_:)))
        view.addSubview(program_select)
        
        // add/update button
        add_update_btn = createBtn(text: "Add/Update", pos: CGRect(x: 30, y: 450, width: 120, height: 30), target: #selector(buttonClicked(_:)))
        view.addSubview(add_update_btn)
        
        // find button
        find_btn = createBtn(text: "Find", pos: CGRect(x: 210, y: 450, width: 120, height: 30), target: #selector(buttonClicked(_:)))
        view.addSubview(find_btn)
        
        // result label
        result_label = createLabel(text: "Welcome!", pos: CGRect(x: 30, y: 480, width: 300, height: 200))
        result_label.lineBreakMode = .byWordWrapping
        result_label.numberOfLines = 10
        view.addSubview(result_label)
    }
    
    func hideKeyboard() {
        first_input.resignFirstResponder()
        last_input.resignFirstResponder()
        from_input.resignFirstResponder()
        id_input.resignFirstResponder()
    }
    
    func clearInput() {
        first_input.text = ""
        last_input.text = ""
        from_input.text = ""
        id_input.text = ""
        gender_select.selectedSegmentIndex = -1
        role_select.selectedSegmentIndex = -1
        program_select.selectedSegmentIndex = -1
        firstName = nil
        lastName = nil
        from = nil
        netid = nil
        selectedGender = nil
        selectedRole = nil
        selectedProgram = nil
    }
    
// You can add code here
    @objc func changedText(_ text_input: UITextField) {
        // Use "if let" to get string from text field.
        if let value = text_input.text {
            if text_input == first_input {
                firstName = value
            }
            else if text_input == last_input {
                lastName = value
            }
            else if text_input == from_input {
                from = value
            }
            else {
                netid = value
            }
        }
    }
    
    // when change the gender segmented control
    @objc func selectGender(_ gender_select: UISegmentedControl) {
        hideKeyboard()
        switch (gender_select.selectedSegmentIndex) {
        case 0:
            selectedGender = Gender.Male
        case 1:
            selectedGender = Gender.Female
        default:
            break
        }
    }
    
    @objc func selectRole(_ role_select: UISegmentedControl) {
        hideKeyboard()
        switch (role_select.selectedSegmentIndex) {
        case 0:
            selectedRole = DukeRole.Professor
        case 1:
            selectedRole = DukeRole.TA
        case 2:
            selectedRole = DukeRole.Student
        default:
            break
        }
    }
    
    @objc func selectProgram(_ program_select: UISegmentedControl) {
        hideKeyboard()
        switch (program_select.selectedSegmentIndex) {
        case 0:
            selectedProgram = DukeProgram.Undergrad
        case 1:
            selectedProgram = DukeProgram.Grad
        case 2:
            selectedProgram = DukeProgram.NA
        default:
            break
        }
    }
    
    @objc func buttonClicked(_ btn: UIButton) {
        hideKeyboard()
        if btn == add_update_btn {
            if firstName == nil || lastName == nil || from == nil || netid == nil || selectedGender == nil || selectedRole == nil || selectedProgram == nil {
                result_label.text = "Error: Please enter all information"
                result_label.textColor = .red
            }
            else {
                let result = addOrUpdatePerson(first: firstName!, last: lastName!, whereFrom: from!, gender: selectedGender!, role: selectedRole!, program: selectedProgram!, netid: netid!)
                result_label.text = result
                result_label.textColor = .green
                clearInput()
            }
            
        }
        else if btn == find_btn {
            if firstName == nil || lastName == nil {
                result_label.text = "Error: Please provide a first name and last name"
                result_label.textColor = .red
            }
            else {
                let result = findPerson(first: firstName!, last: lastName!)
                result_label.text = result.0
                result_label.textColor = UIColor(red: 0/255.0, green: 255/255.0, blue: 0/255.0, alpha: 1)
                if (result.1 == nil) {
                    result_label.textColor = .red
                    return
                }
                let person = result.1!
                from_input.text = person.whereFrom
                from = person.whereFrom
                id_input.text = person.netid
                netid = person.netid
                selectedGender = person.gender
                selectedRole = person.role
                selectedProgram = person.program
                switch (person.gender) {
                case Gender.Male:
                    gender_select.selectedSegmentIndex = 0
                case Gender.Female:
                    gender_select.selectedSegmentIndex = 1

                }
                switch (person.role) {
                case DukeRole.Professor:
                    role_select.selectedSegmentIndex = 0
                case DukeRole.TA:
                    role_select.selectedSegmentIndex = 1
                case DukeRole.Student:
                    role_select.selectedSegmentIndex = 2
                }
                switch (person.program) {
                case DukeProgram.Undergrad:
                    program_select.selectedSegmentIndex = 0
                case DukeProgram.Grad:
                    program_select.selectedSegmentIndex = 1
                case DukeProgram.NA:
                    program_select.selectedSegmentIndex = 2
                }
            }
        }
    }

}
// Don't change the following line - it is what allowsthe view controller to show in the Live View window
PlaygroundPage.current.liveView = HW1ViewController()
