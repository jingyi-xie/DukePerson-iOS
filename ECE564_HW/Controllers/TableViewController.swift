//
//  TableViewController.swift
//  ECE564_HW
//
//  Created by Jingyi on 2020/9/4.
//  Copyright © 2020 ECE564. All rights reserved.
//

import UIKit

// search bar scope: used for three different search options
enum searchBarScope: Int {
    case description = 0
    case hobbies = 1
    case languages = 2
}

class TableViewController: UITableViewController, UISearchBarDelegate {
    let searchBar = UISearchBar()

    // 2d array to store the list of people:
    // 0: Professor, 1: TA, 2: Students
    var people_list : [[DukePerson]] = []
    var sectionHeaders : [String] = []

    var selectedPerson: DukePerson? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadInitialData()
        
        // Set up the search bar
        self.setupSearchbar()
    }

    // MARK: - Table view data source
    
    // section header for the table view
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        if section > sectionHeaders.count - 1 {
            label.text = "Others"
        }
        else {
            label.text = sectionHeaders[section]
        }
        label.font = UIFont(name: "Avenir Next Bold", size: 15)
        // Use different color for different headers
        if section == 0 {
            label.textColor = UIColor(red: 0/255, green: 158/255, blue: 249/255, alpha: 1.00)
        }
        else if section == 1 {
            label.textColor = UIColor(red: 92/255, green: 168/255, blue: 148/255, alpha: 1.00)
        }
        else {
            label.textColor = UIColor(red: 140/255, green: 63/255, blue: 177/255, alpha: 1.00)
        }
        return label
    }

    // return the number of sections: professor, TA, student
    override func numberOfSections(in tableView: UITableView) -> Int {
        return people_list.count
    }

    // return the number of rows in each section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.people_list[section].count;
    }
    
    // return the cell at the current row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // deque the current cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath) as! PersonCell
        // get the current people instance according to this cell
        let person:DukePerson = self.people_list[indexPath.section][indexPath.row]
        // set the name and description label on the person cell
        cell.nameLabel.text = person.firstname + " " + person.lastname
        cell.desLabel.text = person.description
        // display the image of the current person. If not found, display the default one
        if person.picture != "" {
            let dataDecoded : Data = Data(base64Encoded: person.picture, options: .ignoreUnknownCharacters)!
            cell.profile.image = UIImage(data: dataDecoded)
        }
        else {
            cell.profile.image = UIImage(named: "default.png")
        }
        // customize the style of the cell
        cell.personView.layer.cornerRadius = 15
        // use different border color for different roles
        if indexPath.section == 0 {
            cell.personView.layer.borderColor = UIColor(red: 0/255, green: 158/255, blue: 249/255, alpha: 1.00).cgColor
        }
        else if indexPath.section == 1 {
            cell.personView.layer.borderColor = UIColor(red: 92/255, green: 168/255, blue: 148/255, alpha: 1.00).cgColor
        }
        else {
            cell.personView.layer.borderColor = UIColor(red: 140/255, green: 63/255, blue: 177/255, alpha: 1.00).cgColor
        }
        cell.personView.layer.borderWidth = 1.5

        return cell
    }
    
    // when select a cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // first set the attribute `selectedPerson` (send to the information view in the prepare function)
        self.selectedPerson = self.people_list[indexPath.section][indexPath.row]
        // perform the segue with the identifier
        performSegue(withIdentifier: "clickCell", sender: self)
    }

    // prepare function is called before going to the next view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the destination (information view controller) through the navigation controller
        let navController = segue.destination as! UINavigationController
        let dest = navController.topViewController as! InformationViewController
        // if click on a cell, set the button title in the information view controller as "Edit" and pass the person
        if(segue.identifier == "clickCell"){
            dest.saveBtn.title = "Edit"
            dest.currentPerson = self.selectedPerson
            dest.rawList = self.people_list.reduce([], +)
        }
        // if click the add button, set the button title in the information view controller as "Add"
        else if(segue.identifier == "clickAdd"){
            dest.saveBtn.title = "Add"
            dest.rawList = self.people_list.reduce([], +)
        }
    }
    
    // load initial data
    func loadInitialData() {
        if DukePerson.loadDukePerson() != nil {
            updateList()
            self.tableView.reloadData()
        } else {
            var rawList: [DukePerson] = []
            var professor_list = [DukePerson]()
            var ta_list = [DukePerson]()
            var student_list = [DukePerson]()
            // add professor
            let prof_img = UIImage(named: "ric.jpg")?.jpegData(compressionQuality: 0.25)
            let prof_str:String = prof_img!.base64EncodedString(options: .lineLength64Characters)
            let prof = DukePerson(firstName: "Ric", lastName: "Telford", whereFrom: "Chatham County, NC", gender: "Male", hobbies: ["Hiking", "Swimming", "Biking"], role: "Professor", degree: "NA", languages: ["Swift", "C", "C++"], picture: prof_str, team: "None", netid: "rt113", email: "rt113@duke.edu")
            professor_list.append(prof)
            rawList.append(prof)
            
            // add myself
            let me_img = UIImage(named: "jingyi.jpeg")?.jpegData(compressionQuality: 0.25)
            let me_str:String = me_img!.base64EncodedString(options: .lineLength64Characters)
            let me = DukePerson(firstName: "Jingyi", lastName: "Xie", whereFrom: "China", gender: "Male", hobbies: ["Traveling", "Movies", "Music"], role: "Student", degree: "Grad", languages: ["Python", "Java"], picture: me_str, team: "", netid: "jx95", email: "jx95@duke.edu")
            student_list.append(me)
            rawList.append(me)
            
            // add the first ta
            let ta1_img = UIImage(named: "haohong.jpeg")?.jpegData(compressionQuality: 0.25)
            let ta1_str:String = ta1_img!.base64EncodedString(options: .lineLength64Characters)
            let ta1 = DukePerson(firstName: "Haohong", lastName: "Zhao", whereFrom: "China", gender: "Male", hobbies: ["reading books", "jogging"], role: "Teaching Assistant", degree: "Grad", languages: ["swift", "java"], picture: ta1_str, team: "", netid: "hz147", email: "haohong.zhao@duke.edu")
            ta_list.append(ta1)
            rawList.append(ta1)
            
            // add the second ta
            let ta2_img = UIImage(named: "yuchen.jpg")?.jpegData(compressionQuality: 0.25)
            let ta2_str:String = ta2_img!.base64EncodedString(options: .lineLength64Characters)
            let ta2 = DukePerson(firstName: "Yuchen", lastName: "Yang", whereFrom: "China", gender: "Female", hobbies: ["Dancing"], role: "Teaching Assistant", degree: "Grad", languages: ["Java", "cpp"], picture: ta2_str, team: "", netid: "yy227", email: "yy227@duke.edu")
            ta_list.append(ta2)
            rawList.append(ta2)
            
            people_list.append(professor_list)
            people_list.append(ta_list)
            people_list.append(student_list)
            
            sectionHeaders = ["Professor", "TA", "Student"]

            if !DukePerson.saveDukePerson(rawList) {
                print("In table view (prepopulate): failed to save data ")
            }
            self.tableView.reloadData()
        }
    }
    
    func updateList() {
        let raw_list = DukePerson.loadDukePerson()!
        var temp_list = [[DukePerson]]()
        var professor_list = [DukePerson]()
        var ta_list = [DukePerson]()
        var group_list = [[DukePerson]]()
        var student_list = [DukePerson]()
        self.sectionHeaders = ["Professor", "TA"]

        // add the current person to different array based on the role
        for case let person in raw_list {
            if person.role == "Professor" {
                professor_list.append(person)
            }
            else if person.role == "Teaching Assistant" {
                ta_list.append(person)
            }
            else {
                let team = person.team.trimmingCharacters(in:.whitespacesAndNewlines).lowercased()
                if team != "" && team != "none" && team != "na" {
                    if sectionHeaders.firstIndex(of: person.team) != nil {
                        group_list[sectionHeaders.firstIndex(of: person.team)! - 2].append(person)
                    }
                    else {
                        var cur_group = [DukePerson]()
                        cur_group.append(person)
                        group_list.append(cur_group)
                        sectionHeaders.append(person.team)
                    }
                }
                else {
                    student_list.append(person)
                }
            }
        }
        temp_list.append(professor_list)
        temp_list.append(ta_list)
        if group_list.reduce([], +).count != 0 {
            for list in group_list {
                temp_list.append(list)
            }
        }
        if student_list.count != 0 {
            sectionHeaders.append("Students")
            temp_list.append(student_list)
        }
        // replace the current people_list
        self.people_list = temp_list
        
        print(sectionHeaders)
    }
    
    
    // MARK: - Table view search bar
    
    // set up the search bar with three search options
    func setupSearchbar() {
        searchBar.showsScopeBar = true
        searchBar.scopeButtonTitles = ["Description", "Hobbies", "Languages"]
        searchBar.selectedScopeButtonIndex = 0
        searchBar.delegate = self
        self.tableView.tableHeaderView = searchBar
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            // if delete all the text in the search bar, refetch the data
            self.updateList()
            self.tableView.reloadData()
        }
        else {
            // if search text not empty, filter the people_list and display the cells
            filterPeople(index: searchBar.selectedScopeButtonIndex, text: searchText)
        }
    }
    
    // if chage the search option, refetch the data
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        self.updateList()
        self.tableView.reloadData()
        searchBar.text = nil
    }
    
    // if click the "search" button on the keyboard, dismiss the keyboard
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    // if scroll the table view after search, dismiss the keyboard
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    
    // filter the people_list based on different search options
    func filterPeople(index: Int, text: String) {
        
        switch index {
        case searchBarScope.description.rawValue:
            // if choose the "description" search, find the text in description and name
            people_list = people_list.map{
                return $0.filter({(person) -> Bool in
                    return person.description.lowercased().contains(text.lowercased()) || person.firstname.lowercased().contains(text.lowercased()) || person.lastname.lowercased().contains(text.lowercased())})
            }
            // refresh all cells in the table view
            self.tableView.reloadData()

        case searchBarScope.hobbies.rawValue:
            // if choose the "hobbies" search, find the text in hobbies
            people_list = people_list.map{
                return $0.filter({(person) -> Bool in
                    return person.getHobbiesString().lowercased().contains(text.lowercased())})
            }
            // refresh all cells in the table view
            self.tableView.reloadData()
        case searchBarScope.languages.rawValue:
            // if choose the "languages" search, find the text in languages
            people_list = people_list.map{
                return $0.filter({(person) -> Bool in
                    return person.getLanguagesString().lowercased().contains(text.lowercased())})
            }
            // refresh all cells in the table view
            self.tableView.reloadData()
        default:
            print("Scope not found")
        }
    }
    
    // when return from the information view, refresh the table
    @IBAction func returnFromInformation(_ sender: UIStoryboardSegue) {
        self.updateList()
        self.tableView.reloadData()
    }
    
    // MARK: - Table view swipe cell

    // when swipe the cell in the table, you can delete or view
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = createDeleteAction(at: indexPath)
        let view = createViewAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete, view])
    }
    
    // return the delete action when swipe
    func createDeleteAction(at indexPath: IndexPath) -> UIContextualAction {
        // get the instance of the current person
        // deletde the person, then refresh the table
        let action = UIContextualAction(style: .normal, title: "Delete", handler: {(action, view, completion) in
            self.people_list[indexPath.section].remove(at: indexPath.row)
            let _ = DukePerson.saveDukePerson(self.people_list.reduce([], +))
            self.updateList()
            self.tableView.reloadData()
            completion(true)
        })
        action.image = UIImage(named: "delete.png")
        action.backgroundColor = .white
        return action
    }
    
    // return the view action when swipe
    func createViewAction(at indexPath: IndexPath) -> UIContextualAction {
        // go to information view, same segue as when click the cell
        let action = UIContextualAction(style: .normal, title: "View", handler: {(action, view, completion) in
            self.selectedPerson = self.people_list[indexPath.section][indexPath.row]
            self.performSegue(withIdentifier: "clickCell", sender: self)
            completion(true)
        })
        action.image = UIImage(named: "view.png")
        action.backgroundColor = .white
        return action
    }

}
