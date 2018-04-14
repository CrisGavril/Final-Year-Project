//
//  Catalogue.swift
//  FinalYearProject
//
//  Created by Cristina  on 31/03/2018.
//  Copyright © 2018 Cristina . All rights reserved.
//

import Foundation
import SceneKit

enum CatalogueItem {
    case box
    case sphere
    case table
    case chair
    
    private static let kBoxSide: CGFloat = 0.5 //meters
    private static let kSphereRadius: CGFloat = 0.25 //meters
    
    public func node() -> SCNNode {
        let node = SCNNode()
        switch self {
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

struct Catalogue {
    public private(set) var items: [CatalogueItem]
    public var currentItemIndex: Int?
    public var currentItem: CatalogueItem? {
        get {
            guard let currentItemIndex = self.currentItemIndex,
                currentItemIndex < self.items.count else {
                return nil
            }
            return self.items[currentItemIndex]
        }
    }
    
    init() {
        items = [.box, .sphere]
        currentItemIndex = nil
    }
}
