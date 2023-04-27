//
//  RegisterUserViewController.swift
//  LoginRegisterTodoList
//
//  Created by Appaiah on 24/04/23.
//

import UIKit
import CoreData

class RegisterUserViewController: UIViewController {
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var registerBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userName.delegate = self
        password.delegate = self
    }
    
    @IBAction func registerClick(sender: UIButton) {
        if let username = userName.text, let password = password.text {
            saveUserCredetionls(name: username, password: password)
        }
    }
}

extension RegisterUserViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let username = userName.text, let password = password.text {
            if validateUserInput(name: username, password: password) {
                registerBtn.backgroundColor = .systemOrange
                registerBtn.isUserInteractionEnabled = true
            } else {
                registerBtn.backgroundColor = .systemGray5
                registerBtn.isUserInteractionEnabled = false
            }
        }
    }
}
    
    extension RegisterUserViewController {
        func saveUserCredetionls(name: String, password: String) {
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appdelegate.persistentContainer.viewContext
            
            let user = UserCredentials(context: context)
            user.password = password
            user.username = name
            do {
                try context.save()
            } catch let exp {
                print(exp)
            }
        }
        
        func validateUserInput(name: String, password: String) -> Bool {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            
            let passwordRegex = "^(?=.*?[a-z])(?=.*?[A-Z])(?=.*[!@#$&*])(?=.*?[0-9]).{8,32}$"
            let passwordPred = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
            if emailPred.evaluate(with: name) && passwordPred.evaluate(with: password) {
                return true
            }
            return false
        }
    }
