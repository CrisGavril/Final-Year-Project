//
//  ItemNode.swift
//  FinalYearProject
//
//  Created by Cristina  on 21/04/2018.
//  Copyright © 2018 Cristina . All rights reserved.
//

import Foundation
import SceneKit
import ARKit

class ItemNode: SCNNode {
    var anchor: ARAnchor? = nil
    
    public init(forType type: ItemType, sceneName: String? = nil) {
        super.init()
        switch type {
        case .flower:
            let flower = ItemNode.loadNode(fromScene: sceneName ?? "Flower")
            self.addChildNode(flower)
        case .chair:
            let chair = ItemNode.loadNode(fromScene: sceneName ?? "Cubes ottoman")
            self.addChildNode(chair)
        case .dresser:
            let dresser = ItemNode.loadNode(fromScene: sceneName ?? "Dresser")
            self.addChildNode(dresser)
//        default:
//            fatalError("Case undeclared")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private class func loadNode(fromScene fileName: String) -> SCNNode {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "scn"),
            let scene = try? SCNScene(url: url, options: nil),
            let node = scene.rootNode.childNodes.first else {
            fatalError("Could not load model from scene file \(fileName)")
        }
        return node
    }
    
    public func addOrUpdateAnchor(in session: ARSession) {
        if let anchor = self.anchor {
            session.remove(anchor: anchor)
        }
        
        let anchor = ARAnchor(transform: self.simdWorldTransform)
        session.add(anchor: anchor)
        self.anchor = anchor
    }
}
