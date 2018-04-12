//
//  UIViewController+Back.swift
//  Favloc
//
//  Created by Kordian Ledzion on 12/01/2018.
//  Copyright © 2018 KordianLedzion. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func setupBackButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "<",
            style: .plain,
            target: navigationController,
            action: #selector(navigationController?.popViewController(animated:)))
    }
}
