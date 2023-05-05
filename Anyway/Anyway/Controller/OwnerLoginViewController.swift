//
//  OwnerLoginView.swift
//  Anyway
//
//  Created by mingchen Sun on 5/5/2023.
//

import UIKit

class OwnerLoginViewController: UIViewController {

    @IBOutlet weak var textPassword: UITextField!
    @IBOutlet weak var btnOwnerLogin: UIButton!
    @IBOutlet weak var lblHead: UILabel!
    
    let hasPasswordSetup = UserDefaults.standard.bool(forKey: "PasswordSetup")
    override func viewDidLoad() {
        super.viewDidLoad()
        if (hasPasswordSetup){
            //print(hasPasswordSetup)
            lblHead.text = ("type in your password")
        }else{
            //print(hasPasswordSetup)
            lblHead.text = ("set up your password")
        }
    }
    @IBAction func onOwnerLoginBtnPressed(_ sender: Any) {
        //
        if (hasPasswordSetup){
            let storedPassword = UserDefaults.standard.string(forKey: "Password")
                if textPassword.text == storedPassword {
                    print("Password is correct.")
                } else {
                    print("Password is incorrect.")
                    let alert = UIAlertController(title: "Error", message: "password error", preferredStyle: .alert)
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

}
