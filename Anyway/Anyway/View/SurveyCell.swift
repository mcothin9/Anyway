//
//  SurveyCell.swift
//  Anyway
//
//  Created by 梁纪田 on 8/5/2023.
//

import UIKit

// use delegate to pass data to view controller
protocol SurveyCellDelegate: AnyObject {
    func surveyCellReturned(_ cell: SurveyCell, didEnterResponse response: String)
}

class SurveyCell: UITableViewCell, UITextFieldDelegate {
    
    static let identifier = "SurveyCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "SurveyCell", bundle: nil)
    }
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerTextField: UITextField!
    
    weak var delegate: SurveyCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        answerTextField.placeholder = "Your response"
        answerTextField.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with question: String, response: String?) {
        questionLabel.text = question
        answerTextField.text = response
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        print(textField.text ?? "NA")
        delegate?.surveyCellReturned(self, didEnterResponse: textField.text ?? "NA")
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        print(textField.text ?? "NA")
        delegate?.surveyCellReturned(self, didEnterResponse: textField.text ?? "NA")
    }
    
}
