//
//  InformationViewController.swift
//  ECE564_HW
//
//  Created by Jaryn on 2020/8/30.
//  Copyright © 2020 ECE564. All rights reserved.
//

import UIKit
import CoreData

class InformationViewController: UIViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.prePopulate()
        
        var people_list:[DukePerson]?
        try! people_list = context.fetch(DukePerson.fetchRequest())
        print(people_list!)
        
        // Do any additional setup after loading the view.
    }
    
    func prePopulate() {
        let prof = DukePerson(context: self.context)
        prof.firstName = "Ric"
        prof.lastName = "Telford"
        prof.gender = Gender.Male
        prof.role = DukeRole.Professor
        prof.program = "Not Applicable"
        prof.whereFrom = "Chatham County, NC"
        prof.hobbies = "Hiking, Swimming, Biking"
        prof.languages = "Swift, C, C++"
        prof.team = "None"
        prof.email = "rt113@duke.edu"
        
        let me = DukePerson(context: self.context)
        me.firstName = "Jingyi"
        me.lastName = "Xie"
        me.gender = Gender.Male
        me.role = DukeRole.Student
        me.program = "Grad"
        me.whereFrom = "China"
        me.hobbies = "Movies, Music"
        me.languages = "Python, Javascript, Java, C/C++"
        me.team = "None"
        me.email = "jx95@duke.edu"
        
        let ta_1 = DukePerson(context: self.context)
        ta_1.firstName = "Haohong"
        ta_1.lastName = "Zhao"
        ta_1.gender = Gender.Male
        ta_1.role = DukeRole.TA
        ta_1.program = "Grad"
        ta_1.whereFrom = "China"
        ta_1.hobbies = ""
        ta_1.languages = ""
        ta_1.team = "None"
        ta_1.email = "hz147@duke.edu"
        
        
        let ta_2 = DukePerson(context: self.context)
        ta_2.firstName = "Yuchen"
        ta_2.lastName = "Yang"
        ta_2.gender = Gender.Female
        ta_2.role = DukeRole.TA
        ta_2.program = "Grad"
        ta_2.whereFrom = "China"
        ta_2.hobbies = ""
        ta_2.languages = ""
        ta_2.team = "None"
        ta_2.email = "yy227@duke.edu"
        
        do {
            try self.context.save()
        }
        catch {
            print("Error: prepopulate data")
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
