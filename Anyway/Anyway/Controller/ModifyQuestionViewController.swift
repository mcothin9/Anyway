//
//  ModifyQuestionView.swift
//  Anyway
//
//  Created by mingchen Sun on 5/5/2023.
//

import UIKit

class ModifyQuestionViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var questions: [Question] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Questions" // navigation title
        // Create custom back button - otherwise the back button goes back to ownerloginview instead of home view
        let homeButton = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(homeButtonTapped))
        navigationItem.leftBarButtonItem = homeButton
        // navigationItem.hidesBackButton = true // hide navigation button
//        questions = Question.sampleQuestions
        fetchQuestions()
        tableView.dataSource = self
        tableView.delegate = self
    }

    @objc func homeButtonTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        // create a textField that is with larger scope to store what user types in the UI alert
        var textField = UITextField()
        let alert = UIAlertController(title: "New Question", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Question", style: .default) { (action) in
            // what will happen when user click button in alert
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
        goToHomeView()
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
