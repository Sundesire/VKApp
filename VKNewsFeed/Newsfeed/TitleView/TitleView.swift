//
//  TitleView.swift
//  VKNewsFeed
//
//  Created by Иван Бабушкин on 22.11.2019.
//  Copyright © 2019 Ivan Babushkin. All rights reserved.
//

import Foundation
import UIKit

protocol TitleViewViewModel {
    var photoUrlString: String? { get }
}

protocol TitleViewViewModelDelegate: class {
    func segueToSettings()
}

class TitleView: UIView {
    
    weak var delegate: TitleViewViewModelDelegate?
    
    private var myButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        return button
    }()
    
    private var myAvatarView: WebImageView = {
        let imageView = WebImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .orange
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private var myTextField = InsetableTextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        myButton.addTarget(self, action: #selector(performSegue), for: .touchUpInside)
        
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(myTextField)
        addSubview(myButton)
        myButton.addSubview(myAvatarView)
        makeConstraints()
    }
    
    @objc func performSegue() {
        delegate?.segueToSettings()
    }
    
    func set(userViewModel: TitleViewViewModel) {
        myAvatarView.set(imageURL: userViewModel.photoUrlString)
    }
    
    private func makeConstraints() {
        
        myAvatarView.anchor(top: myButton.topAnchor, leading: myButton.leadingAnchor, bottom: myButton.bottomAnchor, trailing: myButton.trailingAnchor)
        myAvatarView.heightAnchor.constraint(equalTo: myTextField.heightAnchor, multiplier: 1).isActive = true
        myAvatarView.widthAnchor.constraint(equalTo: myTextField.heightAnchor, multiplier: 1).isActive = true
        
        myButton.anchor(top: topAnchor,
                                   leading: nil,
                                   bottom: nil,
                                   trailing: trailingAnchor,
                                   padding: UIEdgeInsets.init(top: 4, left: 777, bottom: 777, right: 4))
               
        myButton.heightAnchor.constraint(equalTo: myTextField.heightAnchor, multiplier: 1).isActive = true
        myButton.widthAnchor.constraint(equalTo: myTextField.heightAnchor, multiplier: 1).isActive = true
        
        
        
        myTextField.anchor(top: topAnchor,
                           leading: leadingAnchor,
                           bottom: bottomAnchor,
                           trailing: myButton.leadingAnchor,
                           padding: UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 12))
    }
    
    override var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        myButton.layer.masksToBounds = true
        myButton.layer.cornerRadius = myButton.frame.width / 2
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
