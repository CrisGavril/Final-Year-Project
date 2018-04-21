//
//  CatalogueViewController.swift
//  FinalYearProject
//
//  Created by Cristina  on 14/04/2018.
//  Copyright © 2018 Cristina . All rights reserved.
//

import Foundation
import UIKit

enum ItemFilter {
    case all
    case favourites
}

class CatalogueViewController: UIViewController {
    let furnitureCellIdentifier = "FurnitureCell"
    @IBOutlet var tableView: UITableView?
    
    public var catalogue: Catalogue = Catalogue.sharedInstance {
        didSet {
            self.filteredItems = self.applyFilter(self.filter, to: self.catalogue.items)
        }
    }
    
    fileprivate var filter: ItemFilter = .all {
        didSet {
            self.filteredItems = self.applyFilter(self.filter, to: self.catalogue.items)
        }
    }
    
    fileprivate var filteredItems: [CatalogueItem] = [] {
        didSet {
            self.tableView?.reloadData()
        }
    }
    
    func applyFilter(_ filter: ItemFilter, to allItems: [CatalogueItem]) -> [CatalogueItem] {
        switch filter {
        case .all:
            return allItems
        case .favourites:
            return allItems.filter{ $0.isFavourite }
        }
    }
    
    private var observer: NSObjectProtocol? = nil
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView?.register(UITableViewCell.self, forCellReuseIdentifier: furnitureCellIdentifier)
        
        let block: (Notification) -> Void = { [weak self] _ in
            DispatchQueue.main.async {
                self?.catalogue = Catalogue.sharedInstance
            }
        }
        
        self.observer = NotificationCenter.default
            .addObserver(forName: Catalogue.updateNotification,
                         object: nil,
                         queue: nil,
                         using: block)
    }
    
    deinit {
        if let observer = self.observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showItemDetails",
            let itemDetailsVC = segue.destination as? ItemDetailsViewController,
            let item = sender as? CatalogueItem else {
                return
        }
        
        itemDetailsVC.item = item
        itemDetailsVC.itemIndex = self.catalogue.items.index(of: item)
    }
    
    @IBAction func filterChanged(segmentControl: UISegmentedControl){
        switch segmentControl.selectedSegmentIndex {
        case 0:
            self.filter = .all
        case 1:
            self.filter = .favourites
        default:
            return
        }
    }
}

extension CatalogueViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView
            .dequeueReusableCell(withIdentifier: furnitureCellIdentifier, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard self.filteredItems.count > indexPath.row else {
            return
        }
        let item = self.filteredItems[indexPath.row]
        
        cell.textLabel?.text = item.name
        cell.imageView?.image = item.image
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard self.filteredItems.count > indexPath.row else {
            return
        }
        let item = self.filteredItems[indexPath.row]
        self.performSegue(withIdentifier: "showItemDetails", sender: item)
    }
}
