//
//  Catalogue.swift
//  FinalYearProject
//
//  Created by Cristina  on 31/03/2018.
//  Copyright © 2018 Cristina . All rights reserved.
//

import Foundation
import SceneKit

enum ItemType {
    case box
    case sphere
    case table
    case chair
}

struct CatalogueItem: Equatable {
    private static let kBoxSide: CGFloat = 0.5 //meters
    private static let kSphereRadius: CGFloat = 0.25 //meters
    
    let type: ItemType
    var isFavourite: Bool
    
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
    
    public var name: String {
        get {
            switch self.type {
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
    
    public var image: UIImage? {
        get {
            switch self.type {
            case .box:
                return UIImage(named: "Box")
            case .sphere:
                return UIImage(named: "Sphere")
            default:
                return nil
            }
        }
    }
}

struct Catalogue {
    static let catalogueUpdateNotification: NSNotification.Name = NSNotification.Name(rawValue: "CatalogueDidUpdate")
    
    public private(set) var items: [CatalogueItem]
    
    private init() {
        items = [CatalogueItem(type: .box, isFavourite: false),
                 CatalogueItem(type: .sphere, isFavourite: false)]
    }
    
    public static var sharedInstance: Catalogue = {
        return Catalogue()
    }()
    
    public mutating func updateItem(_ item: CatalogueItem, at index: Int) {
        guard index < self.items.count else {
            return
        }
        self.items[index] = item
        
        NotificationCenter.default.post(name: Catalogue.catalogueUpdateNotification,
                                        object: nil,
                                        userInfo: nil)
    }
}
