//
//  TakePhotoButton.swift
//  Favloc
//
//  Created by Kordian Ledzion on 14/01/2018.
//  Copyright © 2018 KordianLedzion. All rights reserved.
//

import UIKit

class TakePhotoButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        setTitle("", for: .normal)
        backgroundColor = .clear
        layer.borderWidth = 2.0
        layer.borderColor = UIColor.white.cgColor
        layer.cornerRadius = frame.width / 2.0
        layer.masksToBounds = true
        clipsToBounds = true
    }
    
    func animateColor() {
        UIView.animate(withDuration: 0.35, animations: {
            self.backgroundColor = .red
        }) { _ in
            UIView.animate(withDuration: 0.35, animations: {
                self.backgroundColor = .clear
            })
        }
    }
}
