//
//  OwnerLoginView.swift
//  Anyway
//
//  Created by mingchen Sun on 5/5/2023.
//

import UIKit

class OwnerLoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var textPassword: UITextField!
    @IBOutlet weak var btnOwnerLogin: UIButton!
    @IBOutlet weak var lblHead: UILabel!
    
    let hasPasswordSetup = UserDefaults.standard.bool(forKey: "PasswordSetup")
    override func viewDidLoad() {
        super.viewDidLoad()
        textPassword.isSecureTextEntry = true
        if (hasPasswordSetup){
            //print(hasPasswordSetup)
            lblHead.text = ("type in your password")
        }else{
            //print(hasPasswordSetup)
            lblHead.text = ("set up your password")
            btnOwnerLogin.setTitle("Set Password", for: .normal)
        }
        
        // used for resign keyboard when enter is pressed
        textPassword.delegate = self
    }
    @IBAction func onOwnerLoginBtnPressed(_ sender: Any) {
        //
        if (hasPasswordSetup){
            let storedPassword = UserDefaults.standard.string(forKey: "Password")
                if textPassword.text == storedPassword {
                    print("Password is correct.")
                } else {
                    //print(storedPassword)
                    print("Password is incorrect.")
                    let alert = UIAlertController(title: "", message: "Password Error", preferredStyle: .alert)

                    let attributedTitle = NSAttributedString(string: "ERROR", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])

                    alert.setValue(attributedTitle, forKey: "attributedTitle")

                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)

                }
        }else{
            //set up password
            let newPassword = textPassword.text
            UserDefaults.standard.set(newPassword, forKey: "Password")
            UserDefaults.standard.set(true, forKey: "PasswordSetup")

            print("Password setup successfully.")
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // resign keyboard when enter is pressed
        textField.resignFirstResponder()
        return true
    }
}
