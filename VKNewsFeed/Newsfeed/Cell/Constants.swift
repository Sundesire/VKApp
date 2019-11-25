//
//  Constants.swift
//  VKNewsFeed
//
//  Created by Иван Бабушкин on 21.11.2019.
//  Copyright © 2019 Ivan Babushkin. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    static let cardInsets = UIEdgeInsets(top: 0, left: 8, bottom: 12, right: 8)
    static let topViewHeigh = CGFloat(36)
    static let postLabelInsets = UIEdgeInsets(top: 8 + Constants.topViewHeigh + 8, left: 8, bottom: 8, right: 8)
    static let postLabelFont = UIFont.systemFont(ofSize: 15)
    static let bottomViewHeight = CGFloat(44)
    
    static let bottomViewViewHeight = CGFloat(44)
    static let bottomViewViewWidth = CGFloat(80)
    
    static let bottomViewViewsIconSize = CGFloat(24)
    
    static let minifiedPostLimitLines = CGFloat(8)
    static let minifiedPostLines = CGFloat(4)
    
    static let moreTextButtonInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
    static let moreTextButtonSize = CGSize(width: 170, height: 30)
}
