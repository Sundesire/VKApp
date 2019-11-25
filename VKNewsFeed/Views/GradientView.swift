//
//  GradientView.swift
//  VKNewsFeed
//
//  Created by Иван Бабушкин on 22.11.2019.
//  Copyright © 2019 Ivan Babushkin. All rights reserved.
//

import Foundation
import UIKit

class GradientView: UIView {
    
    @IBInspectable private var startColor: UIColor? {
        didSet {
            setupGradientColors()
        }
    }
    @IBInspectable private var endColor: UIColor? {
        didSet {
            setupGradientColors()
        }
    }
    
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = #colorLiteral(red: 0.4, green: 0.6235294118, blue: 0.831372549, alpha: 1)
        setupGradient()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    private func setupGradient() {
        self.layer.addSublayer(gradientLayer)
        setupGradientColors()
    }
    
    private func setupGradientColors() {
        if let startColor = startColor, let endColor = endColor {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        }
    }
}
