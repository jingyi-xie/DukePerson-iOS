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
        let first_label = UILabel()
        first_label.frame = CGRect(x: 40, y: 60, width: 200, height: 20)
        first_label.text = "First Name"
        first_label.textColor = .white
        view.addSubview(first_label)
        
        let last_label = UILabel()
        last_label.frame = CGRect(x: 40, y: 110, width: 200, height: 20)
        last_label.text = "Last Name"
        last_label.textColor = .white
        view.addSubview(last_label)
        
        let from_label = UILabel()
        from_label.frame = CGRect(x: 40, y: 160, width: 200, height: 20)
        from_label.text = "From"
        from_label.textColor = .white
        view.addSubview(from_label)
        
        let id_label = UITextField()
        id_label.frame = CGRect(x: 40, y: 210, width: 200, height: 20)
        id_label.backgroundColor = .white
        id_label.layer.cornerRadius = 4.0
        view.addSubview(id_label)
    
    }
    
// You can add code here

}
// Don't change the following line - it is what allowsthe view controller to show in the Live View window
PlaygroundPage.current.liveView = HW1ViewController()
