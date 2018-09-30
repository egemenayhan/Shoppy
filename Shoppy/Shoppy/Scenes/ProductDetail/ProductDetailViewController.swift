
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
        // TODO: add to bag operation
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
        galleryView.medias = viewModel.state.product.medias
        designerLabel.text = viewModel.state.product.designerName
        nameLabel.text = viewModel.state.product.name
        priceLabel.text = "\(viewModel.state.product.price)"
        scrollView.setContentOffset(.zero, animated: true)
    }
    
    func prepareConfigurableAttributes() {
        for attribute: ConfigurableAttribute in viewModel.state.product.configurableAttributes {
            let view = ConfigurableAttributeView.instantiate(for: attribute)
            view.delegate = self
            
            switch attribute.type {
            case .color:
                view.selectedOption = viewModel.state.selectedAvailableProduct.color
                colorOptionsView = view
            case .size:
                view.selectedOption = viewModel.state.selectedAvailableProduct.size
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
            colorOptionsView?.selectedOption = viewModel.state.selectedAvailableProduct.color
            sizeOptionsView?.selectedOption = viewModel.state.selectedAvailableProduct.size
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
                                                  selectedProduct: viewModel.state.selectedAvailableProduct)
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
