//
//  UpdateProfileViewController.swift
//  SkillsTracker
//
//  Created by Ashlesha Kamble on 20/06/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore


class UpdateProfileViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: TextFields!
    @IBOutlet weak var lastNameTextField: TextFields!
    @IBOutlet weak var emailTextField: TextFields!
    @IBOutlet weak var employeeIDTextField: TextFields!
    @IBOutlet weak var designationTextField: TextFields!
    @IBOutlet weak var skillsTable: UITableView!
    @IBOutlet weak var sideView: UIView!
    @IBOutlet weak var sideTableView: UITableView!
    
    let sideMenu = ["Home","View Profile","Logout"]
    var isSideBarOpen = false
    
    let dbManager = DatabaseManager()
    let db = Firestore.firestore()
    var allEmployees = [String : Any]()
    var arrayOfSkills = [String]()
    var updatedSkills = [String]()
    let currentEmployee = Auth.auth().currentUser?.email
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showSpinner()
        skillsTable.delegate = self
        skillsTable.dataSource = self
        sideView.isHidden = true
        sideTableView.isHidden = true
        
        sideTableView.dataSource = self
        sideTableView.delegate = self
        
        employeeIDTextField.isUserInteractionEnabled = false
        designationTextField.isUserInteractionEnabled = false
        emailTextField.isUserInteractionEnabled = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(getBack))
        
        getCurrentUserProfile()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        print(arrayOfSkills)
    }
    
    @objc func getBack() {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: Function to fetch Current User's Profile
    
    func getCurrentUserProfile() {
        dbManager.readAllEmployees { allEmployeeData in
            if allEmployeeData["Email"] as! String == self.currentEmployee!
            {
                self.arrayOfSkills.append(contentsOf: allEmployeeData["Skills"] as! [String])
                self.skillsTable.reloadData()
                self.firstNameTextField.text = allEmployeeData["First Name"] as? String
                self.lastNameTextField.text = allEmployeeData["Last Name"] as? String
                self.emailTextField.text = allEmployeeData["Email"] as? String
                self.employeeIDTextField.text = allEmployeeData["EmployeeID"] as? String
                self.designationTextField.text = allEmployeeData["Designation"] as? String
                
            }
            self.removeSpinner()
        }
    }
    
    @IBAction func addSkillTapped(_ sender: UIButton) {
        let dD = self.storyboard?.instantiateViewController(withIdentifier: "DropDownViewController") as! DropDownViewController
        dD.delegate = self
        navigationController?.pushViewController(dD, animated: true)
    }
    
    @IBAction func updateProfileTapped(_ sender: UIButton) {
        dbManager.readAllEmployees { allEmployess in
            self.allEmployees = allEmployess
            if ((self.firstNameTextField.text! != "") && (self.lastNameTextField.text! != "") && !(self.arrayOfSkills.isEmpty))
            {
                print(self.allEmployees["Email"] as! String)
                if (self.allEmployees["Email"] as! String) == self.currentEmployee
                {
                    self.updateData()
                    self.openAlert(title: "Status",
                                   message: "Your Profile has been updated successfully.",
                                   alertStyle: .alert,
                                   actionTitles: ["View Profile","Home"],
                                   actionStyles: [.default,.default],
                                   actions: [{action1 in
                        let viewProfile = self.storyboard?.instantiateViewController(withIdentifier: "YourProfileViewController") as! YourProfileViewController
                        self.navigationController?.pushViewController(viewProfile, animated: true) },
                                             {action2 in
                        let home = self.storyboard?.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
                        self.navigationController?.pushViewController(home, animated: true)
                    }])
                }
            }
            else
            {
                self.openAlert(title: "Alert",
                               message: "Please enter valid data.",
                               alertStyle: .alert,
                               actionTitles: ["Okay"],
                               actionStyles: [.default],
                               actions: [{ _ in
                    print("Okay clicked!")
                }])
            }
        }
    }
    
    @IBAction func tapToSlide (_sender: UIButton) {
        
        sideView.isHidden = false
        sideTableView.isHidden = false
        self.view.bringSubviewToFront(sideView)
        
        if !isSideBarOpen {
            isSideBarOpen = true
            sideView.frame = CGRect(x: 0, y: 0, width: 0, height: 211)
            sideTableView.frame = CGRect(x: 0, y: 0, width: 0, height: 211)
            UIView.animate( withDuration: 0.5, delay: 0.3) { [weak self] in
                self?.view.layoutIfNeeded()
            }
            sideView.frame = CGRect(x: 0, y: 0, width: 197, height: 211)
            sideTableView.frame = CGRect(x: 0, y: 0, width: 197, height: 211)
            
        } else {
            sideView.isHidden = true
            sideTableView.isHidden = true
            isSideBarOpen = false
            
            sideView.frame = CGRect(x: 0, y: 0, width: 197, height: 211)
            sideTableView.frame = CGRect(x: 0, y: 0, width: 197, height: 211)
            UIView.animate( withDuration: 0.5, delay: 0.3) { [weak self] in
                self?.view.layoutIfNeeded()
            }
            sideView.frame = CGRect(x: 0, y: 0, width: 0, height: 211)
            sideTableView.frame = CGRect(x: 0, y: 0, width: 0, height: 211)
            
        }
    }
    
    func updateData()
    {
        if (self.allEmployees["Email"] as! String) == self.currentEmployee
        {
            let documentID = self.allEmployees["dcID"] as! String
            self.db.collection("Employees").document("EmployeeData").collection("Employee").document(documentID).setData(["First Name" : (self.firstNameTextField.text?.description.uppercased())!,
                 "Last Name" : (self.lastNameTextField.text?.description.uppercased())!,
                 "Email" :(self.emailTextField.text)!,
                 "EmployeeID" :(self.employeeIDTextField.text?.description.uppercased())!,
                 "Designation" : (self.designationTextField.text?.description.uppercased())!,
                 "Skills" : self.arrayOfSkills,
                 "dcID" : documentID])
        }
    }
}

