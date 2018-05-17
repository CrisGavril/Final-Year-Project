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
    case chair
    case flower
    case dresser
    
    public var name: String {
        get {
            switch self {
            case .chair:
                return "Chair"
            case .flower:
                return "Flower"
            case .dresser:
                return "Dresser"
            }
        }
    }
}

struct CatalogueItem: Equatable, Codable {
    let type: ItemType
    var isFavourite: Bool
    public let name: String
    private let imageName: String?
    let sceneName: String?
    
    init(type: ItemType,
         name: String? = nil,
         isFavourite: Bool = false,
         imageName: String? = nil,
         sceneName: String? = nil) {
        self.type = type
        self.name = name ?? type.name
        self.isFavourite = isFavourite
        self.imageName = imageName ?? type.name
        self.sceneName = sceneName
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
