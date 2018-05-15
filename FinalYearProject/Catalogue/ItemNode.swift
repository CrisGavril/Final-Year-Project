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
    private static let kBoxSide: CGFloat = 0.5 //meters
    private static let kSphereRadius: CGFloat = 0.25 //meters

    var anchor: ARAnchor? = nil
    
    class func node(forType type: ItemType) -> ItemNode {
        let node: ItemNode
        switch type {
        case .box:
            node = ItemNode()
            let box = SCNBox(width: ItemNode.kBoxSide,
                             height: ItemNode.kBoxSide,
                             length: ItemNode.kBoxSide,
                             chamferRadius: 0)
            node.geometry = box
        case .sphere:
            node = ItemNode()
            let sphere = SCNSphere(radius: ItemNode.kSphereRadius)
            node.geometry = sphere
        case .flower:
            let url = Bundle.main.url(forResource: "Flower", withExtension: "scn")
            let scene = try! SCNScene(url: url!, options: nil)
            let flower = scene.rootNode.childNodes.first!
            node = ItemNode()
            node.addChildNode(flower)
        default:
            fatalError("Case undeclared")
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
