//
//  ProductListViewController.swift
//  Shoppy
//
//  Created by EGEMEN AYHAN on 7.09.2018.
//  Copyright © 2018 Egemen Ayhan. All rights reserved.
//

import UIKit

class ProductListViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    private let model = ProductListViewModel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewModel()
        model.reloadProducts()
    }

}

// MARK: - Private extension
private extension ProductListViewController {
    
    enum Const {
        static let padding = 10
        static let numberOfCellOnPortrait = 2
        static let cellRatio: CGFloat = 1.7 // height / width
    }
    
    func setupViewModel() {
        model.stateChangeHandler = handleStateChange
        model.errorHandler = handleError
    }
    
    func handleStateChange(change: ProductListState.Change) {
        switch change {
        case .productsUpdated:
            collectionView.reloadData()
        }
    }
    
    func handleError(error: ProductListState.Error) {
        // TODO: handle error
    }
    
}

// MARK: - UICollectionViewDataSource
extension ProductListViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.state.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identifier, for: indexPath) as! ProductCollectionViewCell
        
        let product = model.state.products[indexPath.row]
        cell.configure(with: product)
        
        return cell
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ProductListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingBetweenCells = (Const.numberOfCellOnPortrait - 1) * Const.padding
        let totalPadding = paddingBetweenCells + (Const.padding * 2) // Cell space + Edge insets
        let dimension = (UIScreen.main.bounds.width - CGFloat(totalPadding)) / CGFloat(Const.numberOfCellOnPortrait)
        
        return CGSize(width: dimension, height: dimension * Const.cellRatio)
    }
    
}

// MARK: - UICollectionViewDelegate
extension ProductListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: route to detail
    }
    
}
