//
//  QuizViewController.swift
//  javaquiz
//
//  Created by André Felipe Fleck Bedran on 24/08/19.
//  Copyright © 2019 André Bedran. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    private var viewModel: QuizViewModel? = QuizViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.viewModel?.delegate = self
    }
    
    deinit {
        self.viewModel = nil
    }

}

extension QuizViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.hits.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HitCell", for: indexPath)
        if let hitKeyword = self.viewModel?.textForHit(at: indexPath) {
            cell.textLabel?.text = hitKeyword
        }
        return cell
    }
    
}

extension QuizViewController: QuizDelegate {
    func didUpdateTimer(text: String) {
        
    }
    
    func didHitAnswer() {
        
    }
    
    func didRunOutOfTime() {
        
    }
    
    func didFinishQuiz() {
        
    }
    
    
}
