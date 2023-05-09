//
//  ModifyQuestionView.swift
//  Anyway
//
//  Created by mingchen Sun on 5/5/2023.
//

import UIKit
import MessageUI

class ModifyQuestionViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var questions: [Question] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Questions" // navigation title
        // Create custom back button - otherwise the back button goes back to ownerloginview instead of home view
        let homeButton = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(homeButtonTapped))
        navigationItem.leftBarButtonItem = homeButton
        
        fetchQuestions()
        tableView.dataSource = self
        tableView.delegate = self
    }

    @objc func homeButtonTapped() {
        // questions are not saved if only home button is pressed
        // Storage.store(questions, to: .documents, as: "questions.json")
        goToHomeView()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        // create a textField that is with larger scope to store what user types in the UI alert
        var textField = UITextField()
        let alert = UIAlertController(title: "New Question", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Question", style: .default) { (action) in
            // append quesion to questions when user click button in alert
            self.questions.append(Question(questionText: textField.text!))
            // update UI
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new question"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        Storage.store(questions, to: .documents, as: "questions.json")
        goToHomeView()
    }
    
    @IBAction func resetButtonPressed(_ sender: UIButton) {
        // remove "questions.json"
        Storage.remove("questions.json", from: .documents)
        // Store sample questions
        questions = Question.sampleQuestions
        Storage.store(questions, to: .documents, as: "questions.json")
        goToHomeView()
    }
    
    @IBAction func exportButtonPressed(_ sender: UIButton) {
        // This needs to be ran on a device, simulator do not have access to mail app
        showMailComposer()
        deleteResponsesFromDevice()
    }
    
    func fetchQuestions() {
        questions = Storage.retrive("questions.json", from: .documents, as: [Question].self) ?? []
        if questions == [] {
            questions = Question.sampleQuestions
        }
    }
    
    func goToHomeView() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: Email functions
    
    func getDateInString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let today = formatter.string(from: Date())
        return today
    }
    
    func showMailComposer() {
    
        guard MFMailComposeViewController.canSendMail() else {
            return
        }
        
        let date = getDateInString()
        
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients(["brucethetester7@gmail.com"])
        composer.setSubject("Survey Questions & Responses \(date)")
        composer.setMessageBody("Questions and Responses are in the attachments", isHTML: false)
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: documentsURL.path)
            let responseFiles = files.filter { $0.hasSuffix(".json") }
            
            for file in responseFiles {
                let filePath = documentsURL.appendingPathComponent(file)
                if let fileData = try? Data(contentsOf: filePath) {
                    composer.addAttachmentData(fileData, mimeType: "application/json", fileName: file)
                }
            }
            
            present(composer, animated: true)
            
        } catch {
            // Handle error if unable to fetch response files
            print("Failed to fetch response files: \(error.localizedDescription)")
        }
    }

    func deleteResponsesFromDevice() {
        Storage.clear(.documents)
    }
    
}

// MARK: UITableViewDataSource Extension
extension ModifyQuestionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath)
        let question = questions[indexPath.row]
        cell.textLabel?.text = question.questionText
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        return cell
    }
}

// MARK: UITableViewDelegate Extension
extension ModifyQuestionViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        popModifyQuestionAlert(index: indexPath.row)
    }
    
    func popModifyQuestionAlert(index: Int) {
        // create a textField that is with larger scope to store what user types in the UI alert
        var textField = UITextField()
        let originalQ = questions[index].questionText
        let alert = UIAlertController(title: "Modifying question: ", message: originalQ, preferredStyle: .alert)
        let action = UIAlertAction(title: "Modify", style: .default) { (action) in
            // what will happen when user click button in alert
            self.questions[index].questionText = textField.text!
            // update UI
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New Question"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: MFMailComposeViewControllerDelegate Extension
extension ModifyQuestionViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        if let _ = error {
            controller.dismiss(animated: true)
            return
        }
        
        switch result {
        case .cancelled:
            print("Cancelled")
        case .failed:
            print("Failed to send")
        case .saved:
            print("Saved")
        case .sent:
            print("Email Sent")
        @unknown default:
            break
        }
        
        controller.dismiss(animated: true)
    }
}
