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
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var toggleFavouriteButton: UIButton?
    @IBAction func toggleFavourite() {
        self.item.isFavourite = !self.item.isFavourite
        Catalogue.sharedInstance.updateItem(self.item, at: self.itemIndex)
    }
    
    public var itemIndex: Int! = nil
    private func updateFavouriteButton() {
        if item.isFavourite {
            self.toggleFavouriteButton?.setTitle("Remove from favourites", for: .normal)
        } else {
            self.toggleFavouriteButton?.setTitle("Add to favourites", for: .normal)
        }
    }
    
    public var item: CatalogueItem! = nil {
        didSet {
            updateFavouriteButton()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.item.name
        self.imageView.image = self.item.image
        self.updateFavouriteButton()
    }
}

