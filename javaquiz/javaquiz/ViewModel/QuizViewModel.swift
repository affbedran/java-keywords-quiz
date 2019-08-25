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
    func didHitAnswer(partial: String, total: String)
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
    func calculateHit(with string: String) -> Bool
    func startQuiz()
    func resetQuiz()
}

class QuizViewModel: QuizViewModelType {

    private(set) var path: Path = .java
    
    private(set) var hits: [String] = []
    private(set) var answer: [String] = []
    private(set) var question: String?
    
    static let totalTime = 300 //Total time in seconds
    private var currentTime = QuizViewModel.totalTime
    
    private var isRunningQuiz = false
    
    private var timer = Timer()
    
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
    
    func calculateHit(with string: String) -> Bool {
        let lowKey = string.lowercased()
        if self.answer.contains(lowKey) && !self.hits.contains(lowKey.capitalized) {
            self.hits.append(lowKey.capitalized)
            self.delegate?.didHitAnswer(partial: String(hits.count), total: String(answer.count))
            if hits.count == answer.count {
                self.delegate?.didFinishQuiz()
            }
            return true
        } else {
            return false
        }
    }
    
    func startQuiz() {
        self.startTimer()
    }
    func resetQuiz() {
        self.timer.invalidate()
        self.isRunningQuiz = false
        self.currentTime = QuizViewModel.totalTime
        self.hits = []
    }
    
    private func startTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 1,
                                          target: self,
                                          selector: #selector(updateTimer),
                                          userInfo: nil,
                                          repeats: true)
    }
    
    @objc func updateTimer() {
        self.currentTime -= 1
        if currentTime >= 0 {
            let minutes: Int = currentTime/60
            let seconds: Int = currentTime % 60
            
            self.delegate?.didUpdateTimer(text: "\(minutes):\(seconds)")
        } else {
            self.delegate?.didRunOutOfTime()
        }
    }
    
    deinit {
        delegate = nil
    }
    
}
