//
//  Question.swift
//  Anyway
//
//  Created by 梁纪田 on 8/5/2023.
//

import Foundation

struct Question: Codable, Hashable{
    
    var questionText: String
    
    // Default questions
    static var sampleQuestions: [Question] {
        return [
            Question(questionText: "Is this survey app easy to use?"),
            Question(questionText: "What area in this app do you think can be improved?"),
            Question(questionText: "What score would you rate this prototype out of 5?"),
        ]
    }
}
