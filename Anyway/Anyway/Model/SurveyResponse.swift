//
//  SurveyResponse.swift
//  Anyway
//
//  Created by 梁纪田 on 8/5/2023.
//

import Foundation

struct SurveyResponse: Codable, Hashable{
    var name: String
    var age: String
    var gender: String
    var mobile: String
    var responses: [String]
}
