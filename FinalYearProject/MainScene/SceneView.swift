//
//  SceneView.swift
//  FinalYearProject
//
//  Created by Cristina  on 21/03/2018.
//  Copyright © 2018 Cristina . All rights reserved.
//

import ARKit
import SceneKit

@objc protocol ItemAdding {
    func addItem(at cameraTransform: matrix_float4x4) -> ARAnchor
}

class SceneView: ARSCNView {
    @IBOutlet var itemAdderDelegate: ItemAdding?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Create anchor using the camera's current position
        guard let currentFrame = self.session.currentFrame,
            let delegate = self.itemAdderDelegate else {
            return
        }

        let cameraTransform = currentFrame.camera.transform
        let anchor = delegate.addItem(at: cameraTransform)
        self.session.add(anchor: anchor)
    }
}
