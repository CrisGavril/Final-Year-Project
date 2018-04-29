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
    
    init(type: ItemType) {
        super.init()
        switch type {
        case .box:
            let box = SCNBox(width: ItemNode.kBoxSide,
                             height: ItemNode.kBoxSide,
                             length: ItemNode.kBoxSide,
                             chamferRadius: 0)
            self.geometry = box
            
        case .sphere:
            let sphere = SCNSphere(radius: ItemNode.kSphereRadius)
            self.geometry = sphere
        default:
            assertionFailure("Case undeclared")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
