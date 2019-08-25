//
//  File.swift
//  javaquiz
//
//  Created by André Felipe Fleck Bedran on 25/08/19.
//  Copyright © 2019 André Bedran. All rights reserved.
//

import UIKit

class ActivityIndicator: XibLoadedView {
    @IBOutlet weak var loader: UIActivityIndicatorView!
    override func didLoadViewFromXIB() {
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }
}
