//
//  CapturePhotoViewController.swift
//  Favloc
//
//  Created by Kordian Ledzion on 14/01/2018.
//  Copyright © 2018 KordianLedzion. All rights reserved.
//

import UIKit
import CoreMedia

private struct Constants {
    static let constraintsSizeDefault: CGFloat = 15.0
    static let constraintsSizeAfterAnimation: CGFloat = 25.0
}

protocol CaptureView: class {
    func setImage(with data: Data)
}

class CapturePhotoViewController: UIViewController {
    
    weak var coordinator: MainCoordinator?
    
    private var imageViewWidth: NSLayoutConstraint!
    private var imageViewHeight: NSLayoutConstraint!
    private var imageViewTop: NSLayoutConstraint!
    private var takePhotoButtonWidth: NSLayoutConstraint!
    private var takePhotoButtonHeight: NSLayoutConstraint!
    
    private var camera: LiveCamera!
    
    private let displayView = UIView()
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.backgroundColor = .black
        view.clipsToBounds = true
        view.isHidden = true
        
        view.layer.borderWidth = 3.0
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.24
        view.layer.shadowRadius = 16.0
        view.layer.shadowOffset.height = 2.0
        
        return view
    }()
    
    private let takePhotoButton = TakePhotoButton(frame: CGRect(x: 0.0,
                                                                y: 0.0,
                                                                width: Constants.constraintsSizeDefault,
                                                                height: Constants.constraintsSizeDefault))
    
    private let dismissCompletion: (Data) -> Void
    
    init(dismissCompletion: @escaping (Data) -> Void) {
        self.dismissCompletion = dismissCompletion
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupDisplayView()
        setupTakePhotoButton()
        setupSubviews()
        setupConstraints()
    }
    
    private func setupTakePhotoButton() {
        takePhotoButton.translatesAutoresizingMaskIntoConstraints = false
        takePhotoButton.addTarget(self, action: #selector(takePhotoButtonAction), for: .touchUpInside)
    }
    
    @objc private func takePhotoButtonAction() {
        takePhotoButton.animateColor()
        
        camera.capturePhoto()
    }
    
    private func changeConstraintsConstantWithValue(value: CGFloat) {
        [takePhotoButtonWidth, takePhotoButtonHeight].forEach { constraint in
            constraint.constant = value
        }
    }
    
    private func setupDisplayView() {
        displayView.frame = view.bounds
        view.insertSubview(displayView, at: 0)
        displayView.setNeedsLayout()
        camera = LiveCamera(view: displayView)
        camera.delegate = self
    }
    
    private func setupSubviews() {
        view.addSubview(imageView)
        view.isUserInteractionEnabled = true
        view.addSubview(takePhotoButton)
    }
    
    private func setupConstraints() {
        imageViewWidth = imageView.widthAnchor.constraint(equalToConstant: view.frame.width)
        imageViewHeight = imageView.heightAnchor.constraint(equalToConstant: view.frame.height)
        imageViewTop = imageView.topAnchor.constraint(equalTo: view.topAnchor)
        takePhotoButtonWidth = takePhotoButton.widthAnchor.constraint(equalToConstant: Constants.constraintsSizeDefault)
        takePhotoButtonHeight = takePhotoButton.heightAnchor.constraint(equalToConstant: Constants.constraintsSizeDefault)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageViewTop,
            imageViewWidth,
            imageViewHeight,
            
            takePhotoButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8.0),
            takePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

extension CapturePhotoViewController: LiveCameraDelegate {
    
    func didCaptureImage(_ data: Data?, on camera: LiveCamera) {
        guard let data = data, let image = UIImage(data: data), let png = UIImagePNGRepresentation(image) else {
            return
        }
        dismissCompletion(png)
        navigationController?.popViewController(animated: true)
    }
}

extension CapturePhotoViewController: CaptureView {
    
    func setImage(with data: Data) {
        imageView.image = UIImage(data: data)
    }
}


