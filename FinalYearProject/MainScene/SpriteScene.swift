//
//  Scene.swift
//  FinalYearProject
//
//  Created by Cristina  on 10/03/2018.
//  Copyright © 2018 Cristina . All rights reserved.
//

import SpriteKit
import ARKit

class SpriteScene: SKScene {
    
    var sceneView: ARSKView {
        return view as! ARSKView
    }
    
    var isWorldSetUp = false
    
    private func setUpWorld() {
//        guard let currentFrame = sceneView.session.currentFrame else {
//            return
//        }
        
        isWorldSetUp = true
        
//        var translation = matrix_identity_float4x4
//        translation.columns.3.z = -0.3
//        let transform = currentFrame.camera.transform * translation
//
//        let anchor = ARAnchor(transform: transform)
//        sceneView.session.add(anchor: anchor)
    }
    
    override func didMove(to view: SKView) {
        // Setup your scene here
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if !isWorldSetUp {
            setUpWorld()
        }
        
        // 1
        guard let currentFrame = sceneView.session.currentFrame,
            let lightEstimate = currentFrame.lightEstimate else {
                return
        }
        
        // 2
        let neutralIntensity: CGFloat = 800
        let ambientIntensity = min(lightEstimate.ambientIntensity,
                                   neutralIntensity)
        let blendFactor = 1 - ambientIntensity / neutralIntensity
        
        // 3
        for node in children {
            if let bug = node as? SKLabelNode {
                bug.color = .black
                bug.colorBlendFactor = blendFactor
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let sceneView = self.view as? ARSKView else {
            return
        }
        
        // Create anchor using the camera's current position
        if let currentFrame = sceneView.session.currentFrame {
            
            // Create a transform with a translation of 0.2 meters in front of the camera
            var translation = matrix_identity_float4x4
            translation.columns.3.z = -1.0
            let transform = simd_mul(currentFrame.camera.transform, translation)
            
            // Add a new anchor to the session
            let anchor = ARAnchor(transform: transform)
            sceneView.session.add(anchor: anchor)
        }
    }
}
