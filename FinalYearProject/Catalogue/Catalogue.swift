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
    
    public private(set) var items: [CatalogueItem]
    
    private init(items: [CatalogueItem]) {
        self.items = items
    }
    
    public static var sharedInstance: Catalogue = {
        if let data = UserDefaults.standard.data(forKey: Catalogue.userDefaultsKey) {
            let decoded = try! PropertyListDecoder().decode(Catalogue.self, from: data)
            return decoded
        } else {
            return Catalogue(items: [
                CatalogueItem(type: .box),
                CatalogueItem(type: .sphere)
                ])
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
        
        NotificationCenter.default.post(name: Catalogue.updateNotification,
                                        object: nil,
                                        userInfo: nil)
    }
}
