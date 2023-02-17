//
//  EmployeeSkillsViewController.swift
//  SkillsTracker
//
//  Created by shubhan.langade on 16/06/22.
//

import UIKit

class EmployeeSkillsViewController: UIViewController {
    
    @IBOutlet weak var employeeSkillsTable: UITableView!
    
    var arrayOfSelectedEmployee = [String]()
    var arrayOfSelectedEmployeeEmail = [String]()
    let dbManager = DatabaseManager()
    var index = ""
    var allEmployeesData = [String : Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showSpinner()
        employeeSkillsTable.delegate = self
        employeeSkillsTable.dataSource = self
        title = "EMPLOYEE LIST"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.systemTeal]
        dbManager.readAllEmployees { allEmployees in
            self.allEmployeesData = allEmployees
            if (self.allEmployeesData["Skills"] as! [String]).contains(self.index)
                {
                        self.arrayOfSelectedEmployee.append((self.allEmployeesData["First Name"] as! String) + " " + (self.allEmployeesData["Last Name"] as! String))
                        print(self.arrayOfSelectedEmployee)
                self.arrayOfSelectedEmployeeEmail.append(self.allEmployeesData["Email"] as! String)
                    
                }
            self.employeeSkillsTable.reloadData()
            self.removeSpinner()
        }

    }
    
}

//MARK: Tableview Methods

extension EmployeeSkillsViewController : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfSelectedEmployee.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = employeeSkillsTable.dequeueReusableCell(withIdentifier: "cellS")
        cell?.detailTextLabel?.textColor = .gray
        cell?.textLabel?.text = arrayOfSelectedEmployee[indexPath.row]
        cell?.detailTextLabel?.text = arrayOfSelectedEmployeeEmail[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let employeeVC = storyboard?.instantiateViewController(withIdentifier: "YourProfileViewController") as! YourProfileViewController
        employeeVC.selectedEmployeeEmail = arrayOfSelectedEmployeeEmail[indexPath.row]
        employeeVC.flag = true
        navigationController?.pushViewController(employeeVC, animated: true)
    }
}
