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

//print(people_list)

// find person in the array data base
func findPerson(first: String, last: String) -> String {
    for person in people_list {
        if person.firstName.lowercased() == first.lowercased() && person.lastName.lowercased() == last.lowercased() {
            return person.description
        }
    }
    return "The person was not found"
}

//print(findPerson(first: "Jingyi", last: "xie"))


func addOrUpdatePerson(firstName: String, lastName: String, whereFrom: String, gender: Gender, role: DukeRole, program: DukeProgram, netid: String) -> String {
    var found : Bool = false
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

//print(addOrUpdatePerson(firstName: "jingyi", lastName: "xie", whereFrom: "place", gender: .Female, role: .Student, program: .Grad, netid: "id"))
//print(people_list)

class HW1ViewController : UIViewController {
    
    // text fields to input name, from and netid
    var first_input = UITextField()
    var last_input = UITextField()
    var from_input = UITextField()
    var id_input = UITextField()
    
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
        label.textColor = .white
        return label
    }
    
    // helper function to create a new text field
    func createTextField(pos : CGRect, target : Selector) -> UITextField {
        let textField = UITextField()
        textField.frame = pos
        textField.backgroundColor = .black
        textField.textColor = .white
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.white.cgColor
        textField.layer.cornerRadius = 4.0
        textField.addTarget(self, action: target, for: .editingChanged)
        //textField.resignFirstResponder()
        return textField
    }
    
    override func loadView() {
// You can change color scheme if you wish
        let view = UIView()
        view.backgroundColor = .black
        let label = UILabel()
        label.frame = CGRect(x: 100, y: 10, width: 200, height: 20)
        label.text = "ECE 564 Homework 1"
        label.textColor = .white
        view.addSubview(label)
        self.view = view
        
// You can add code here
        // First Name
        view.addSubview(createLabel(text: "First Name",
                                    pos: CGRect(x: 40, y: 60, width: 200, height: 25)))
        
        //let first_input = UITextField()
        first_input = createTextField(pos: CGRect(x: 150, y: 60, width: 180, height: 25), target: #selector(changedText(_:)))
        view.addSubview(first_input)
        
        // last name
        view.addSubview(createLabel(text: "Last Name",
                                    pos: CGRect(x: 40, y: 110, width: 200, height: 25)))
        
        last_input = createTextField(pos: CGRect(x: 150, y: 110, width: 180, height: 25), target: #selector(changedText(_:)))
        view.addSubview(last_input)
        
        // from
        view.addSubview(createLabel(text: "From",
                                    pos: CGRect(x: 40, y: 160, width: 200, height: 25)))
        
        //let from_input = UITextField()
        from_input = createTextField(pos: CGRect(x: 150, y: 160, width: 180, height: 25), target: #selector(changedText(_:)))
        view.addSubview(from_input)
        
        // netid
        view.addSubview(createLabel(text: "NetID",
                                    pos: CGRect(x: 40, y: 210, width: 200, height: 25)))
        
        // let id_input = UITextField()
        id_input = createTextField(pos: CGRect(x: 150, y: 210, width: 180, height: 25), target: #selector(changedText(_:)))
        view.addSubview(id_input)
        
        // segmented control to select gender
        let gender_select = UISegmentedControl(items: ["Male", "Female"])
        gender_select.frame = CGRect(x: 30, y: 260, width: 300, height: 25)
        gender_select.backgroundColor = .gray
        gender_select.selectedSegmentTintColor = .white
        gender_select.addTarget(self, action: #selector(selectGender(_:)), for: .valueChanged)
        view.addSubview(gender_select)
        
        // segmented control to select role
        let role_select = UISegmentedControl(items: ["Prof", "TA", "Student"])
        role_select.frame = CGRect(x: 30, y: 310, width: 300, height: 25)
        role_select.backgroundColor = .gray
        role_select.selectedSegmentTintColor = .white
        role_select.addTarget(self, action: #selector(selectRole(_:)), for: .valueChanged)
        view.addSubview(role_select)
        
        // segmented control to select program
        let program_select = UISegmentedControl(items: ["Undergrad", "Grad", "NA"])
        program_select.frame = CGRect(x: 30, y: 360, width: 300, height: 25)
        program_select.backgroundColor = .gray
        program_select.selectedSegmentTintColor = .white
        program_select.addTarget(self, action: #selector(selectProgram(_:)), for: .valueChanged)
        view.addSubview(program_select)
        
        // add/update button
        let add_update_btn = UIButton()
        add_update_btn.frame = CGRect(x: 30, y: 410, width: 100, height: 30)
        add_update_btn.backgroundColor = .black
        add_update_btn.layer.borderWidth = 1
        add_update_btn.layer.cornerRadius = 4
        add_update_btn.layer.borderColor = UIColor.white.cgColor
        view.addSubview(add_update_btn)
    }
    
// You can add code here
    @objc func changedText(_ text_input: UITextField) {
        // Use "if let" to get string from text field.
        if let value = text_input.text {
            if text_input == first_input {
                firstName = value
                print("first name is " + firstName!)
            }
            else if text_input == last_input {
                lastName = value
                print("last name is " + lastName!)

            }
            else if text_input == from_input {
                from = value
                print("from is " + from!)
            }
            else {
                netid = value
                print("netid is " + netid!)
            }
        }
    }
    
    // when change the gender segmented control
    @objc func selectGender(_ gender_select: UISegmentedControl) {
        switch (gender_select.selectedSegmentIndex) {
            case 0:
                selectedGender = Gender.Male
                print(selectedGender!)
            case 1:
                selectedGender = Gender.Female
                print(selectedGender!)
            default:
                break
        }
    }
    
    @objc func selectRole(_ role_select: UISegmentedControl) {
        switch (role_select.selectedSegmentIndex) {
            case 0:
                selectedRole = DukeRole.Professor
                print(selectedRole!)
            case 1:
                selectedRole = DukeRole.TA
                print(selectedRole!)
            case 2:
                selectedRole = DukeRole.Student
                print(selectedRole!)
            default:
                break
        }
    }
    
    @objc func selectProgram(_ program_select: UISegmentedControl) {
        switch (program_select.selectedSegmentIndex) {
            case 0:
                selectedProgram = DukeProgram.Undergrad
                print(selectedProgram!)
            case 1:
                selectedProgram = DukeProgram.Grad
                print(selectedProgram!)
            case 2:
                selectedProgram = DukeProgram.NA
                print(selectedProgram!)
            default:
                break
        }
    }

}
// Don't change the following line - it is what allowsthe view controller to show in the Live View window
PlaygroundPage.current.liveView = HW1ViewController()
