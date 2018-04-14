//
//  ItemDetailsViewController.swift
//  FinalYearProject
//
//  Created by Cristina  on 14/04/2018.
//  Copyright © 2018 Cristina . All rights reserved.
//

import Foundation
import UIKit

class ItemDetailsViewController: UIViewController {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    public var item: CatalogueItem! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameLabel.text = self.item.name
        self.imageView.image = self.item.image
    }
}

