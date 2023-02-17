//
//  DashboardViewController.swift
//  SkillsTracker
//
//  Created by Ashlesha Kamble on 14/06/22.
//  dashboard updated by shubham

import UIKit
import FirebaseFirestore
import FirebaseAuth

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var skillsTableview: UITableView!
    
    
    let db = Firestore.firestore()
    let dbManager = DatabaseManager()
    var arrayOfskills = [String]()
    var filterSkills = [String]() // for search bar
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardTaparound()
        
        showSpinner()
        skillsTableview.dataSource = self
        skillsTableview.delegate = self
        searchbar.delegate = self
        allSkills()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logOut))
        navigationItem.rightBarButtonItem?.tintColor = .systemTeal
        title = "HOME"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.systemTeal]
        
    }
    
    @objc func logOut () {
        openAlert(title: "Logout", message: "Are you sure you want to logout?", alertStyle: .alert, actionTitles: ["Cancel","Logout"], actionStyles: [.cancel,.default], actions: [ {action1 in
            print("Okay clicked")
        }, {action2 in
            self.dbManager.logout(navigation: self.navigationController!)
        }])
    }
    
    @IBAction func toProfile(_ sender: Any) {
        let yourProfile = self.storyboard?.instantiateViewController(withIdentifier: "YourProfileViewController") as! YourProfileViewController
        navigationController?.pushViewController(yourProfile, animated: true)
    }
    
    
    //MARK: Function to fetch All Entered Skills
    func allSkills() {
        dbManager.readSkillOnDashboard { arrayOfSkills in
            print("Data is : \(arrayOfSkills)")
            self.arrayOfskills = arrayOfSkills
            self.filterSkills = arrayOfSkills
            DispatchQueue.main.async {
                self.skillsTableview.reloadData()
                self.removeSpinner()
            }
        }
        
    }
}

//MARK: Tableview Method

extension DashboardViewController: UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterSkills.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "skillsCell", for: indexPath)
        cell.textLabel?.text = filterSkills[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterSkills = []
        if searchText == ""
        {
            filterSkills = arrayOfskills
        }
        for skill in arrayOfskills{
            if skill.contains(searchText.description.uppercased())
            {
                filterSkills.append(skill)
            }
        }
        
        skillsTableview.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let empOfSelectedSkill = storyboard?.instantiateViewController(withIdentifier: "EmployeeSkillsViewController") as! EmployeeSkillsViewController
        let index = arrayOfskills[indexPath.row]
        empOfSelectedSkill.index = index
        self.navigationController?.pushViewController(empOfSelectedSkill, animated: true)
        
    }
    
}


