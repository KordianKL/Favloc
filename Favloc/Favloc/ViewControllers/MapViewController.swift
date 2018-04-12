//
//  MapViewController.swift
//  Favloc
//
//  Created by Kordian Ledzion on 14/01/2018.
//  Copyright © 2018 KordianLedzion. All rights reserved.
//

import Foundation
import MapKit

class MapViewController: UIViewController {
    
    weak var coordinator: MainCoordinator?
    
    private var longPressGesture: UILongPressGestureRecognizer!
    private let map = MKMapView()
    private let dismissCompletion: ((Double, Double)) -> Void
    
    init(with dismissCompletion: @escaping ((Double, Double)) -> Void) {
        self.dismissCompletion = dismissCompletion
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBar()
        setUpMapView()
        setUpGestureRecognizers()
    }
    
    private func setUpMapView() {
        map.showsPointsOfInterest = false
        
        map.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(map)
        NSLayoutConstraint.activate([
            map.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            map.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            map.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            map.topAnchor.constraint(equalTo: view.topAnchor)
            ])
    }
    
    private func setUpNavBar() {
        navigationItem.title = "Long press location"
    }
    
    private func setUpGestureRecognizers() {
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture(sender:)))
        map.addGestureRecognizer(longPressGesture)
    }
    
    @objc private func handleLongGesture(sender: UILongPressGestureRecognizer) {
        if sender.state != UIGestureRecognizerState.began { return }
        let touchLocation = sender.location(in: map)
        let locationCoordinate = map.convert(touchLocation, toCoordinateFrom: map)
        dismissCompletion((locationCoordinate.latitude, locationCoordinate.longitude))
        navigationController?.popViewController(animated: true)
    }
}
