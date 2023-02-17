//
//  CreateProfileViewController.swift
//  SkillsTracker
//
//  Created by Anuja Ladge on 13/06/22.


import UIKit
import FirebaseFirestore
import FirebaseAuth

class CreateProfileViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: TextFields!
    @IBOutlet weak var lastNameTextFeilds: TextFields!
    @IBOutlet weak var emailTextField: TextFields!
    @IBOutlet weak var employeeIDTextField: TextFields!
    @IBOutlet weak var designationTextField: TextFields!
    @IBOutlet weak var skillsTable: UITableView!
    
    var arrayOfSkills = [String]()
    var arrayOfEmployeeID = [String]()
    let db = Firestore.firestore()
    let dbManager = DatabaseManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardTaparound()
        
        skillsTable.delegate = self
        skillsTable.dataSource = self
        emailTextField.isUserInteractionEnabled = false
        fetchCurrentUser()
        dbManager.readAllEmployees { allEmployees in
            self.arrayOfEmployeeID.append(allEmployees["EmployeeID"] as! String)
            }
        
    }
    
    @IBAction func addSkillTapped(_ sender: UIButton) {
        let dD = self.storyboard?.instantiateViewController(withIdentifier: "DropDownViewController") as! DropDownViewController
        dD.delegate = self
        navigationController?.pushViewController(dD, animated: true)
    }
    
    @IBAction func saveTapped(_ sender: UIButton) {
        if ((firstNameTextField.text! != "") && (lastNameTextFeilds.text! != "") && (emailTextField.text! != "") && (employeeIDTextField.text! != "") && (designationTextField.text! != "") && !(arrayOfSkills.isEmpty)) 
        {
            saveToDatabase()
            openAlert(title: "Status",
                      message: "Your Profile has been created successfully.",
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
        else
        {
            openAlert(title: "Alert",
                      message: "Please enter valid data.",
                      alertStyle: .alert,
                      actionTitles: ["Okay"],
                      actionStyles: [.default],
                      actions: [{ _ in
                 print("Okay clicked!")
             }])
        }
    }
    
    //MARK: Function to fetch current user
    
    func fetchCurrentUser () {
        if Auth.auth().currentUser != nil {
            emailTextField.text = Auth.auth().currentUser?.email
        } else {
            
        }
    }
    
    //MARK: Function to save profile to Database
    
    func saveToDatabase()  {
        print(arrayOfEmployeeID)
        if arrayOfEmployeeID.contains(employeeIDTextField.text!)
        {
            self.openAlert(title: "Alert",
                           message: "Employee ID already exist, check your employee ID.",
                           alertStyle: .alert,
                           actionTitles: ["Okay"],
                           actionStyles: [.default],
                           actions: [{ _ in
                print("Okay clicked!")
            }])
        }
        else
        {
            print(emailTextField.text!)
        dbManager.addEmployeeDetails(firstName: (firstNameTextField.text?.description.uppercased())!,
             lastName: (lastNameTextFeilds.text?.description.uppercased())!,
             email: emailTextField.text!,
             employeeID: (employeeIDTextField.text?.description.uppercased())!,
             designation: (designationTextField.text?.description.uppercased())!,
             skills: arrayOfSkills)
        }
        
    }
}

//MARK: Tableview Methods

extension CreateProfileViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfSkills.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellB", for: indexPath)
        cell.textLabel?.text = arrayOfSkills[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            
            self.arrayOfSkills.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            print(arrayOfSkills)
        }
    }
}

extension CreateProfileViewController: GetSelectedSkillsBack {
    func getSelectedSkills(skills: [String]) {
        for skill in skills
        {
            if arrayOfSkills.contains(skill)
            {
                print(arrayOfSkills)
                skillsTable.reloadData()
            }
            else
            {
                arrayOfSkills.append(skill)
                skillsTable.reloadData()
                print("Selected Skills: \(arrayOfSkills)")
            }
        }
    }
}



