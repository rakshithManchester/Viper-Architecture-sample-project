//
//  LoginViewController.swift
//  LoginRegisterTodoList
//
//  Created by Appaiah on 24/04/23.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwdTxt: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTxt.delegate = self
        passwdTxt.delegate = self
    }
    @IBAction func loginTapped(sender: UIButton) {
        validateCredentials()
    }
    @IBAction func registerUserTapp(sender: UIButton) {
        self.navigationController?.pushViewController(RegisterUserViewController(), animated: true)
    }
    @IBAction func resetPasswordTapp(sender: UIButton) {
        self.navigationController?.pushViewController(ResetPasswordViewController(), animated: true)
    }
}

extension LoginViewController : UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        validateMailPassRegex()
    }
    func validateMailPassRegex() {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        let passwordRegex = "^(?=.*?[a-z])(?=.*?[A-Z])(?=.*[!@#$&*])(?=.*?[0-9]).{8,32}$"
        let passwordPred = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        
        if emailPred.evaluate(with: usernameTxt.text) && passwordPred.evaluate(with: passwdTxt.text) {
            loginBtn.isUserInteractionEnabled = true
            loginBtn.backgroundColor = UIColor.systemOrange
        } else {
            loginBtn.isUserInteractionEnabled = false
            loginBtn.backgroundColor = UIColor.systemGray5
        }
    }
}

extension LoginViewController {
    func validateCredentials() {
        guard let userName = usernameTxt.text, let password = passwdTxt.text else {
            print("Username or Password is incorrect")
            return
        }
        if fethUsersList(userName: userName, password: password) {
            self.navigationController?.pushViewController(HomeViewController(), animated: true)
        } else {
            let alert = UIAlertController(title: "", message: "Incorrect username or password", preferredStyle: .alert)
            let ok = UIAlertAction(title: "ok", style: .cancel)
            alert.addAction(ok)
            self.present(alert, animated: true)
        }
    }
    
    func fethUsersList(userName: String, password: String) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetched = NSFetchRequest<NSFetchRequestResult>(entityName: "UserCredentials")
        do {
            let fetchedData = try context.fetch(fetched)
            if let results = fetchedData as? [UserCredentials] {
                for result in results {
                    if result.password == password && result.username == userName {
                        return true
                    }
                }
            }
        } catch let exp {
            print(exp)
        }
        return false
    }
}
