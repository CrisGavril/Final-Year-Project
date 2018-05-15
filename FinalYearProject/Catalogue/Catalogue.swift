//
//  Catalogue.swift
//  FinalYearProject
//
//  Created by Cristina  on 31/03/2018.
//  Copyright © 2018 Cristina . All rights reserved.
//

import Foundation

struct Catalogue: Codable {
    static let updateNotification: NSNotification.Name = NSNotification.Name(rawValue: "CatalogueDidUpdate")
    
    private static let userDefaultsKey = "catalogueUserDefaultsKey"
    private static let catalogueVersionKey = "catalogueVersionKey"
    private static let currentCatalogueVersion = 3
    
    public private(set) var items: [CatalogueItem]
    
    private init(items: [CatalogueItem]) {
        self.items = items
    }
    
    private static func generateItemName(forIndex index: Int) -> String {
        let namePrefix: String
        // These are random product names from Ikea.
        // We need something that will be different from the item type to test the search functionality.
        switch index % 3 {
        case 0:
            namePrefix = "Henriksdal"
        case 1:
            namePrefix = "Ekedalen"
        default:
            namePrefix = "Odger"
        }
        // We use this number formatter to generate spelled-out numbers that
        // should generate nice names for our test products
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .spellOut
        let nameSuffix = numberFormatter.string(from: NSNumber(value: index)) ?? ""
        return "\(namePrefix) \(nameSuffix)"
    }
    
    private static func generateItem(forIndex index: Int) -> CatalogueItem {
        // App currently only supports boxes and sphere
        let type: ItemType
        let imageName: String?
        switch index % 3 {
        case 0:
            type = ItemType.box
            imageName = nil
        case 1:
            type = ItemType.sphere
            imageName = nil
        case 2:
            fallthrough
        default:
            type = ItemType.flower
            imageName = "Flower_item"
        }
        return CatalogueItem(type: type,
                             name: Catalogue.generateItemName(forIndex: index),
                             imageName:imageName)
    }
    
    
    private static func shouldUsePersistedCatalogue() -> Bool {
        // The currentCatalogueVersion should be updated every time the Catalogue data structure changes
        return UserDefaults.standard.integer(forKey: Catalogue.catalogueVersionKey) == Catalogue.currentCatalogueVersion
    }
    
    public static var sharedInstance: Catalogue = {
        if Catalogue.shouldUsePersistedCatalogue(),
            let data = UserDefaults.standard.data(forKey: Catalogue.userDefaultsKey) {
            let decoded = try! PropertyListDecoder().decode(Catalogue.self, from: data)
            return decoded
        } else {
            // We should have data migration here in future versions
            // Presently the "data migration" consists of
            // discarding the incompatible data and generate a new version of the Catalogue
            let items:[CatalogueItem] = (1...100).map { Catalogue.generateItem(forIndex: $0) }
            return Catalogue(items: items)
        }
    }()
    
    public mutating func updateItem(_ item: CatalogueItem, at index: Int) {
        guard index < self.items.count else {
            return
        }
        self.items[index] = item
        
        let data = try! PropertyListEncoder().encode(self)
        
        UserDefaults.standard.set(data,
                                  forKey: Catalogue.userDefaultsKey)
        UserDefaults.standard.set(Catalogue.currentCatalogueVersion,
                                  forKey: Catalogue.catalogueVersionKey)
        NotificationCenter.default.post(name: Catalogue.updateNotification,
                                        object: nil,
                                        userInfo: nil)
    }
}
