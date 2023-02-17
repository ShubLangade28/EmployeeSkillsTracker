//
//  DatabaseManager.swift
//  SkillsTracker
//
//  Created by shubhan.langade on 10/06/22.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class DatabaseManager {
    
    let db = Firestore.firestore()
    typealias SkillsOnDashboard = ([String]) -> ()
    typealias allEmployeeData = ([String : Any]) -> ()
    
    func addEmployeeDetails(firstName : String,
                            lastName : String,
                            email : String,
                            employeeID : String,
                            designation : String,
                            skills : [String])
    {
        let newDocument = db.collection("Employees").document("EmployeeData").collection("Employee").document()
        newDocument.setData(["dcID":"\(newDocument.documentID)",
                             "First Name" : firstName,
                             "Last Name" : lastName,
                             "Email" : email,
                             "EmployeeID" : employeeID,
                             "Designation" : designation,
                             "Skills" : skills])
    }
    
    func readSkillOnDashboard(completionHandler : @escaping SkillsOnDashboard)
    {
        var allEmployeeData = [String : Any]()
        var arrayOfSkills = [String]()
        var arrayofRemoveDuplicateSkills = [String]()
        
        db.collection("Employees").document("EmployeeData") .collection("Employee").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }
            else {
                for document in querySnapshot!.documents {
                    allEmployeeData = document.data()
                    print(allEmployeeData["Skills"] as! [String])
                    arrayOfSkills.append(contentsOf: allEmployeeData["Skills"] as! [String])
                    }
                for skills in arrayOfSkills
                {
                    if arrayofRemoveDuplicateSkills .contains(skills)
                    {
                        print("duplicate")
                    }
                    else
                    {
                        arrayofRemoveDuplicateSkills.append(skills)
                        completionHandler(arrayofRemoveDuplicateSkills)
                    }
                }
            }
        }
    }
    
    func logout(navigation : UINavigationController) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            print("sign out")
            navigation.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        
    }
    
    func readAllEmployees(completionHandler : @escaping allEmployeeData) {
        var allEmployeeData = [String : Any]()
        db.collection("Employees").document("EmployeeData") .collection("Employee").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    allEmployeeData = document.data()
                    DispatchQueue.global().sync {
                    completionHandler(allEmployeeData)
                    }
                }
            }
        }
    }
}
