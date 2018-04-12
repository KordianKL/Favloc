//
//  MainCoordinator.swift
//  Favloc
//
//  Created by Kordian Ledzion on 13/01/2018.
//  Copyright © 2018 KordianLedzion. All rights reserved.
//

import UIKit

class MainCoordinator: Coordinator {
    
    var rootViewController: UIViewController {
        return navigationController
    }
    
    private var navigationController: UINavigationController
    private let viewModel: DataSource
    
    init(viewModel: DataSource) {
        self.viewModel = viewModel
        let mainCollectionViewController = MainCollectionViewController(viewModel: viewModel)
        self.navigationController = UINavigationController(rootViewController: mainCollectionViewController)
        mainCollectionViewController.coordinator = self
    }
    
    func presentDetails(for place: Place, _ completion: @escaping () -> Void) {
        let viewController = PlaceDetailsViewController(place: place, viewModel: viewModel, completion)
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func presentLocationPicker(with dismissCompletion: @escaping (Double,Double) -> Void) {
        let viewController = MapViewController(with: dismissCompletion)
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func presentPhotoCapture(with dismissCompletion: @escaping (Data) -> Void) {
        let viewController = CapturePhotoViewController(dismissCompletion: dismissCompletion)
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
}
