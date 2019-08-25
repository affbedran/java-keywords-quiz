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
    private var searchBar: UITextField?
    
    private var viewModel: QuizViewModelType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.viewModel = QuizViewModel()
        self.viewModel?.delegate = self
        
        setupNavigationController()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel.getQuiz(for: self.viewModel.path)
    }
    
    func setupNavigationController() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        addMultilineBreakOnTitle()
    }
    
    func addMultilineBreakOnTitle() {
        for navItem in (self.navigationController?.navigationBar.subviews)! {
            for subview in navItem.subviews {
                if let titleLabel = subview as? UILabel {
                    titleLabel.text = self.title
                    titleLabel.numberOfLines = 0
                    titleLabel.lineBreakMode = .byWordWrapping
                }
            }
        }
    }
    
    deinit {
        self.viewModel = nil
    }

}

extension QuizViewController: UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        defer {
            if self.viewModel.hits.count == 0 {
                self.tableView.separatorStyle = .none
            } else {
                self.tableView.separatorStyle = .singleLine
            }
        }
        return self.viewModel?.hits.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HitCell", for: indexPath)
        if let hitKeyword = self.viewModel?.textForHit(at: indexPath) {
            cell.textLabel?.text = hitKeyword.capitalized
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
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
    
    func didFinishLoading() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.navigationItem.title = self.viewModel?.question
        }
    }
}
