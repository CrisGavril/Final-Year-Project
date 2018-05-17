//
//  CatalogueItemFactory.swift
//  FinalYearProject
//
//  Created by Cristina  on 15/05/2018.
//  Copyright © 2018 Cristina . All rights reserved.
//

import Foundation

// For demo purposes only
struct CatalogueItemFactory {
    fileprivate static let kNumberOfModels = 7
    fileprivate static let kNumberOfChairModels = 4
    fileprivate static let kNumberOfFlowerModels = 2
    
    private static func generateItemName(forIndex index: Int) -> String {
        let namePrefix: String
        // These are random product names from Ikea.
        // We need something that will be different from the item type to test the search functionality.
        switch index % CatalogueItemFactory.kNumberOfModels {
        case 0:
            namePrefix = "Henriksdal"
        case 1:
            namePrefix = "Ekedalen"
        case 2:
            namePrefix = "Odger"
        case 3:
            namePrefix = "Sundvik"
        case 4:
            namePrefix = "Sniglar"
        case 5:
            namePrefix = "Vikare"
        case 6:
            namePrefix = "Frysa"
        default:
            fatalError("Case undefined")
        }
        // We use this number formatter to generate spelled-out numbers that
        // should generate nice names for our test products
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .spellOut
        let nameSuffix = numberFormatter.string(from: NSNumber(value: index + 1)) ?? ""
        return "\(namePrefix) \(nameSuffix)"
    }
    
    private static func generateChairSceneName(forIndex index: Int) -> String {
        switch index % CatalogueItemFactory.kNumberOfChairModels {
        case 0:
            return "Leather chair"
        case 1:
            return "Bella's barstool"
        case 2:
            return "Flowchair"
        case 3:
            return "Cubes ottoman"
        default:
            fatalError("Case undefined")
        }
    }
    
    private static func generateFlowerSceneName(forIndex index: Int) -> String {
        switch index % CatalogueItemFactory.kNumberOfFlowerModels {
        case 0:
            return "Flower"
        case 1:
            return "Flower2"
        default:
            fatalError("Case undefined")
        }
    }
    
    static func generateItem(forIndex index: Int) -> CatalogueItem {
        let type = ItemType(withIndex: index)
        let sceneName: String
        switch type {
        case .chair:
            sceneName = CatalogueItemFactory.generateChairSceneName(forIndex: index % kNumberOfModels)
        case .flower:
            sceneName = CatalogueItemFactory.generateFlowerSceneName(forIndex: index % kNumberOfModels)
        case .dresser:
            sceneName = "Dresser"
        }
        // As long as the image asset and model names are in sync this formula will work
        let imageName = sceneName + " item"
        
        return CatalogueItem(type: type,
                             name: CatalogueItemFactory.generateItemName(forIndex: index),
                             imageName: imageName,
                             sceneName: sceneName)
    }
}

fileprivate extension ItemType {
    // For demo purposes only
    init(withIndex index: Int) {
        let chairsInferiorBound = 0
        let chairsSuperiorBound = chairsInferiorBound + CatalogueItemFactory.kNumberOfChairModels - 1
        let flowersInferiorBound = chairsSuperiorBound + 1
        let flowersSuperiorBound = flowersInferiorBound + CatalogueItemFactory.kNumberOfFlowerModels - 1
        
        switch index % CatalogueItemFactory.kNumberOfModels {
        case chairsInferiorBound ... chairsSuperiorBound:
            self = .chair
        case flowersInferiorBound ... flowersSuperiorBound:
            self = .flower
        case flowersSuperiorBound + 1:
            self = .dresser
        default:
            fatalError("Case undefined")
        }
    }
}
