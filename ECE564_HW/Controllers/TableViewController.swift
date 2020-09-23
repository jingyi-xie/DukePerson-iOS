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

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedPerson: DukePerson? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // First prepopulate the core data database if the database is empty
        self.prePopulate()
        // Fetch the core data and store in people_list
        self.fetchData()
        // Set up the search bar
        self.setupSearchbar()
    }

    // MARK: - Table view data source
    
    // section header for the table view
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        let names = ["  Professor", "  TA", "  Student"]
        label.text = names[section]
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
        return 3
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
        cell.nameLabel.text = person.firstName! + " " + person.lastName!
        cell.desLabel.text = person.description
        // display the image of the current person. If not found, display the default one
        if person.img != nil {
            cell.profile.image = UIImage(data: person.img!)
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
        }
        // if click the add button, set the button title in the information view controller as "Add"
        else if(segue.identifier == "clickAdd"){
            dest.saveBtn.title = "Add"
        }
    }
    
    // prepopulate the core data database
    func prePopulate() {
        // first determine if the database is empty
        fetchData()
        if people_list[0].count != 0  || people_list[1].count != 0 || people_list[2].count != 0{
            print("Found core data, no need to prepopulate")
            return
        }
        // add professor
        let prof = DukePerson(context: self.context)
        prof.firstName = "Ric"
        prof.lastName = "Telford"
        prof.gender = Gender.Male
        prof.role = DukeRole.Professor
        prof.program = "NA"
        prof.whereFrom = "Chatham County, NC"
        prof.hobbies = ["Hiking", "Swimming", "Biking"]
        prof.languages = ["Swift", "C", "C++"]
        prof.team = "None"
        prof.email = "rt113@duke.edu"
        prof.img =  UIImage(named: "ric.jpg")?.jpegData(compressionQuality: 0.25)
        
        // add myself
        let me = DukePerson(context: self.context)
        me.firstName = "Jingyi"
        me.lastName = "Xie"
        me.gender = Gender.Male
        me.role = DukeRole.Student
        me.program = "Grad"
        me.whereFrom = "China"
        me.hobbies = ["Traveling", "Movies", "Music"]
        me.languages = ["Python", "Java"]
        me.team = ""
        me.email = "jx95@duke.edu"
        me.img =  UIImage(named: "jingyi.jpeg")?.jpegData(compressionQuality: 0.25)
        
        // add the first ta
        let ta_1 = DukePerson(context: self.context)
        ta_1.firstName = "Haohong"
        ta_1.lastName = "Zhao"
        ta_1.gender = Gender.Male
        ta_1.role = DukeRole.TA
        ta_1.program = "Grad"
        ta_1.whereFrom = "China"
        ta_1.hobbies = ["reading books", "jogging"]
        ta_1.languages = ["swift", "java"]
        ta_1.team = ""
        ta_1.email = "haohong.zhao@duke.edu"
        ta_1.img =  UIImage(named: "haohong.jpeg")?.jpegData(compressionQuality: 0.25)
        
        // add the second ta
        let ta_2 = DukePerson(context: self.context)
        ta_2.firstName = "Yuchen"
        ta_2.lastName = "Yang"
        ta_2.gender = Gender.Female
        ta_2.role = DukeRole.TA
        ta_2.program = "Grad"
        ta_2.whereFrom = "China"
        ta_2.hobbies = ["Dancing"]
        ta_2.languages = ["Java", "cpp"]
        ta_2.team = ""
        ta_2.email = "yy227@duke.edu"
        ta_2.img =  UIImage(named: "yuchen.jpg")?.jpegData(compressionQuality: 0.25)
        
        // save to core data
        do {
            try self.context.save()
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    // fetch data from core data database into people_list attribute
    func fetchData() {
        do {
            // get list of all people
            let raw_list = try context.fetch(DukePerson.fetchRequest())
            // temp 2d array to replace the current people_list
            var temp_list = [[DukePerson]]()
            var professor_list = [DukePerson]()
            var ta_list = [DukePerson]()
            var student_list = [DukePerson]()
            // add the current person to different array based on the role
            for case let person as DukePerson in raw_list {
                if person.role == DukeRole.Professor {
                    professor_list.append(person)
                }
                else if person.role == DukeRole.TA {
                    ta_list.append(person)
                }
                else {
                    student_list.append(person)
                }
            }
            temp_list.append(professor_list)
            temp_list.append(ta_list)
            temp_list.append(student_list)
            // replace the current people_list
            self.people_list = temp_list
        }
        catch {
            print(error.localizedDescription)
        }
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
            self.fetchData()
            self.tableView.reloadData()
        }
        else {
            // if search text not empty, filter the people_list and display the cells
            filterPeople(index: searchBar.selectedScopeButtonIndex, text: searchText)
        }
    }
    
    // if chage the search option, refetch the data
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        self.fetchData()
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
                    return person.description.lowercased().contains(text.lowercased()) || person.firstName!.lowercased().contains(text.lowercased()) || person.lastName!.lowercased().contains(text.lowercased())})
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
        self.fetchData()
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
        let person = people_list[indexPath.section][indexPath.row]
        // deletde the person, then refresh the table
        let action = UIContextualAction(style: .normal, title: "Delete", handler: {(action, view, completion) in
            self.context.delete(person)
            do {
                try self.context.save()
            }
            catch {
                print(error.localizedDescription)
            }
            self.fetchData()
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
