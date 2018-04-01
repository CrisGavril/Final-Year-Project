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

class ViewController: UIViewController {
    
    @IBOutlet var sceneView: SceneView!
    
    fileprivate var catalogue = Catalogue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the SCNScene from 'Scene.scn'
        if let scene = Scene(named: "Scene") {
            self.sceneView.scene = scene
        }
        
        // TODO: move to item selection
        setCurrentItem(1)
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
    
    fileprivate func setCurrentItem(_ itemIndex: Int) {
        guard self.catalogue.items.count > itemIndex else {
            return
        }
        self.catalogue.currentItem = self.catalogue.items[itemIndex]
    }
    
    @IBAction func showDebug(switch: UISwitch) {
        if `switch`.isOn {
            // Show statistics such as fps and node count
            self.sceneView.showsStatistics = true
            self.sceneView.debugOptions.insert(ARSCNDebugOptions.showFeaturePoints)
            self.sceneView.debugOptions.insert(ARSCNDebugOptions.showWorldOrigin)
        } else {
            self.sceneView.showsStatistics = false
            self.sceneView.debugOptions.remove(ARSCNDebugOptions.showFeaturePoints)
            self.sceneView.debugOptions.remove(ARSCNDebugOptions.showWorldOrigin)
        }
    }
}

extension ViewController: ARSCNViewDelegate {
}

extension ViewController: ItemHandling {
    func addItem(at transform: matrix_float4x4,
                 in scene: SCNScene) {
        guard let currentItem = self.catalogue.currentItem else {
            return
        }
        
        let node = currentItem.node()
        let worldTransform = SCNMatrix4(transform)
        node.setWorldTransform(worldTransform)
        scene.rootNode.addChildNode(node)
        print("Added item at \(worldTransform)")
    }
    
    func didSelect(item: SCNNode) {
        // TODO: add highlighting to the item
        item.removeFromParentNode()
    }
}

