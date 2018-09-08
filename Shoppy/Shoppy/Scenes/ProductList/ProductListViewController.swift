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
    private var refreshControl = UIRefreshControl()
    private var showActivity = false
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewModel()
        setupUI()
        
        model.reloadProducts()
    }

}

// MARK: - Private extension
private extension ProductListViewController {
    
    enum Const {
        static let padding = 10
        static let numberOfCellOnPortrait = 2
        static let cellRatio: CGFloat = 1.8 // height / width
        static let activityCellHeight: CGFloat = 40.0
    }
    
    enum Section: Int {
        static let sectionCount = 1
        
        case products
        case activity
    }
    
    func setupUI() {
        refreshControl.tintColor = .orange
        refreshControl.addTarget(self, action: #selector(reloadProducts), for: .valueChanged)
        collectionView.addSubview(refreshControl)
    }
    
    func setupViewModel() {
        model.stateChangeHandler = handleStateChange
        model.errorHandler = handleError
    }
    
    func handleStateChange(change: ProductListState.Change) {
        switch change {
        case .productsReloaded:
            collectionView.reloadData()
        case .newProductsAdded(let indexPaths):
            collectionView.performBatchUpdates({
                collectionView.insertItems(at: indexPaths)
            }) { (_) in
                return
            }
        case .showLoading(let shouldShow):
            showActivity = shouldShow
            //collectionView.reloadSections(IndexSet(integer: Section.activity.rawValue))
        }
    }
    
    func handleError(error: ProductListState.Error) {
        // TODO: handle error
    }
    
    @objc func reloadProducts() {
        model.reloadProducts()
        refreshControl.endRefreshing()
    }
    
}

// MARK: - UICollectionViewDataSource
extension ProductListViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.sectionCount
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else { fatalError("Invalid Section!") }
        switch section {
        case .products:
            return model.state.products.count
        case .activity:
            return showActivity ? 1 : 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = Section(rawValue: indexPath.section) else { fatalError("Invalid Section!") }
        switch section {
        case .products:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identifier, for: indexPath) as! ProductCollectionViewCell
            
            let product = model.state.products[indexPath.row]
            cell.configure(with: product)
            
            return cell
        case .activity:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "activityCell", for: indexPath)
            
            return cell
        }
        
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ProductListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let section = Section(rawValue: indexPath.section) else { fatalError("Invalid Section!") }
        switch section {
        case .products:
            let paddingBetweenCells = (Const.numberOfCellOnPortrait - 1) * Const.padding
            let totalPadding = paddingBetweenCells + (Const.padding * 2) // Cell space + Edge insets
            let dimension = (UIScreen.main.bounds.width - CGFloat(totalPadding)) / CGFloat(Const.numberOfCellOnPortrait)
            
            return CGSize(width: dimension, height: dimension * Const.cellRatio)
        case .activity:
            return CGSize(width: UIScreen.main.bounds.width, height: Const.activityCellHeight)
        }
    }
    
}

// MARK: - UICollectionViewDelegate
extension ProductListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: route to detail
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section) else { fatalError("Invalid Section!") }
        switch section {
        case .products:
            if indexPath.row > model.state.products.count - 6 {
                model.fetchNextPage()
            }
        default:
            return
        }
    }
    
}
