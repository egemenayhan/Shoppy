//
//  PickerViewController.swift
//  Shoppy
//
//  Created by EGEMEN AYHAN on 29.09.2018.
//  Copyright © 2018 Egemen Ayhan. All rights reserved.
//

import UIKit
import Networking

// MARK: - PickerViewControllerDelegate
protocol PickerViewControllerDelegate {
    func didSelect(product: AvailableProduct)
}

// MARK: - PickerViewController
class PickerViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    // MARK: - Properties
    enum Section: Int {
        case color
        case size
    }
    
    var delegate: PickerViewControllerDelegate?
    private(set) var products: [AvailableProduct] = []
    private(set) var colors: [String] = []
    private(set) var sizeMap: [String: [String]] = [:]
    private(set) var sizes: [String] = []
    private(set) var selectedProduct: AvailableProduct!
    private var selectedColor: String!
    private var selectedSize: String!
    private var attributeCount = 0
    
    // MARK: - Lifecycle
    static func instantiate(products: [AvailableProduct], attributeCount: Int, selectedProduct: AvailableProduct) -> PickerViewController {
        let viewController = PickerViewController(nibName: String(describing: PickerViewController.self), bundle: nil)
        
        viewController.products = products
        viewController.selectedProduct = selectedProduct
        viewController.attributeCount = attributeCount
        
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.3) {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        }
    }

    // MARK: - IBAction
    @IBAction func doneTapped(_ sender: Any) {
        let result = products.filter { (product) -> Bool in
            return product.size == selectedSize && product.color == selectedColor
        }
        if let product = result.first {
            delegate?.didSelect(product: product)
            dismiss(animated: true, completion: nil)
        }
    }
    
}

// MARK: - Private extension
private extension PickerViewController {
    
    func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0)
        containerView.layer.cornerRadius = 10.0
        
        selectedColor = selectedProduct.color
        selectedSize = selectedProduct.size
        prepareOptions()
        
        // Select current size and color
        if attributeCount > 1 {
            if let index = colors.firstIndex(of: selectedColor) {
                pickerView.selectRow(index, inComponent: Section.color.rawValue, animated: false)
                
                let sizes = sizeMap[selectedColor]
                if let index = sizes?.firstIndex(of: selectedSize) {
                    pickerView.selectRow(index, inComponent: Section.size.rawValue, animated: false)
                }
            }
        } else {
            if let index = sizes.firstIndex(of: selectedSize) {
                pickerView.selectRow(index, inComponent: 0, animated: false)
            }
        }
        
        pickerView.reloadAllComponents()
    }
    
    func prepareOptions() {
        if attributeCount > 1 {
            let colorArray = products.compactMap({ (product) -> String? in
                return product.color
            })
            if colorArray.count > 1 {
                // Removing duplicate values
                colors = Array(Set(colorArray))
            }
            // Mapping sizes and colors
            for color in colors {
                sizeMap[color] = availableSizes(for: color)
            }
        } else {
            sizes = products.compactMap({ (product) -> String? in
                return product.size
            })
        }
    }
    
    func availableSizes(for color: String) -> [String] {
        let sizes = products.filter({ (product) -> Bool in
            return product.color == color
        }).compactMap({ (product) -> String? in
            return product.size
        })
        
        return sizes
    }
    
}

// MARK: - UIPickerViewDataSource
extension PickerViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return attributeCount
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if attributeCount == 1 {
            return sizes.count
        } else {
            guard let section = Section(rawValue: component) else { return 0 }
            switch section {
            case .color:
                return colors.count
            case .size:
                guard let color = selectedColor else {
                    return 0
                }
                if let sizes = sizeMap[color] {
                    return sizes.count
                }
                return 0
            }
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if attributeCount == 1 {
            return sizes[row]
        } else {
            guard let section = Section(rawValue: component) else { return nil }
            switch section {
            case .color:
                return colors[row]
            case .size:
                guard let color = selectedColor else {
                    return nil
                }
                let sizes = sizeMap[color]
                return sizes?[row]
            }
        }
    }
    
}

// MARK: - UIPickerViewDelegate
extension PickerViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if attributeCount > 1, component == Section.color.rawValue {
            selectedColor = self.pickerView(pickerView, titleForRow: row, forComponent: component)
            selectedSize = self.pickerView(pickerView, titleForRow: 0, forComponent: Section.size.rawValue)
            pickerView.selectRow(0, inComponent: Section.size.rawValue, animated: true)
            pickerView.reloadComponent(1)
        } else {
            selectedSize = self.pickerView(pickerView, titleForRow: row, forComponent: component)
        }
    }
    
}
