//
//  UIViewController + Storyboard.swift
//  VKNewsFeed
//
//  Created by Иван Бабушкин on 18.11.2019.
//  Copyright © 2019 Ivan Babushkin. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    class func loadFromStoryboard<T: UIViewController>() -> T {
        let name = String(describing: T.self)
        let storyboard = UIStoryboard(name: name, bundle: nil)
        if let viewController = storyboard.instantiateInitialViewController() as? T {
            return viewController
        } else  {
            fatalError("Error: No initial view controller in \(name) stroyboard!")
        }
    }
}


//Execute below command in terminal : First goto projects root folder
//
// xattr -cr <path_to_project_dir>
//Clean Xcode and Re Build. Cheers
