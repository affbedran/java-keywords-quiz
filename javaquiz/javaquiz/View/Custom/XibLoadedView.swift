//
//  File.swift
//  javaquiz
//
//  Created by André Felipe Fleck Bedran on 25/08/19.
//  Copyright © 2019 André Bedran. All rights reserved.
//

import UIKit

class XibLoadedView: UIView {
    
    var contentView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    private func xibSetup() {
        guard let contentView = loadViewFromNib() else { return }
        contentView.frame = bounds
        contentView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        addSubview(contentView)
        didLoadViewFromXIB()
    }
    
    func didLoadViewFromXIB() {
        
    }
}

extension UIView {
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView else {
            return nil
        }
        return view
    }
}
