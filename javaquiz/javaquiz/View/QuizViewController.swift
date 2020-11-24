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
    @IBOutlet weak var footerView: QuizFooter!
    private var searchBar: SearchHeaderView?
    
    //I declared this variable to save time when calculating keyboard show/hide sizes
    private var footerOrigin: CGFloat!
    
    @IBOutlet private weak var loader: ActivityIndicator!
    
    private var viewModel: QuizViewModelType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.viewModel = QuizViewModel()
        self.viewModel?.delegate = self
        
        self.footerView.button.addTarget(self, action: #selector(runQuizLoop), for: .touchUpInside)
        
        setupNavigationController()
        registerForKeyboardNotifications()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loader.isHidden = false
        self.viewModel.getQuiz(for: self.viewModel.path)
        self.footerOrigin = self.footerView.frame.origin.y
        self.searchBar?.isUserInteractionEnabled = false
    }
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(keyboardWillShow),
                         name: UIResponder.keyboardWillShowNotification,
                         object: nil)
        
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(keyboardWillHide),
                         name: UIResponder.keyboardWillHideNotification,
                         object: nil)
    }
    
    private func setupNavigationController() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        addMultilineBreakOnTitle()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.footerView.frame.origin.y -= keyboardSize.height
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.footerView.frame.origin.y = self.footerOrigin
    }
    
    private func addMultilineBreakOnTitle() {
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
    
    @objc func runQuizLoop() {
        guard let button = self.footerView.button else { return }
        if button.isSelected {
            self.searchBar?.searchField.text = ""
            self.footerView.resetState()
            self.viewModel.resetQuiz()
            self.tableView.reloadData()
        } else {
            self.viewModel.startQuiz()
        }
        button.isSelected.toggle()
        self.searchBar?.isUserInteractionEnabled = button.isSelected
    }
    
    deinit {
        self.viewModel = nil
    }

}

extension QuizViewController: UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
        //This prevents the view from being reinstantiated and keeps a handy reference to it.
        if let view = self.searchBar {
            return view
        } else {
            let view = SearchHeaderView()
            self.searchBar = view
            self.searchBar?.searchField.delegate = self
            self.searchBar?.searchField.addTarget(self, action: #selector(didTypeOnSearchField(textField:)), for: .editingChanged)
            return view
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //this was not specified and thus was assumed based on overall appearance.
        return 70
    }
    
    @objc func didTypeOnSearchField(textField: UITextField) {
        if self.viewModel.calculateHit(with: textField.text!) {
            textField.text = ""
        }
    }
    
}

extension QuizViewController: QuizDelegate {
    func didHitAnswer(partial: String, total: String) {
        self.tableView.reloadData()
        self.tableView.scrollToRow(at: IndexPath(row: self.viewModel.hits.count-1, section: 0),
                                   at: .top,
                                   animated: true)
        self.footerView.hitLabel.text = "\(partial)/\(total)"
    }
    
    func didUpdateTimer(text: String) {
        print(text)
        self.footerView.timerLabel.text = text
    }
    
    func didRunOutOfTime() {
        let hits = self.viewModel.hits.count
        let total = self.viewModel.answer.count
        let alert = UIAlertController(title: "Time finished",
                                      message: "Sorry, time is up! You got \(hits) out of \(total) answers.",
            preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: { (_) in
            self.runQuizLoop()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func didFinishQuiz() {
        let alert = UIAlertController(title: "Congratulations",
                                      message: "Good job! You found all the answers on time. Keep up with the great work.",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Play Again", style: .default, handler: { (_) in
            self.runQuizLoop()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func didFinishLoading() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.navigationItem.title = self.viewModel?.question
            self.loader.isHidden = true
        }
    }
}
