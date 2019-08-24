//
//  Answer.swift
//  javaquiz
//
//  Created by André Felipe Fleck Bedran on 24/08/19.
//  Copyright © 2019 André Bedran. All rights reserved.
//

import Foundation

protocol Quizzable {
    var question: String? {get}
    var answer: [String]? {get}
}

class Quiz: Quizzable, Codable {
    private(set) var question: String?
    private(set) var answer: [String]?
    
    init(question: String?, answer: [String]?) {
        self.question = question
        self.answer = answer
    }
}
