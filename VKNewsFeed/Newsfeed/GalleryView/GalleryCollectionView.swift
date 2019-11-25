//
//  GalleryCollectionView.swift
//  VKNewsFeed
//
//  Created by Иван Бабушкин on 22.11.2019.
//  Copyright © 2019 Ivan Babushkin. All rights reserved.
//

import Foundation
import UIKit

class GalleryCollectionView: UICollectionView {
    
    var photos = [FeedCellPhotoAttachmentViewModel]()
    
    init() {
        let rowLayout = RowLayout()
        super.init(frame: .zero, collectionViewLayout: rowLayout)
        
        delegate = self
        dataSource = self
        
        backgroundColor = UIColor.white
        
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        
        register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: GalleryCollectionViewCell.reuseId)
        
        if let rowLayout = collectionViewLayout as? RowLayout {
            rowLayout.delegate = self
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(photos: [FeedCellPhotoAttachmentViewModel]) {
        self.photos = photos
        contentOffset = CGPoint.zero
        reloadData()
    }
    
}

extension GalleryCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: GalleryCollectionViewCell.reuseId, for: indexPath) as! GalleryCollectionViewCell
        cell.set(imageUrl: photos[indexPath.row].photoUrlString)
        return cell
    }
}

extension GalleryCollectionView: RowLayouDelegate {
    func collectionView(_ collectionView: UICollectionView, photoAtIndexPath indexPath: IndexPath) -> CGSize {
        let width = photos[indexPath.row].widht
        let height = photos[indexPath.row].height
        return CGSize(width: width, height: height)
    }
}
