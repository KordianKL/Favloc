//
//  MainCollectionViewControllerCell.swift
//  Favloc
//
//  Created by Kordian Ledzion on 12/01/2018.
//  Copyright © 2018 KordianLedzion. All rights reserved.
//

import UIKit

class MainCollectionViewControllerCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20.0
        imageView.image = #imageLiteral(resourceName: "unknown")
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = .black
        label.font = UIFont.appMediumFont(ofSize: 14)
        label.text = "Fav place ever 😍" //Placeholder text
        return label
    }()
    
    private let borderWidthAnimation: CABasicAnimation = {
        let animation = CABasicAnimation(keyPath: "borderWidth")
        animation.duration = 0.25
        return animation
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.borderColor = UIColor.dodgerBlue.cgColor
        setupShadow()
        setupConstraints()
        layer.add(borderWidthAnimation, forKey: "Width")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func toggleBorder() {
        if layer.borderWidth == 0.0 {
            layer.borderWidth = 3.0
        } else {
            layer.borderWidth = 0.0
        }
    }
    
    func setUp(with place: Place) {
        imageView.image = place.image
        titleLabel.text = place.name
    }
    
    private func setupShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.35
        layer.shadowOffset = .zero
        layer.shadowRadius = 12.0
        layer.cornerRadius = 20.0
    }
    
    private func setupConstraints() {
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.0),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.0),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8.0)
            ])
        
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3.0),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 3.0),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -3.0),
            imageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -6.0)
            ])
    }
}
