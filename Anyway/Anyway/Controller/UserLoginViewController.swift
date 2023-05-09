//
//  UserLoginView.swift
//  Anyway
//
//  Created by mingchen Sun on 5/5/2023.
//

import UIKit

class UserLoginViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var genderPickerView: UIPickerView!
    @IBOutlet weak var mobileTextField: UITextField!

    let genderOptions = ["Man", "Woman", "Other"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.genderPickerView.delegate = self
        self.genderPickerView.dataSource = self
        
        // used for resign keyboard when enter is pressed
        nameTextField.delegate = self
        ageTextField.delegate = self
        mobileTextField.delegate = self
    }

    // send the user typed in info to the Questionnaire view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSurvey" {
            let VC = segue.destination as! QuestionnaireViewController
            //name: check and send
            if let name = nameTextField.text, name.isEmpty {
                VC.name = "User"
            } else {
                VC.name = nameTextField.text!
            }
            //age: check age and send
            if let age = ageTextField.text, let ageInt = Int(age) {
                VC.age = String(ageInt)
            } else {
                let alertController = UIAlertController(title: "Invalid Input", message: "Please enter a valid age.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                present(alertController, animated: true, completion: nil)
            }
            
            //mobile: check mobile and send
            if let mobile = mobileTextField.text, let mobileInt = Int(mobile) {
                VC.mobile = String(mobileInt)
            } else {
                let alertController = UIAlertController(title: "Invalid Input", message: "Please enter a valid mobile number.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                present(alertController, animated: true, completion: nil)
            }
            
            //gender: send selected gender
            let selectedGender = genderOptions[genderPickerView.selectedRow(inComponent: 0)]
            VC.gender = selectedGender
        }
    }

    func numberOfComponents(in genderPickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ genderPickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderOptions.count
    }
    
    func pickerView(_ genderPickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderOptions[row]
    }
    
    func pickerView(_ genderPickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // handle gender selection
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // resign keyboard when enter is pressed
        textField.resignFirstResponder()
        return true
    }

}
