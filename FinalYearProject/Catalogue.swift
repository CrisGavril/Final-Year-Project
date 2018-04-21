//
//  Catalogue.swift
//  FinalYearProject
//
//  Created by Cristina  on 31/03/2018.
//  Copyright © 2018 Cristina . All rights reserved.
//

import Foundation
import SceneKit

enum ItemType: String, Codable {
    case box
    case sphere
    case table
    case chair
    
    public var name: String {
        get {
            switch self {
            case .box:
                return "Box"
            case .sphere:
                return "Sphere"
            case .table:
                return "Table"
            case .chair:
                return "Chair"
            }
        }
    }
}

struct CatalogueItem: Equatable, Codable {
    private static let kBoxSide: CGFloat = 0.5 //meters
    private static let kSphereRadius: CGFloat = 0.25 //meters
    
    let type: ItemType
    var isFavourite: Bool
    public let name: String
    private let imageName: String?
    
    init(type: ItemType,
         name: String? = nil,
         isFavourite: Bool = false,
         imageName: String? = nil) {
        self.type = type
        self.name = name ?? type.name
        self.isFavourite = isFavourite
        self.imageName = imageName ?? type.name
    }

    public func node() -> SCNNode {
        let node = SCNNode()
        switch self.type {
        case .box:
            let box = SCNBox(width: CatalogueItem.kBoxSide,
                             height: CatalogueItem.kBoxSide,
                             length: CatalogueItem.kBoxSide,
                             chamferRadius: 0)
            node.geometry = box
            
        case .sphere:
            let sphere = SCNSphere(radius: CatalogueItem.kSphereRadius)
            node.geometry = sphere
        default:
            assertionFailure("Case undeclared")
        }
        return node
    }
    
    public var image: UIImage? {
        get {
            guard let name = self.imageName else {
                return nil;
            }
            return UIImage(named: name)
        }
    }
}

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
