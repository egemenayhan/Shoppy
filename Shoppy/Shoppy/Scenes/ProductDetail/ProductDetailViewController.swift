
//
//  ProductDetailViewController.swift
//  Shoppy
//
//  Created by EGEMEN AYHAN on 9.09.2018.
//  Copyright © 2018 Egemen Ayhan. All rights reserved.
//

import UIKit
import Networking

class ProductDetailViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var designerLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var minPriceLabel: UILabel!
    @IBOutlet private weak var amberLabel: UILabel!
    @IBOutlet private weak var optionsStackView: UIStackView!
    @IBOutlet private weak var blockerView: UIView!
    @IBOutlet private weak var galleryView: GalleryView!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    // MARK: - Properties
    private static let identifier = String(describing: ProductDetailViewController.self)
    private(set) var viewModel: ProductDetailViewModel!
    private var colorOptionsView: ConfigurableAttributeView?
    private var sizeOptionsView: ConfigurableAttributeView?
    
    // MARK: - Lifecycle
    class func instantiate(model: ProductDetailViewModel) -> ProductDetailViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: ProductDetailViewController.identifier) as! ProductDetailViewController
        
        controller.viewModel = model
        
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
        setupUI()
    }
    
    // MARK - IBActions
    @IBAction func addToBagTapped(_ sender: Any) {
        if viewModel.state.selectedAvailableProduct == nil, viewModel.state.product.configurableAttributes.count > 0 {
            let alert = UIAlertController(title: "WARNING", message: "Please select an available product.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default) { [weak self] (action) in
                guard let strongSelf = self else { return }
                strongSelf.dismiss(animated: true, completion: nil)
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            return
        }
        
        let productSku = viewModel.state.selectedAvailableProduct?.productSku ?? viewModel.state.product.sku
        let size = viewModel.state.product.size
        let color = viewModel.state.product.color
        
        let alert = UIAlertController(title: "ITEM ADDED TO BAG", message: "SKU: \(productSku), SIZE: \(size), COLOR: \(color)", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { [weak self] (action) in
            guard let strongSelf = self else { return }
            strongSelf.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        coordinator.animate(alongsideTransition: { (_) in
            self.galleryView.updateUI()
        }, completion: { (_) in
            self.view.layoutSubviews()
        })
    }
    
}

// MARK: - Private extension
private extension ProductDetailViewController {
    
    func setupViewModel() {
        viewModel.stateChangeHandler = handleStateChange
        viewModel.errorHandler = handleError
    }
    
    func setupUI() {
        prepareConfigurableAttributes()
        blockerView.isHidden = true
        populateUI()
    }
    
    func populateUI() {
        optionsStackView.isHidden = viewModel.state.product.configurableAttributes.count == 0
        galleryView.medias = viewModel.state.product.medias
        designerLabel.text = viewModel.state.product.designerName
        nameLabel.text = viewModel.state.product.name
        let points = viewModel.state.product.points
        amberLabel.text = String(format: "Earn %.f Amber Points", points)
        displayPrice()
        scrollView.setContentOffset(.zero, animated: true)
    }
    
    func displayPrice() {
        let regular = viewModel.state.product.price
        let min = viewModel.state.product.minPrice
        
        minPriceLabel.isHidden = regular == min
        
        let formattedRegular = String(format: "%.f AED", regular)
        if regular != min {
            priceLabel.attributedText = NSAttributedString(string: formattedRegular, attributes: [NSAttributedString.Key.strikethroughStyle: 2])
            minPriceLabel.text = String(format: "%.f AED", min)
        } else {
            priceLabel.text = formattedRegular
        }
    }
    
    func prepareConfigurableAttributes() {
        for attribute: ConfigurableAttribute in viewModel.state.product.configurableAttributes {
            let view = ConfigurableAttributeView.instantiate(for: attribute)
            view.delegate = self
            
            switch attribute.type {
            case .color:
                view.selectedOption = viewModel.state.selectedAvailableProduct?.color
                colorOptionsView = view
            case .size:
                view.selectedOption = viewModel.state.selectedAvailableProduct?.size
                sizeOptionsView = view
            case .unknown:
                break
            }
            
            optionsStackView.addArrangedSubview(view)
        }
    }
    
    // MARK: - Change handler
    func handleStateChange(change: ProductDetailState.Change) {
        switch change {
        case .productUpdated:
            populateUI()
        case .selectedproductChanged:
            colorOptionsView?.selectedOption = viewModel.state.selectedAvailableProduct?.color
            sizeOptionsView?.selectedOption = viewModel.state.selectedAvailableProduct?.size
        case .showLoader(let show):
            blockerView.isHidden = !show
        }
    }
    
    // MARK: - Error handler
    func handleError(error: ProductDetailState.Error) {
        // TODO: handle error
    }
    
}

// MARK: - ConfigurableAttributeDelegate
extension ProductDetailViewController: ConfigurableAttributeDelegate {
    
    func didTap(attributeView: ConfigurableAttributeView) {
        let vc = PickerViewController.instantiate(products: viewModel.state.availableProducts,
                                                  attributeCount: viewModel.state.product.configurableAttributes.count,
                                                  selectedProduct: viewModel.state.selectedAvailableProduct!)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
}

// MARK: - PickerViewControllerDelegate
extension ProductDetailViewController: PickerViewControllerDelegate {
    
    func didSelect(product: AvailableProduct) {
        viewModel.load(product: product)
    }
    
}
