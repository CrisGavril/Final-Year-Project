//
//  SceneView.swift
//  FinalYearProject
//
//  Created by Cristina  on 21/03/2018.
//  Copyright © 2018 Cristina . All rights reserved.
//

import ARKit
import SceneKit

class SceneView: ARSKView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Create anchor using the camera's current position
        guard let currentFrame = self.session.currentFrame else {
            return
        }
            
        // Create a transform with a translation of 0.2 meters in front of the camera
        var translation = matrix_identity_float4x4
        translation.columns.3.z = -1.0
        let transform = simd_mul(currentFrame.camera.transform, translation)
        
        // Add a new anchor to the session
        let anchor = ARAnchor(transform: transform)
        self.session.add(anchor: anchor)
    }
}
