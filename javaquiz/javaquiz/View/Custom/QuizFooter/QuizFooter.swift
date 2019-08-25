//
//  QuizFooter.swift
//  javaquiz
//
//  Created by André Felipe Fleck Bedran on 25/08/19.
//  Copyright © 2019 André Bedran. All rights reserved.
//

import UIKit

class QuizFooter: XibLoadedView {
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var hitLabel: UILabel!
    
    override func didLoadViewFromXIB() {
        self.button.layer.cornerRadius = 10
        self.button.layer.masksToBounds = true
        resetState()
    }
    
    func resetState() {
        self.hitLabel.text = "00/50"
        self.timerLabel.text = "05:00"
    }
}
