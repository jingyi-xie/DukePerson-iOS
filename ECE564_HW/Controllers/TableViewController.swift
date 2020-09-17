//
//  TableViewController.swift
//  ECE564_HW
//
//  Created by Jingyi on 2020/9/4.
//  Copyright © 2020 ECE564. All rights reserved.
//

import UIKit

enum searchBarScope: Int {
    case description = 0
    case hobbies = 1
    case languages = 2
}

class TableViewController: UITableViewController, UISearchBarDelegate {
    let searchBar = UISearchBar()

    var people_list : [[DukePerson]] = []

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedPerson: DukePerson? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prePopulate()
        self.fetchData()
        self.setupSearchbar()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        let names = ["  Professor", "  TA", "  Student"]
        label.text = names[section]
        label.font = UIFont(name: "Avenir Next Bold", size: 15)
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.people_list[section].count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath) as! PersonCell
        let person:DukePerson = self.people_list[indexPath.section][indexPath.row]
        cell.nameLabel.text = person.firstName! + " " + person.lastName!
        cell.desLabel.text = person.description
        if person.img != nil {
            cell.profile.image = UIImage(data: person.img!)
        }
        else {
            cell.profile.image = UIImage(named: "default.png")
        }
        cell.personView.layer.cornerRadius = 15
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedPerson = self.people_list[indexPath.section][indexPath.row]
        performSegue(withIdentifier: "clickCell", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navController = segue.destination as! UINavigationController
        let dest = navController.topViewController as! InformationViewController
        if(segue.identifier == "clickCell"){
            dest.saveBtn.title = "Edit"
            dest.currentPerson = self.selectedPerson
        }
        else if(segue.identifier == "clickAdd"){
            dest.saveBtn.title = "Add"
        }
    }
    
    func prePopulate() {
        fetchData()
        if people_list[0].count != 0  || people_list[1].count != 0 || people_list[2].count != 0{
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
        prof.hobbies = ["Hiking", "Swimming", "Biking"]
        prof.languages = ["Swift", "C", "C++"]
        prof.team = "None"
        prof.email = "rt113@duke.edu"
        prof.img =  UIImage(named: "ric.jpg")?.jpegData(compressionQuality: 0.25)
        
        let me = DukePerson(context: self.context)
        me.firstName = "Jingyi"
        me.lastName = "Xie"
        me.gender = Gender.Male
        me.role = DukeRole.Student
        me.program = "Grad"
        me.whereFrom = "China"
        me.hobbies = ["Movies", "Music"]
        me.languages = ["Python", "Java"]
        me.team = ""
        me.email = "jx95@duke.edu"
        me.img =  UIImage(named: "jingyi.jpeg")?.jpegData(compressionQuality: 0.25)

        
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
        ta_1.img =  UIImage(named: "haohong.png")?.jpegData(compressionQuality: 0.25)
        
        
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
        
        do {
            try self.context.save()
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchData() {
        do {
            let raw_list = try context.fetch(DukePerson.fetchRequest())
            var temp_list = [[DukePerson]]()
            var professor_list = [DukePerson]()
            var ta_list = [DukePerson]()
            var student_list = [DukePerson]()
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
            self.people_list = temp_list
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func setupSearchbar() {
        searchBar.showsScopeBar = true
        searchBar.scopeButtonTitles = ["Description", "Hobbies", "Languages"]
        searchBar.selectedScopeButtonIndex = 0
        searchBar.delegate = self
        self.tableView.tableHeaderView = searchBar
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.fetchData()
            self.tableView.reloadData()
        }
        else {
            filterPeople(index: searchBar.selectedScopeButtonIndex, text: searchText)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        self.fetchData()
        self.tableView.reloadData()
        searchBar.text = nil
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    
    func filterPeople(index: Int, text: String) {
        
        switch index {
        case searchBarScope.description.rawValue:
            people_list = people_list.map{
                return $0.filter({(person) -> Bool in
                    return person.description.lowercased().contains(text.lowercased()) || person.firstName!.lowercased().contains(text.lowercased()) || person.lastName!.lowercased().contains(text.lowercased())})
            }
            self.tableView.reloadData()

        case searchBarScope.hobbies.rawValue:
            people_list = people_list.map{
                return $0.filter({(person) -> Bool in
                    return person.getHobbiesString().lowercased().contains(text.lowercased())})
            }
            self.tableView.reloadData()
        case searchBarScope.languages.rawValue:
            people_list = people_list.map{
                return $0.filter({(person) -> Bool in
                    return person.getLanguagesString().lowercased().contains(text.lowercased())})
            }
            self.tableView.reloadData()
        default:
            print("Scope not found")
        }
    }
    
    
    @IBAction func returnFromInformation(_ sender: UIStoryboardSegue) {
        self.fetchData()
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = createDeleteAction(at: indexPath)
        let view = createViewAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete, view])
    }
    
    func createDeleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let person = people_list[indexPath.section][indexPath.row]
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
    
    func createViewAction(at indexPath: IndexPath) -> UIContextualAction {
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
