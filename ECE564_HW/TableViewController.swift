//
//  TableViewController.swift
//  ECE564_HW
//
//  Created by Jingyi on 2020/9/4.
//  Copyright © 2020 ECE564. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    var people_list : [[DukePerson]] = []

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.prePopulate()
        self.fetchData()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        let names = ["  Professor", "  TA", "  Student"]
        label.text = names[section]
        label.backgroundColor = UIColor.lightGray
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
        cell.profile.image = UIImage(named: "default.png")

        return cell
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
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
        prof.hobbies = ["Hiking", "Swimming", "Biking"]
        prof.languages = ["Swift", "C", "C++"]
        prof.team = "None"
        prof.email = "rt113@duke.edu"
        
        let me = DukePerson(context: self.context)
        me.firstName = "Jingyi"
        me.lastName = "Xie"
        me.gender = Gender.Male
        me.role = DukeRole.Student
        me.program = "Grad"
        me.whereFrom = "China"
        me.hobbies = ["Movies", "Music"]
        me.languages = ["Python", "Javascript", "Java", "C/C++"]
        me.team = ""
        me.email = "jx95@duke.edu"
        
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
        
        do {
            try self.context.save()
        }
        catch {
            print("Error: prepopulate data")
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
            print("Error: fetch data")
        }
    }
    
    
    @IBAction func returnFromInformation(_ sender: UIStoryboardSegue) {
        //let source:InformationViewController = sender.source as! InformationViewController
        //let new_list:[DukePerson] = source.people_list
        //self.people_list = new_list
        self.fetchData()
        self.tableView.reloadData()
        print("I'm back!!")
    }

}
