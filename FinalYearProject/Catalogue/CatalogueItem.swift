//
//  CatalogueItem.swift
//  FinalYearProject
//
//  Created by Cristina  on 21/04/2018.
//  Copyright © 2018 Cristina . All rights reserved.
//

import Foundation
import UIKit

enum ItemType: String, Codable {
    case box
    case sphere
    case table
    case chair
    case flower
    
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
            case .flower:
                return "Flower"
            }
        }
    }
}

struct CatalogueItem: Equatable, Codable {
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
    
    public var image: UIImage? {
        get {
            guard let name = self.imageName else {
                return nil;
            }
            return UIImage(named: name)
        }
    }
}
