 //
//  AppDelegate.swift
//  Favloc
//
//  Created by Kordian Ledzion on 03/01/2018.
//  Copyright © 2018 KordianLedzion. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let mainCoordinator = MainCoordinator(viewModel: MainCollectionViewModel(persistentContainerName: "Favloc"))
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setupNavigationBar()
        window = UIWindow()
        window?.rootViewController = mainCoordinator.rootViewController
        window?.makeKeyAndVisible()
        return true
    }
    
    private func setupNavigationBar() {
        UIApplication.shared.isStatusBarHidden = false
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().titleTextAttributes = [
            .font: UIFont.appMediumFont(ofSize: 14),
            .kern: 3.4
        ]
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().barTintColor = .white
        UINavigationBar.appearance().tintColor = .charcoalGrey
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
    }

}
