//
//  QuizViewModel.swift
//  javaquiz
//
//  Created by André Felipe Fleck Bedran on 24/08/19.
//  Copyright © 2019 André Bedran. All rights reserved.
//

import Foundation

protocol QuizDelegate {
    func didUpdateTimer(text: String)
    func didHitAnswer()
    func didRunOutOfTime()
    func didFinishQuiz()
}

class QuizViewModel {
    
    private(set) var hits: [String] = []
    private(set) var answer: [String] = []
    var delegate: QuizDelegate?
    
    func textForHit(at path: IndexPath) -> String? {
        let row = path.row
        guard row < hits.count else { return nil }
        return hits[row]
    }
    
    deinit {
        delegate = nil
    }
    
}
