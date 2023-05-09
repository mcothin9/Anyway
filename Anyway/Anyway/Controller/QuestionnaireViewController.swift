//
//  QuestionnaireView.swift
//  Anyway
//
//  Created by mingchen Sun on 5/5/2023.
//

import UIKit

class QuestionnaireViewController: UIViewController {

    var name: String?
    var age: String?
    var gender : String?
    var mobile : String?
    var questions: [Question] = []
    var responses: [String] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Questionnaire"
        fetchQuestions()
        setupResponses()
        setupTableView()
    }

    func fetchQuestions() {
        questions = Storage.retrive("questions.json", from: .documents, as: [Question].self) ?? []
        print("Fetched questions count: \(questions.count)")
    }
    
    func setupResponses() {
        for _ in questions {
            responses.append("NA")
        }
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.register(SurveyCell.nib(), forCellReuseIdentifier: SurveyCell.identifier)
    }

    @IBAction func finishButtonPressed(_ sender: UIButton) {

        let response = SurveyResponse(name: name ?? "NA", age: age ?? "NA", gender: gender ?? "NA", mobile: mobile ?? "NA", responses: responses)
        let filename = getNextResponseFilename()
        Storage.store(response, to: .documents, as: filename)
    
        navigationController?.popToRootViewController(animated: true)
    }
    
    func getNextResponseFilename() -> String {
        let number = getNumberOfResponses()
        return "\(number).json"
    }
    
    func getNumberOfResponses() -> Int {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: documentsURL.path)
            let responseFiles = files.filter { $0.hasSuffix(".json") }
            return responseFiles.count
        } catch {
            print("Failed to get number of responses: \(error.localizedDescription)")
        }
        return 0
    }
    
}

// MARK: UITableViewDataSource Extension
extension QuestionnaireViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SurveyCell", for: indexPath) as! SurveyCell
        let question = questions[indexPath.row]
        let response = indexPath.row < responses.count && responses[indexPath.row] != "NA" ? responses[indexPath.row] : nil
        cell.configure(with: question.questionText, response: response)
        cell.delegate = self
        return cell
    }
}

// MARK: - SurveyCellDelegate

extension QuestionnaireViewController: SurveyCellDelegate {
    func surveyCellReturned(_ cell: SurveyCell, didEnterResponse response: String) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        let questionIndex = indexPath.row
        // Store the user response in the appropriate index of the `responses` array
        responses[questionIndex] = response
    }
}
