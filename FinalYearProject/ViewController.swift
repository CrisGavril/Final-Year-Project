//
//  ViewController.swift
//  FinalYearProject
//
//  Created by Cristina  on 10/03/2018.
//  Copyright © 2018 Cristina . All rights reserved.
//

import UIKit
import SpriteKit
import ARKit
import GameKit

class ViewController: UIViewController {
    
    @IBOutlet var sceneView: SceneView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and node count
        sceneView.showsFPS = true
        sceneView.showsNodeCount = true
//        sceneView.showsStatistics = true
        
        // Load the SKScene from 'Scene.sks'
//        if let scene = Scene(named: "Scene") {
        if let scene = SpriteScene(fileNamed: "Scene") {
            scene.scaleMode = .resizeFill
            scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            sceneView.presentScene(scene)
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

//extension ViewController: ARSCNViewDelegate {
//    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
//        guard let scene = SCNScene(named: "Table.scn"),
//            let tableNode = scene.rootNode.childNode(withName: "GraniteTable", recursively: true) else {
//                return nil
//        }
//        return tableNode
//    }
//}

extension ViewController: ARSKViewDelegate {

    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
        // Create and configure a node for the anchor added to the view's session.
        let labelNode = SKLabelNode(text: "👾")
        labelNode.horizontalAlignmentMode = .center
        labelNode.verticalAlignmentMode = .center
        return labelNode;
    }

    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        print("Session Failed - probably due to lack of camera access")
    }

    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        print("Session interrupted")
    }

    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        print("Session resumed")
        sceneView.session.run(session.configuration!,
                              options: [.resetTracking,
                                        .removeExistingAnchors])
    }
}


