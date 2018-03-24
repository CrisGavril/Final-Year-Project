//
//  ViewController.swift
//  FinalYearProject
//
//  Created by Cristina  on 10/03/2018.
//  Copyright © 2018 Cristina . All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import GameKit

class ViewController: UIViewController {
    
    @IBOutlet var sceneView: SceneView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Show statistics such as fps and node count
        sceneView.showsStatistics = true
        
        // Load the SCNScene from 'Scene.scn'
        if let scene = Scene(named: "Scene") {
//            scene.scaleMode = .resizeFill
//            scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            self.sceneView.scene = scene
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
}

extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let scene = SCNScene(named: "Table.scn"),
            let tableNode = scene.rootNode.childNode(withName: "GraniteTable", recursively: true) else {
                return nil
        }
    
        return tableNode
    }
}

extension ViewController: ItemAdding {
    func addItem(at cameraTransform: matrix_float4x4) -> ARAnchor {
        // Create a transform with a translation of 1 meter(s) in front of the camera
        var translation = matrix_identity_float4x4
        translation = matrix_scale(0.007, translation)
        translation.columns.3.x = -0.5
        translation.columns.3.y = -0.5
        translation.columns.3.z = -1.0
        let transform = simd_mul(cameraTransform, translation)

        // Add a new anchor to the session
        let anchor = ARAnchor(transform: transform)
        return anchor
    }
}
