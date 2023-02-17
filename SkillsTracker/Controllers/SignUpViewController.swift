//
//  SignUpViewController.swift
//  SkillsTracker
//
//  Created by Ashlesha Kamble on 09/06/22.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {

    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var signUpStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardTaparound()
    }
    
    @IBAction func tapToRegister(_ sender: Any) {
        DispatchQueue.main.async {
            self.checkConditions()
            self.userRegistration()
        }
        }
    
    @IBAction func tapToLogin(_ sender: Any) {
        let login = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        navigationController?.pushViewController(login, animated: true)
        
    }
    
//MARK: User Registration
    func userRegistration() {
        let password = passwordTextField.text
        if ((password?.isValidPassword) == true) {
            if self.passwordTextField.text == self.confirmPasswordTextField.text
            {
                Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { authResult, error in
                    if let u = authResult?.user
                    {
                        print(u)
                        print("User Register")
                        let login = self.storyboard?.instantiateViewController(withIdentifier: "CreateProfileViewController") as! CreateProfileViewController
                        self.navigationController?.pushViewController(login, animated: true)
                    }
                    else
                    {
                        self.openAlert(title: "Alert", message: "You already have an Account. Please LogIn.", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [{ _ in
                            print("Problem with User registration.")
                        }])
                    }
                }
            }
        }
        else {
            self.openAlert(title: "Invalid Password", message: "Please provide valid password.", alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.default], actions: [{ _ in
                print("Enter correct password.")
            }])
        }
    }
    
//MARK: Function Check Conditions
    
    fileprivate func checkConditions(){
        if passwordTextField.text ==  "" && confirmPasswordTextField.text == "" && emailTextField.text == ""   {
                       openAlert(title: "Alert", message: "Please enter valid data.", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{ _ in
                            print("Okay clicked!")
                        }])
                    }
           else if let password = passwordTextField.text, let email = emailTextField.text, let confirmPassword = confirmPasswordTextField.text {
                if email == "" {
                        openAlert(title: "Alert", message: "Please enter Email.", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{ _ in
                            print("Okay clicked!")
                        }])
                }
               else if !email.isValidEmail{
                       openAlert(title: "Alert", message: "Please enter valid Email.", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{ _ in
                           print("Okay clicked!")
                       }])
               }
                else {
                    let result = true
                    switch result {
                    case password == "" :
                        openAlert(title: "Alert", message: "Please enter Password.", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{ _ in
                            print("Okay clicked!")
                        }])
                        break
                        
                    case confirmPassword == "" :
                        openAlert(title: "Alert", message: "Please confirm your password", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{ _ in
                            print("Okay clicked!")
                        }])
                        
                    case !password.isValidPassword:
                        openAlert(title: "Alert", message: "Please enter valid Password!", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{ _ in
                            print("Okay clicked!")
                        }])
                        break
                        
                    case !password.isValidPassword && (password == confirmPassword):
                        openAlert(title: "Alert", message: "Please enter valid Password!", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{ _ in
                            print("Okay clicked!")
                        }])
                        break
                        
                    case password != confirmPassword:
                        openAlert(title: "Alert", message: "Password is not matching!", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{ _ in
                            print("Okay clicked!")
                        }])
                    
                        break
                        
                    default:
                        return
                    }
                }
}
}
}
