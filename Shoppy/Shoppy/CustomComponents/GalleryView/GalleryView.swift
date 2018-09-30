//
//  GalleryView
//  Shoppy
//
//  Created by EGEMEN AYHAN on 30.09.2018.
//  Copyright © 2018 Egemen Ayhan. All rights reserved.
//

import UIKit
import Networking

class GalleryView: UIView {

    // MARK: - Properties
    var medias: [Media] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    private var collectionView: UICollectionView!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(GalleryCollectionViewCell.self,
                                forCellWithReuseIdentifier: String(describing: GalleryCollectionViewCell.self))
        addSubview(collectionView)
        
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }

}

// MARK: - UICollectionViewDataSource
extension GalleryView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return medias.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  String(describing: GalleryCollectionViewCell.self),
                                                      for: indexPath) as! GalleryCollectionViewCell
        
        cell.configure(with: medias[indexPath.row])
        cell.backgroundColor = .orange
        
        return cell
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension GalleryView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return frame.size
    }
    
}
