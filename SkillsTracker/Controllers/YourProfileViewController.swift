//
//  YourProfileViewController.swift
//  SkillsTracker
//
//  Created by Ashlesha Kamble on 15/06/22.
//

import UIKit
import FirebaseAuth

class YourProfileViewController: UIViewController {
    
    
    @IBOutlet weak var yourProfileRightBarButton: UIBarButtonItem!
    @IBOutlet weak var userProfile: UILabel!
    @IBOutlet weak var nameTextField: TextFields!
    @IBOutlet weak var employeeIdTextField: TextFields!
    @IBOutlet weak var designationTextField: TextFields!
    @IBOutlet weak var skillsTable: UITableView!
    @IBOutlet weak var emailTextField: TextFields!
    @IBOutlet weak var lastTextField: TextFields!
    @IBOutlet weak var sideView: UIView!
    @IBOutlet weak var sideTableView: UITableView!
    
    
    let sideMenu = ["Home","Update Your Profile","Logout"]
    var isSideBarOpen = false
    let dbManager = DatabaseManager()
    var currentEmployeeSkills = [String]()
    let currentEmployee = Auth.auth().currentUser?.email
    var selectedEmployeeEmail = ""
    var flag = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        skillsTable.delegate = self
        skillsTable.dataSource = self
        sideView.isHidden = true
        sideTableView.isHidden = true
        
        sideTableView.dataSource = self
        sideTableView.delegate = self
        
        nameTextField.isUserInteractionEnabled = false
        lastTextField.isUserInteractionEnabled = false
        emailTextField.isUserInteractionEnabled = false
        employeeIdTextField.isUserInteractionEnabled = false
        designationTextField.isUserInteractionEnabled = false
        
        keyboardTaparound()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        showSpinner()
        getCurrentEmployeeProfile()
            }
    
    @IBAction func tapToUpdate(_sender: UIButton) {
        if let goToUpdate = self.storyboard?.instantiateViewController(withIdentifier: "UpdateProfileViewController") as? UpdateProfileViewController {
            navigationController?.pushViewController(goToUpdate, animated: true)
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
    
    @objc func getBack() {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: Function to fetch Current user's profile
    
    func getCurrentEmployeeProfile () {
        var email = ""
        if flag == true {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(getBack))
            
            email = self.selectedEmployeeEmail
        }
        else
        {
            email = self.currentEmployee!
        }
        
        dbManager.readAllEmployees { allEmployeeData in
            if allEmployeeData["Email"] as! String == email
            {
                self.currentEmployeeSkills.append(contentsOf: allEmployeeData["Skills"] as! [String])
                self.skillsTable.reloadData()
                self.nameTextField.text = allEmployeeData["First Name"] as? String
                self.lastTextField.text = allEmployeeData["Last Name"] as? String
                self.emailTextField.text = allEmployeeData["Email"] as? String
                self.employeeIdTextField.text = allEmployeeData["EmployeeID"] as? String
                self.designationTextField.text = allEmployeeData["Designation"] as? String
                self.userProfile.text = "\(allEmployeeData["First Name"]!) \(allEmployeeData["Last Name"]!)"
            }
            self.removeSpinner()
        }
    }
}

//MARK: Tableview Methods

extension YourProfileViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == skillsTable ? currentEmployeeSkills.count: sideMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var returnCell = UITableViewCell()
        if tableView == skillsTable {
            let cell = skillsTable.dequeueReusableCell(withIdentifier: "cellB")
            cell?.textLabel?.text = currentEmployeeSkills[indexPath.row]
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
                let updateProfile = self.storyboard?.instantiateViewController(withIdentifier: "UpdateProfileViewController") as! UpdateProfileViewController
                navigationController?.pushViewController(updateProfile, animated: true)
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
    
    
}
