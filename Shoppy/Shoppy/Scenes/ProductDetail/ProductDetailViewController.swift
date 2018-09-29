
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

        setupUI()
    }

    // MARK - IBActions
    @IBAction func addToBagTapped(_ sender: Any) {
        // TODO: add to bag operation
    }
    
}

// MARK: - Private extension
private extension ProductDetailViewController {
    
    func setupUI() {
        prepareConfigurableAttributes()
        
        populateUI()
    }
    
    func populateUI() {
        designerLabel.text = viewModel.state.product.designerName
        nameLabel.text = viewModel.state.product.name
        priceLabel.text = "\(viewModel.state.product.price)"
    }
    
    func prepareConfigurableAttributes() {
        for attribute: ConfigurableAttribute in viewModel.state.product.configurableAttributes {
            let view = ConfigurableAttributeView.instantiate(for: attribute)
            view.delegate = self
            
            switch attribute.type {
            case .color:
                view.selectedOption = viewModel.state.selectedAvailableProduct.color
            case .size:
                view.selectedOption = viewModel.state.selectedAvailableProduct.size
            case .unknown:
                break
            }
            
            optionsStackView.addArrangedSubview(view)
        }
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
        // TODO: send to model
    }
    
}
