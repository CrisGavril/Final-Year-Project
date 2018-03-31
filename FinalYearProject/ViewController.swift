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
    
    static let kBoxSide: CGFloat = 0.5 //meters
    
    @IBOutlet var sceneView: SceneView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Show statistics such as fps and node count
        sceneView.showsStatistics = true
        
        // Load the SCNScene from 'Scene.scn'
        if let scene = Scene(named: "Scene") {
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
}

extension ViewController: ItemHandling {
    func addItem(at transform: matrix_float4x4,
                 in scene: SCNScene) {
        let box = SCNBox(width: ViewController.kBoxSide,
                         height: ViewController.kBoxSide,
                         length: ViewController.kBoxSide,
                         chamferRadius: 0)
        let boxNode = SCNNode()
        let worldTransform = SCNMatrix4(transform)
        boxNode.geometry = box
        boxNode.setWorldTransform(worldTransform)
        scene.rootNode.addChildNode(boxNode)
        print("Added item at \(worldTransform)")
    }
    
    func didSelect(item: SCNNode) {
        // TODO: add highlighting to the item
        item.removeFromParentNode()
    }
}
