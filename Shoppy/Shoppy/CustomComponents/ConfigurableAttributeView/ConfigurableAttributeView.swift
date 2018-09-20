//
//  ConfigurableAttributeView.swift
//  Shoppy
//
//  Created by EGEMEN AYHAN on 19.09.2018.
//  Copyright © 2018 Egemen Ayhan. All rights reserved.
//

import UIKit
import Networking

// MARK: - ConfigurableAttributeDelegate
protocol ConfigurableAttributeDelegate {
    
    func didTap(attributeView: ConfigurableAttributeView)

}

// MARK: - ConfigurableAttributeView
class ConfigurableAttributeView: UIView {

    // MARK: - Outlets
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    // MARK: - Properties
    private(set) var configurableAttribute: ConfigurableAttribute! {
        didSet {
            setupUI()
        }
    }
    var selectedOption: ConfigurableAttributeOption? {
        didSet {
            updateUI()
        }
    }
    var delegate: ConfigurableAttributeDelegate?
    
    // MARK: - Lifecycle
    static func instantiate(for attribute: ConfigurableAttribute) -> ConfigurableAttributeView {
        guard let view = UINib(nibName: String(describing: ConfigurableAttributeView.self), bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? ConfigurableAttributeView else {
            fatalError("Can not find nib for class: " + String(describing: ConfigurableAttributeView.self))
        }
        view.configurableAttribute = attribute
        
        return view
    }

}

// MARK: - Private extension
private extension ConfigurableAttributeView {
    
    func setupUI() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(attributeTapped))
        self.addGestureRecognizer(gestureRecognizer)
        
        updateUI()
    }
    
    func updateUI() {
        typeLabel.text = configurableAttribute.title
        valueLabel.text = selectedOption?.title ?? "Select \(configurableAttribute.title)"
    }
    
    @objc func attributeTapped() {
        delegate?.didTap(attributeView: self)
    }
    
}
