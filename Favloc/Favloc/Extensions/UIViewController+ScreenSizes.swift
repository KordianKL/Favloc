//
//  UIViewController+ScreenSizes.swift
//  Favloc
//
//  Created by Kordian Ledzion on 12/01/2018.
//  Copyright © 2018 KordianLedzion. All rights reserved.
//

import UIKit

extension UIViewController {
    
    enum LayoutContext: Int {
        case iPhone3_5
        case iPhone4_0
        case iPhone4_7
        case iPhone5_5
        
        init(screenSize: CGSize) {
            let screenHeight = screenSize.height
            if screenHeight >= 736.0 {
                self = .iPhone5_5
            } else if screenHeight >= 667.0 {
                self = .iPhone4_7
            } else if screenHeight >= 568.0 {
                self = .iPhone4_0
            } else {
                self = .iPhone3_5
            }
        }
        
        static let `default` = LayoutContext(screenSize: UIScreen.main.bounds.size)
    }
    
    func layoutContextValue<T>(context: LayoutContext = .default, base: T, contextMapping: [LayoutContext: T]) -> T {
        return contextMapping[context] ?? base
    }
}
