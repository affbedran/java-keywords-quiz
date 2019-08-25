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
    func didFinishLoading()
}

protocol QuizViewModelType {
    var path: Path {get}
    var hits: [String] {get}
    var answer: [String] {get}
    var question: String? {get}
    var delegate: QuizDelegate? {get set}
    func getQuiz(for path: Path)
    func textForHit(at path: IndexPath) -> String?
    
}

class QuizViewModel: QuizViewModelType {

    private(set) var path: Path = .java
    
    private(set) var hits: [String] = []
    private(set) var answer: [String] = []
    private(set) var question: String?
    
    var delegate: QuizDelegate?
    
    init(path: Path = .java) {
        self.path = path
    }
    
    func getQuiz(for path: Path) {
        NetworkManager.shared.requestQuiz(at: path) { (data, error) in
            do {
                guard let data = data else { return }
                let quiz = try JSONDecoder().decode(Quiz.self, from: data)
                if let question = quiz.question, let answer = quiz.answer {
                    self.answer = answer
                    self.question = question
                    self.delegate?.didFinishLoading()
                }
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func textForHit(at path: IndexPath) -> String? {
        let row = path.row
        guard row < hits.count else { return nil }
        return hits[row]
    }
    
    deinit {
        delegate = nil
    }
    
}
