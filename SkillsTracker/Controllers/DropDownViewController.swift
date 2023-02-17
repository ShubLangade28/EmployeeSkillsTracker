//
//  DropDownViewController.swift
//  SkillsTracker
//
//  Created by Ashlesha Kamble on 08/07/22.
//

import UIKit

protocol GetSelectedSkillsBack {
    func getSelectedSkills (skills: [String])
}

class DropDownViewController: UIViewController {

    @IBOutlet weak var dropDownTable: UITableView!
    var suggestedSkillsArray : [String] = ["SWIFT","ANDROID","JAVA","HTML","REACT-NATIVE","XAMARIN","IOS","WEB","FLUTTER","CPP","IONIC","SWIFTUI","KOTLIN"]
    var selectedSkillsArray = [String]()
    var delegate: GetSelectedSkillsBack?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        dropDownTable.dataSource = self
        dropDownTable.delegate = self
        title = "SELECT SKILLS"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.systemTeal]
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.selectedSkillsArray.removeAll()
        print(selectedSkillsArray)
    }
    
    @IBAction func tapToDone(_ sender: Any) {
        selectedSkillsArray.removeAll()
        if let selectedRows = dropDownTable.indexPathsForSelectedRows {
            for iPath in selectedRows {
                selectedSkillsArray.append(suggestedSkillsArray[iPath.row])
                print(selectedSkillsArray)
            }
        }
        navigationController?.popViewController(animated: true)
        delegate?.getSelectedSkills(skills: selectedSkillsArray)
    }
    
}

extension DropDownViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        suggestedSkillsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "DropdownList", for: indexPath)
        cell.textLabel?.text = suggestedSkillsArray[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dropDownTable.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        dropDownTable.cellForRow(at: indexPath)?.accessoryType = .none
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
        
    }
}
