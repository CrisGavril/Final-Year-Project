//
//  SceneView.swift
//  FinalYearProject
//
//  Created by Cristina  on 21/03/2018.
//  Copyright © 2018 Cristina . All rights reserved.
//

import ARKit
import SceneKit

@objc protocol ItemHandling {
    func addItem(at cameraTransform: matrix_float4x4) -> ARAnchor
    func didSelect(item: SCNNode)
}

class SceneView: ARSCNView {
    @IBOutlet var itemHandler: ItemHandling?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    override init(frame: CGRect, options: [String : Any]? = nil) {
        super.init(frame: frame, options: options)
        self.commonInit()
    }
    
    func commonInit() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped(with:)))
        self.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func viewTapped(with tapRecognizer: UITapGestureRecognizer) {
        guard let delegate = self.itemHandler else {
            return
        }
        
        let tapLocation = tapRecognizer.location(in: self)
        let hitTestResults = self.hitTest(tapLocation)
        if let node = hitTestResults.first?.node {
            delegate.didSelect(item: node)
        } else {
            guard let currentFrame = self.session.currentFrame else {
                return
            }
            let cameraTransform = currentFrame.camera.transform
            let anchor = delegate.addItem(at: cameraTransform)
            self.session.add(anchor: anchor)
        }
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        // Create anchor using the camera's current position
//        guard let currentFrame = self.session.currentFrame,
//            let delegate = self.itemAdderDelegate else {
//            return
//        }
//
//        let cameraTransform = currentFrame.camera.transform
//        let anchor = delegate.addItem(at: cameraTransform)
//        self.session.add(anchor: anchor)
//    }
}
