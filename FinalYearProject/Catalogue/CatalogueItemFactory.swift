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
    fileprivate static let kNumberOfModels = 9
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
        case 7:
            namePrefix = "Huttra"
        case 8:
            namePrefix = "Tinad"
        default:
            fatalError("Case undefined")
        }
        // We use this number formatter to generate spelled-out numbers that
        // should generate nice names for our test products
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .spellOut
        let nameSuffix = numberFormatter.string(from: NSNumber(value: index)) ?? ""
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
        // App currently only supports boxes and sphere
        let type = ItemType(withIndex: index)
        let imageName: String?
        let sceneName: String?
        switch type {
        case .box:
            imageName = "Box item"
            sceneName = nil
        case .sphere:
            imageName = "Sphere item"
            sceneName = nil
        case .chair:
            imageName = "Some chair" //TODO: add chair images and image name factory
            sceneName = CatalogueItemFactory.generateChairSceneName(forIndex: index)
        case .flower:
            imageName = "Flower item" //TODO: add flower images and image name factory
            sceneName = CatalogueItemFactory.generateFlowerSceneName(forIndex: index)
        case .dresser:
            imageName = "Dresser"
            sceneName = "Dresser"
        }
        
        return CatalogueItem(type: type,
                             name: CatalogueItemFactory.generateItemName(forIndex: index),
                             imageName: imageName,
                             sceneName: sceneName)
    }
}

fileprivate extension ItemType {
    // For demo purposes only
    init(withIndex index: Int) {
        let chairsInferiorBound = 2
        let chairsSuperiorBound = chairsInferiorBound + CatalogueItemFactory.kNumberOfChairModels - 1
        let flowersInferiorBound = chairsSuperiorBound + 1
        let flowersSuperiorBound = flowersInferiorBound + CatalogueItemFactory.kNumberOfFlowerModels - 1
        switch index % CatalogueItemFactory.kNumberOfModels {
        case 0:
            self = .box
        case 1:
            self = .sphere
        case chairsInferiorBound ... chairsSuperiorBound:
            self = .chair
        case flowersInferiorBound ... flowersSuperiorBound:
            self = .flower
        case 8:
            self = .dresser
        default:
            fatalError("Case undefined")
        }
    }
}
