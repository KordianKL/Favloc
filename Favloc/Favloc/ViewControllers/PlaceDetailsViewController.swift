//
//  PlaceDetailsViewController.swift
//  Favloc
//
//  Created by Kordian Ledzion on 14/01/2018.
//  Copyright © 2018 KordianLedzion. All rights reserved.
//

import UIKit

class PlaceDetailsViewController: UIViewController {
    
    weak var coordinator: MainCoordinator?
    
    private lazy var smallViewsHeightOrWidth: CGFloat = {
        return layoutContextValue(base: CGFloat(32.0),
                                  contextMapping: [.iPhone5_5: CGFloat(64.0),
                                                   .iPhone4_7: CGFloat(48.0),
                                                   .iPhone4_0: CGFloat(32.0),
                                                   .iPhone3_5: CGFloat(16.0)])
    }()
    
    private var descriptionBottomAnchor = NSLayoutConstraint()
    private var photoTopAnchor = NSLayoutConstraint()
    private let saveButton = UIBarButtonItem()
    private let placePhoto = UIButton()
    private let placeTitle = UITextView()
    private let placeDescription = UITextView()
    private let placeLocation = UIButton()
    private let viewModel: DataSource
    private let place: Place
    private var newLatitude = 0.0
    private var newLongitude = 0.0
    private let dismissCompletion: () -> Void
    
    init(place: Place, viewModel: DataSource, _ dismissCompletion: @escaping () -> Void) {
        self.dismissCompletion = dismissCompletion
        self.place = place
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpPhoto()
        setUpTitle()
        setUpDescription()
        setUpLocation()
        setUpNavBar()
        layoutSubviews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        dismissCompletion()
        super.viewWillDisappear(animated)
    }
    
    private func setUpNavBar() {
        navigationItem.title = place.name
        saveButton.style = .plain
        saveButton.title = "Save"
        saveButton.action = #selector(saveProcess)
        saveButton.target = self
        navigationItem.rightBarButtonItem = saveButton
    }
    
    @objc private func saveProcess() {
        place.name = placeTitle.text
        place.photo = UIImagePNGRepresentation((placePhoto.imageView?.image!)!)! as NSData
        place.desc = placeDescription.text
        place.longitiude = newLongitude
        place.latitiude = newLatitude
        viewModel.finishedEditing {
            dismissCompletion()
        }
    }
    
    private func setUpPhoto() {
        placePhoto.layer.cornerRadius = 20.0
        placePhoto.clipsToBounds = true
        placePhoto.contentMode = .scaleAspectFill
        placePhoto.setImage(place.image, for: .normal)
        placePhoto.addTarget(self, action: #selector(capturePhoto), for: .touchUpInside)
    }
    
    @objc private func capturePhoto() {
        coordinator?.presentPhotoCapture { [unowned self] data in
            self.placePhoto.setImage(UIImage(data: data)!, for: .normal)
        }
    }
    
    private func setUpTitle() {
        placeTitle.textColor = .black
        placeTitle.textAlignment = .center
        placeTitle.font = UIFont.appDemiBoldFont(ofSize: 18.0)
        placeTitle.text = place.name
        placeTitle.layer.cornerRadius = 20.0
        placeTitle.backgroundColor = .paleGrey
        placeTitle.contentInset = .init(top: 4.0, left: 1.0, bottom: 1.0, right: 1.0)
        placeTitle.delegate = self
    }
    
    private func setUpDescription() {
        placeDescription.textColor = .black
        placeDescription.font = UIFont.appMediumFont(ofSize: 18.0)
        placeDescription.text = place.desc
        placeDescription.layer.cornerRadius = 20.0
        placeDescription.backgroundColor = .paleGrey
        placeDescription.contentInset = .init(top: 2.0, left: 4.0, bottom: 2.0, right: 2.0)
        placeDescription.delegate = self
    }
    
    private func setUpLocation() {
        placeLocation.setImage(#imageLiteral(resourceName: "location"), for: .normal)
        placeLocation.imageView?.contentMode = .scaleToFill
        placeLocation.addTarget(self, action: #selector(handleLocation), for: .touchUpInside)
    }
    
    @objc private func handleLocation() {
        if -90.0...90.0 ~= place.latitiude && -180.0...180 ~= place.longitiude {
            let googleURL = URL(string: "comgooglemaps://?daddr=\(place.longitiude),\(place.latitiude)")
            let googleWebURL = URL(string: "http://www.maps.google.com/maps?daddr=\(place.longitiude),\(place.latitiude)")
            let appleURL = URL(string: "http://maps.apple.com/?daddr=\(place.longitiude),\(place.latitiude)")
            if UIApplication.shared.canOpenURL(appleURL!) {
                UIApplication.shared.open(appleURL!, options: [:], completionHandler: {(_ success: Bool) -> Void in
                })
                return
            }
            if UIApplication.shared.canOpenURL(googleURL!) {
                UIApplication.shared.open(googleURL!, options: [:], completionHandler: {(_ success: Bool) -> Void in
                })
                return
            }
            else {
                UIApplication.shared.open(googleWebURL!, options: [:], completionHandler: {(_ success: Bool) -> Void in
                })
            }
        } else {
            coordinator?.presentLocationPicker { [unowned self] (longitude, latitude) in
                self.newLongitude = longitude
                self.newLatitude = latitude
            }
        }
    }
    
    private func layoutSubviews() {
        placePhoto.translatesAutoresizingMaskIntoConstraints = false
        placeTitle.translatesAutoresizingMaskIntoConstraints = false
        placeDescription.translatesAutoresizingMaskIntoConstraints = false
        placeLocation.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(placePhoto)
        view.addSubview(placeTitle)
        view.addSubview(placeDescription)
        view.addSubview(placeLocation)
        
        descriptionBottomAnchor = placeDescription.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -6.0)
        photoTopAnchor = placePhoto.topAnchor.constraint(equalTo: view.topAnchor, constant: 6.0)
        
        NSLayoutConstraint.activate([
            placePhoto.heightAnchor.constraint(equalToConstant: 210.0),
            photoTopAnchor,
            placePhoto.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6.0),
            placePhoto.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -6.0),
            
            descriptionBottomAnchor,
            placeDescription.leadingAnchor.constraint(equalTo: placePhoto.leadingAnchor),
            placeDescription.trailingAnchor.constraint(equalTo: placePhoto.trailingAnchor),
            
            placeTitle.bottomAnchor.constraint(equalTo: placeDescription.topAnchor, constant: -4.0),
            placeTitle.topAnchor.constraint(equalTo: placePhoto.bottomAnchor, constant: 6.0),
            placeTitle.heightAnchor.constraint(equalToConstant: smallViewsHeightOrWidth),
            
            placeLocation.bottomAnchor.constraint(equalTo: placeTitle.bottomAnchor),
            placeLocation.topAnchor.constraint(equalTo: placePhoto.bottomAnchor, constant: 6.0),
            placeLocation.widthAnchor.constraint(equalToConstant: smallViewsHeightOrWidth),
            placeLocation.heightAnchor.constraint(equalToConstant: smallViewsHeightOrWidth),
            
            placeTitle.leadingAnchor.constraint(equalTo: placePhoto.leadingAnchor),
            
            placeLocation.trailingAnchor.constraint(equalTo: placePhoto.trailingAnchor),
            
            placeTitle.trailingAnchor.constraint(equalTo: placeLocation.leadingAnchor, constant: -4.0)
        ])
    }
    
}

extension PlaceDetailsViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) { //Rushed solution to always-on keyboard
        photoTopAnchor.constant = -210 + 64
        descriptionBottomAnchor.constant = -220
    }
}
