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
        self.navigationController?.delegate = self
    }
    
}

extension CatalogueViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let cameraVC = viewController as? CameraViewController {
            cameraVC.catalogue = self.catalogue
        }
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
        if let currentItemIndex = self.catalogue.currentItemIndex,
            currentItemIndex == indexPath.row {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard self.catalogue.items.count > indexPath.row else {
            return
        }
        self.catalogue.currentItemIndex = indexPath.row
        tableView.reloadData()
    }
}
