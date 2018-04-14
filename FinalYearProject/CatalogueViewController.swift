//
//  CatalogueViewController.swift
//  FinalYearProject
//
//  Created by Cristina  on 14/04/2018.
//  Copyright © 2018 Cristina . All rights reserved.
//

import Foundation
import UIKit

class CatalogueViewController: UIViewController {
    let furnitureCellIdentifier = "FurnitureCell"
    @IBOutlet var tableView: UITableView!
    
    public var catalogue: Catalogue!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: furnitureCellIdentifier)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showItemDetails",
            let itemDetailsVC = segue.destination as? ItemDetailsViewController,
            let item = sender as? CatalogueItem else {
                return
        }
        
        itemDetailsVC.item = item
    }
}

extension CatalogueViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.catalogue.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: furnitureCellIdentifier, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard self.catalogue.items.count > indexPath.row else {
            return
        }
        let item = self.catalogue.items[indexPath.row]
        
        cell.textLabel?.text = item.name
        cell.imageView?.image = item.image
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard self.catalogue.items.count > indexPath.row else {
            return
        }
        let item = self.catalogue.items[indexPath.row]
        self.performSegue(withIdentifier: "showItemDetails", sender: item)
    }
}
