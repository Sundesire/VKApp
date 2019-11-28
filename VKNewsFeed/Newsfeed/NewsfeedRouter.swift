//
//  NewsfeedRouter.swift
//  VKNewsFeed
//
//  Created by Иван Бабушкин on 19.11.2019.
//  Copyright (c) 2019 Ivan Babushkin. All rights reserved.
//

import UIKit

protocol NewsfeedRoutingLogic {
    func routeToSettings()
    func navigateToSettings()
}

class NewsfeedRouter: NSObject, NewsfeedRoutingLogic {
    
  weak var viewController: NewsfeedViewController?
  
  // MARK: Routing
    
    func routeToSettings() {
        let pushedVC = SettingsViewController()
        viewController?.present(pushedVC, animated: true, completion: nil)
    }
    
//    func navigateToSettings(source: NewsfeedViewController, destination: SettingsViewController) {
//        source.navigationController?.pushViewController(destination, animated: true)
//    }
    
    func navigateToSettings() {
        viewController?.performSegue(withIdentifier: "toSettings", sender: self)
    }
  
}