//MARK: Tableview Methods

extension UpdateProfileViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == skillsTable ? arrayOfSkills.count: sideMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var returnCell = UITableViewCell()
        if tableView == skillsTable {
            let cell = skillsTable.dequeueReusableCell(withIdentifier: "cellB")
            cell?.textLabel?.text = arrayOfSkills[indexPath.row]
            returnCell = cell!
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "sideBarCell", for: indexPath)
            cell.textLabel?.text = sideMenu[indexPath.row]
            returnCell = cell
        }
        return returnCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == sideTableView
        {
            switch (indexPath.row) {
            case 0:
                let home = self.storyboard?.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
                navigationController?.pushViewController(home, animated: true)
                
            case 1:
                let viewProfile = self.storyboard?.instantiateViewController(withIdentifier: "YourProfileViewController") as! YourProfileViewController
                navigationController?.pushViewController(viewProfile, animated: true)
            case 2:
                openAlert(title: "Logout", message: "Are you sure you want to logout?", alertStyle: .alert, actionTitles: ["Cancel","Logout"], actionStyles: [.cancel,.default], actions: [ {action1 in
                    print("Okay clicked")
                }, {action2 in
                    self.dbManager.logout(navigation: self.navigationController!)
                }])
            default:
                return
            }
        }
        else
        {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete, tableView == skillsTable
        {
            self.arrayOfSkills.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            print(arrayOfSkills)
        }
    }
    
}
extension UpdateProfileViewController: GetSelectedSkillsBack {
    func getSelectedSkills(skills: [String]) {
        updatedSkills.removeAll()
        updatedSkills.append(contentsOf: skills)
        skillsTable.reloadData()
        print("Selected Skills: \(updatedSkills)")
        for skill in updatedSkills
        {
            if self.arrayOfSkills.contains(skill)
            {
                print(arrayOfSkills)
                skillsTable.reloadData()
            }
            else
            {
                arrayOfSkills.append(skill)
                print(arrayOfSkills)
                skillsTable.reloadData()
            }
        }
    }
}
