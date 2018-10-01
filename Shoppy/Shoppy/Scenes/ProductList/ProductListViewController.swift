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
    @IBOutlet weak var activityBackgroundView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    private let model = ProductListViewModel()
    private var refreshControl = UIRefreshControl()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewModel()
        setupUI()
        
        model.reloadProducts()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        view.layoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }

}

// MARK: - Private extension
private extension ProductListViewController {
    
    enum Const {
        static let padding = 10
        static let numberOfCellOnPortrait = 2
        static let numberOfCellOnLandscape = 3
        static let cellRatio: CGFloat = 1.8 // height / width
        static let activityCellHeight: CGFloat = 40.0
    }
    
    func setupUI() {
        refreshControl.tintColor = .orange
        refreshControl.addTarget(self, action: #selector(reloadProducts), for: .valueChanged)
        collectionView.addSubview(refreshControl)
        
        activityBackgroundView.alpha = 0
        activityBackgroundView.layer.cornerRadius = activityBackgroundView.frame.width / 2
        activityBackgroundView.layer.masksToBounds = true
        activityBackgroundView.layer.borderWidth = 3
        activityBackgroundView.layer.borderColor = UIColor.red.cgColor
        
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
                UIView.animate(withDuration: 0.3) { [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.activityBackgroundView.alpha = 0
                }
            }
        case .showLoading:
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.activityBackgroundView.alpha = 1
            }
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
        var numberOfCell = Const.numberOfCellOnPortrait
        if UIDevice.current.orientation.isLandscape {
            numberOfCell = Const.numberOfCellOnLandscape
        }
        
        var width = view.frame.size.width
        if #available(iOS 11.0, *) {
            let guide = self.view.safeAreaLayoutGuide
            width = guide.layoutFrame.size.width
        }
        
        let paddingBetweenCells = (numberOfCell - 1) * Const.padding
        let totalPadding = paddingBetweenCells + (Const.padding * 2) // Cell space + Edge insets
        let dimension = (width - CGFloat(totalPadding)) / CGFloat(numberOfCell)
        
        return CGSize(width: dimension, height: dimension * Const.cellRatio)
    }
    
}

// MARK: - UICollectionViewDelegate
extension ProductListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = model.state.products[indexPath.row]
        let viewModel = ProductDetailViewModel(product: product)
        let detailViewController = ProductDetailViewController.instantiate(model: viewModel)
        
        show(detailViewController, sender: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row > model.state.products.count - 6 {
            model.fetchNextPage()
        }
    }
    
}
