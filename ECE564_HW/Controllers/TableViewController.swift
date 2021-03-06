//
//  TableViewController.swift
//  ECE564_HW
//
//  Created by Jingyi on 2020/9/4.
//  Copyright © 2020 ECE564. All rights reserved.
//

import UIKit
import shibauthframework2019

// search bar scope: used for three different search options
enum searchBarScope: Int {
    case description = 0
    case hobbies = 1
    case languages = 2
}

class TableViewController: UITableViewController, UISearchBarDelegate, LoginAlertDelegate {
    
    let searchBar = UISearchBar()

    // 2d array to store the list of people:
    // 0: Professor, 1: TA, 2: Students
    var people_list : [[DukePerson]] = []
    var sectionHeaders : [String] = []

    var selectedPerson: DukePerson? = nil
    var isDarkMode : Bool = false
    
    
    @IBOutlet weak var LoginBtn: UIBarButtonItem!
    @IBOutlet weak var PostBtn: UIBarButtonItem!
    @IBOutlet weak var GetBtn: UIBarButtonItem!
    var loginProgressAlert : UIAlertController?
    var loginResult : NetidLookupResultData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadInitialData()
        
        // Set up the search bar
        self.setupSearchbar()
        // Set up dark mode
        if isDarkMode {
            overrideUserInterfaceStyle = .dark
        }
        else {
            overrideUserInterfaceStyle = .light
        }
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
            dest.isDarkMode = self.isDarkMode
        }
        // if click the add button, set the button title in the information view controller as "Add"
        else if(segue.identifier == "clickAdd"){
            dest.saveBtn.title = "Add"
            dest.rawList = self.people_list.reduce([], +)
            dest.isDarkMode = self.isDarkMode
        }
    }
    
    // load initial data
    func loadInitialData() {
        if DukePerson.loadDukePerson() != nil {
            updateList(raw_list: DukePerson.loadDukePerson()!)
            self.tableView.reloadData()
        } else {
            var rawList: [DukePerson] = []
            var professor_list = [DukePerson]()
            var ta_list = [DukePerson]()
            var student_list = [DukePerson]()
            // add professor
            let prof_img = self.resizeImage(image: UIImage(named: "ric.jpg")!, targetSize: CGSize(width:200.0, height:200.0)).jpegData(compressionQuality: 1)
            let prof_str:String = prof_img!.base64EncodedString()
            let prof = DukePerson(firstName: "Ric", lastName: "Telford", whereFrom: "Chatham County, NC", gender: "Male", hobbies: ["Hiking", "Swimming", "Biking"], role: "Professor", degree: "NA", languages: ["Swift", "C", "C++"], picture: prof_str, team: "None", netid: "rt113", email: "rt113@duke.edu", department: "")
            professor_list.append(prof)
            rawList.append(prof)
            
            // add myself
            let me_img = self.resizeImage(image: UIImage(named: "jingyi.jpeg")!, targetSize: CGSize(width:200.0, height:200.0)).jpegData(compressionQuality: 1)
            let me_str:String = me_img!.base64EncodedString()
            let me = DukePerson(firstName: "Jingyi", lastName: "Xie", whereFrom: "China", gender: "Male", hobbies: ["Traveling", "Movies", "Music"], role: "Student", degree: "Grad", languages: ["Python", "Java"], picture: me_str, team: "HealthPal", netid: "jx95", email: "jx95@duke.edu", department: "ECE")
            student_list.append(me)
            rawList.append(me)
            
            // add the first ta
            let ta1_img = self.resizeImage(image: UIImage(named: "haohong.jpeg")!, targetSize: CGSize(width:200.0, height:200.0)).jpegData(compressionQuality: 1)
            let ta1_str:String = ta1_img!.base64EncodedString()
            let ta1 = DukePerson(firstName: "Haohong", lastName: "Zhao", whereFrom: "China", gender: "Male", hobbies: ["reading books", "jogging"], role: "Teaching Assistant", degree: "Grad", languages: ["swift", "java"], picture: ta1_str, team: "", netid: "hz147", email: "haohong.zhao@duke.edu", department: "")
            ta_list.append(ta1)
            rawList.append(ta1)
            
            // add the second ta
            let ta2_img = self.resizeImage(image: UIImage(named: "yuchen.jpg")!, targetSize: CGSize(width:200.0, height:200.0)).jpegData(compressionQuality: 1)
            let ta2_str:String = ta2_img!.base64EncodedString()
            let ta2 = DukePerson(firstName: "Yuchen", lastName: "Yang", whereFrom: "China", gender: "Female", hobbies: ["Dancing"], role: "Teaching Assistant", degree: "Grad", languages: ["Java", "cpp"], picture: ta2_str, team: "", netid: "yy227", email: "yy227@duke.edu", department: "")
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
    
    func updateList(raw_list: [DukePerson]) {
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
            else if person.role == "Teaching Assistant" || person.role == "TA" {
                ta_list.append(person)
            }
            else if person.role == "Student" {
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
            self.updateList(raw_list: DukePerson.loadDukePerson()!)
            self.tableView.reloadData()
        }
        else {
            // if search text not empty, filter the people_list and display the cells
            filterPeople(index: searchBar.selectedScopeButtonIndex, text: searchText)
        }
    }
    
    // if chage the search option, refetch the data
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        self.updateList(raw_list: DukePerson.loadDukePerson()!)
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
        self.updateList(raw_list: DukePerson.loadDukePerson()!)
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
            self.updateList(raw_list: DukePerson.loadDukePerson()!)
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
    
    
    // source: homework support on piazza
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }

        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
    
    
    @IBAction func changeDarkMode(_ sender: Any) {
        if !isDarkMode {
            view.overrideUserInterfaceStyle = .dark
            self.isDarkMode = true
        }
        else {
            view.overrideUserInterfaceStyle = .light
            self.isDarkMode = false
        }
    }
    
    func findPersonToUpdate() -> DukePerson? {
        if self.loginResult == nil {
            return nil
        }
        for person in self.people_list.reduce([], +) {
            if person.netid == self.loginResult!.netid! {
                return person
            }
        }
        return nil
    }
    
    func showPostAlert(success: Bool) {
        let alert = UIAlertController(title: "Message", message: success ? "POST succeeded" : "POST failed! Try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func clickLogin(_ sender: Any) {
        if checkLoggedIn(clickLogin: true) {
            return
        }
        let alertController = LoginAlert(title: "Authenticate", message: nil, preferredStyle: .alert)
        alertController.delegate = self
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func clickPost(_ sender: Any) {
        print("in post")
        if !checkLoggedIn(clickLogin: false) || loginResult == nil {
            self.showPostAlert(success: false)
            return
        }
        let url = URL(string: "https://rt113-dt01.egr.duke.edu:5640/b64entries")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let username = loginResult!.id!
        let password = loginResult!.password!
        let loginString = "\(username):\(password)"
        guard let loginData = loginString.data(using: String.Encoding.utf8) else {
            self.showPostAlert(success: false)
            return
        }
        let base64LoginString = loginData.base64EncodedString()
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let personToUpdate = findPersonToUpdate()
        if personToUpdate == nil {
            self.showPostAlert(success: false)
            return
        }
        let jsonDict = [
            "id": loginResult!.id! as Any,
            "netid": loginResult!.netid! as Any,
            "firstname": personToUpdate!.firstname as Any,
            "lastname": personToUpdate!.lastname as Any,
            "wherefrom": personToUpdate!.wherefrom as Any,
            "gender": personToUpdate!.gender as Any,
            "role": personToUpdate!.role as Any,
            "degree": personToUpdate!.degree as Any,
            "team": personToUpdate!.team as Any,
            "hobbies": personToUpdate!.hobbies as Any,
            "languages": personToUpdate!.languages as Any,
            "department": personToUpdate!.department as Any,
            "email": personToUpdate!.email as Any,
            "picture": personToUpdate!.picture as Any,
        ] as [String : Any]
        let jsonData = try! JSONSerialization.data(withJSONObject: jsonDict, options: [])
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            if let error = error {
                print("error:", error)
                self.showPostAlert(success: false)
                return
            }
            do {
                if data != nil && response != nil {
                    print("data: \(data!)")
                    print("response: \(response!)")
                }
                guard let data = data else { return }
                guard (try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]) != nil else {
                    self.showPostAlert(success: false)
                    return
                }
            } catch {
                self.showPostAlert(success: false)
                print("error:", error)
                return
            }
        }
        task.resume()
        self.showPostAlert(success: true)
    }
    
    @IBAction func clickGet(_ sender: Any) {
//        if !checkLoggedIn(clickLogin: false) {
//            return
//        }
        let url = URL(string: "https://rt113-dt01.egr.duke.edu:5640/b64entries")!
        DispatchQueue.main.async {
            let task = URLSession.shared.dataTask(with: url) {
                (data, response, error) in
                if let error = error {
                    print("error: \(error)")
                }
                else {
                    if let response = response as? HTTPURLResponse {
                        print("status: \(response.statusCode)")
                    }
                    if let data = data, let _ = String(data: data, encoding: .utf8) {
                        let decoder = JSONDecoder()
                        var raw_list = [DukePerson]()
                        if let decoded = try? decoder.decode([DukePerson].self, from: data) {
                            raw_list = decoded
                            print(raw_list)

                            self.updateList(raw_list: raw_list)
                            DispatchQueue.main.async {
                                let _ = DukePerson.saveDukePerson(self.people_list.reduce([], +))
                                self.tableView.reloadData()
                            }
                            
                        }
                        else {
                            DispatchQueue.main.async {
                                let alert = UIAlertController(title: "Error", message: "Failed to decode. Please check the server (picture).", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
                                    alert.dismiss(animated: true, completion: nil)
                                }))
                                self.present(alert, animated: true, completion: nil)
                                print("Failed to decode")
                            }
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    func onSuccess(_ loginAlertController: LoginAlert, didFinishSucceededWith status: LoginResults, netidLookupResult: NetidLookupResultData?, netidLookupResultRawData: Data?, cookies: [HTTPCookie]?, lastLoginTime: Date) {
        // succeeded, extract netidLookupResult.id and netidLookupResult.password for your server credential
        // other properties needed for homework are also in netidLookupResult
        print("login success")
        DispatchQueue.main.async {
            self.loginProgressAlert!.dismiss(animated: true, completion: nil);
            self.loginProgressAlert = nil
            if netidLookupResult == nil {
                return
            }
            self.loginResult = netidLookupResult!
        }
        
    }
    
    func onFail(_ loginAlertController: LoginAlert, didFinishFailedWith reason: LoginResults) {
        // when authentication fails, this method will be called.
        // default implementation provided
        print("login failed")
        DispatchQueue.main.async {
            self.loginProgressAlert!.dismiss(animated: true, completion: nil);
            self.loginProgressAlert = nil
            print(reason)
            let alert = UIAlertController(title: "Error", message: reason.description, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func inProgress(_ loginAlertController: LoginAlert, didSubmittedWith status: LoginResults) {
        // this method will get called for each step in progress.
        // default implementation provided
        if self.loginProgressAlert != nil {
            return
        }
        self.loginProgressAlert = UIAlertController(title: nil, message: "⏳ Please wait...", preferredStyle: .alert)
        present(self.loginProgressAlert!, animated: true, completion: nil)
    }
    
    func checkLoggedIn(clickLogin: Bool) -> Bool {
        if self.loginResult == nil {
            if !clickLogin {
                let alert = UIAlertController(title: "Error", message: "You must log in first", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
                    alert.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            }
            return false
        }
        if clickLogin {
            let alert = UIAlertController(title: "Message", message: "You already logged in!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        return true
    }



}
