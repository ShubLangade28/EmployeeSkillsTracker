//
//  LoginViewController.swift
//  SkillsTracker
//
//  Created by Ashlesha Kamble on 09/06/22.


import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailtextField: UITextField!
    @IBOutlet weak var theStack: UIStackView!
    @IBOutlet weak var passwordTextField: UITextField!
    var emailField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardTaparound()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //emailtextField.text = ""
        //passwordTextField.text = ""
    }
    @IBAction func tapToLogin(_ sender: Any) {
        DispatchQueue.main.async {
            self.checkConditions()
            self.checkIfUserIsRegistered()
        }
     }
    
    @IBAction func forgotPassword(_ sender: Any) {
               alertToChangePassword()
    }
    
    @IBAction func tapToSignUp(_ sender: Any) {
        if let signup = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController {
            navigationController?.pushViewController(signup, animated: true) }
            }

//MARK: Alert to change Password
    
    func alertToChangePassword() {
            let alert = UIAlertController(title: "Enter your registered Email.", message: "A link to change password will be send to your Email.", preferredStyle: .alert)

            alert.addTextField { field in
                self.emailField = field
                field.placeholder = "Email"
                field.keyboardType = .emailAddress
            }

            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { _ in

                if let email = self.emailField?.text, !email.isEmpty {
                    Auth.auth().sendPasswordReset(withEmail: self.emailField!.text!) { error in
                    if let error = error
                    {
                        print("Error to reset password")
                        print(error.localizedDescription)
                        return
                    }
                    print("Password reset mail has been sent")
                        self.openAlert(title: "Alert", message: "An email has been sent to your registered email ID.", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{ _ in
                             print("Okay clicked!")
                         }])

                 }
                }
             }
            ))
            present(alert, animated: true)
        }
    
//MARK: Function to check if user is registered
    
    func checkIfUserIsRegistered () {
        Auth.auth().signIn(withEmail: emailtextField.text!, password: passwordTextField.text!) { [weak self] authResult, error in
            if let u = authResult?.user
            {
                print(u)
                print("User Found")
                let dashboard = self?.storyboard?.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
                self?.navigationController?.pushViewController(dashboard, animated: true)
            }
            else
            {
                print("User Not Found")
                self?.openAlert(title: "Alert", message: "Something went wrong please check your emailID & password", alertStyle: .alert, actionTitles: ["Ok"], actionStyles: [.default], actions: [{ _ in
                    print("Ok Cliked")
                }])
            }
        }
    }
    
    //MARK: Function Check Conditions
        
        fileprivate func checkConditions(){
            if passwordTextField.text ==  "" && emailtextField.text == ""   {
                        openAlert(title: "Alert", message: "Please enter valid data.", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{ _ in
                             print("Okay clicked!")
                         }])
                     }
           else if let email = emailtextField.text, let password = passwordTextField.text {
                 if email == "" {
                    openAlert(title: "Alert", message: "Please enter Email.", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{ _ in
                        print("Okay clicked!")
                    }])
            }
                else if !email.isValidEmail {
                openAlert(title: "Alert", message: "Invalid Email", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{ _ in
                    print("Okay clicked!")
                }])
            }
                else if !password.isValidPassword{
                    openAlert(title: "Alert", message: "Please enter valid Password!", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{ _ in
                        print("Okay clicked!")
                    }])
            }
            else if password == "" {
                    openAlert(title: "Alert", message: "Please enter Password.", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{ _ in
                        print("Okay clicked!")
                    }])
            }
            else {
                
                return
            }
                
            }
}
}
