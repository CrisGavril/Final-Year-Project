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

class CameraViewController: UIViewController {
    
    @IBOutlet var sceneView: SceneView!
    @IBOutlet var itemInfoLabel: UILabel!
    @IBOutlet var catalogueButton: UIButton!
    @IBOutlet var screenshotButton: UIButton!
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var debugSwitch: UISwitch!
    
    @IBAction func takeScreenshot() {
        let viewsAndHiddenState: [(UIView,Bool)] = [
            self.itemInfoLabel,
            self.catalogueButton,
            self.screenshotButton,
            self.deleteButton,
            self.debugSwitch,
            ].map { ($0, $0.isHidden) }
        
        viewsAndHiddenState.forEach { $0.0.isHidden = true }
        
        if let image = self.view.getScreenshot() {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        }
        
        viewsAndHiddenState.forEach { $0.0.isHidden = $0.1 }
    }
    
    private var shownItemNodes = Set<ItemNode>()
    
    public var currentItem: CatalogueItem? = nil {
        didSet {
            self.updateInfoLabel()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the SCNScene from 'Scene.scn'
        if let scene = Scene(named: "Scene") {
            self.sceneView.scene = scene
        }
        self.updateInfoLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
        
        //Hide navigation bar
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    // MARK: - Storyboard
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCatalogue", let catalogueVC = segue.destination as? CatalogueViewController {
            catalogueVC.catalogue = Catalogue.sharedInstance
        }
    }
    
    @IBAction func unwindToCamera(withSegue segue: UIStoryboardSegue) {
        if segue.identifier == "showInAR", let itemDetailsVC = segue.source as? ItemDetailsViewController {
            self.currentItem = itemDetailsVC.item
        }
    }
    
    // Show statistics such as fps and node count
    @IBAction func showDebug(switch: UISwitch) {
        self.sceneView.showsStatistics = `switch`.isOn
        if `switch`.isOn {
            self.sceneView.debugOptions.insert(ARSCNDebugOptions.showFeaturePoints)
            self.sceneView.debugOptions.insert(ARSCNDebugOptions.showWorldOrigin)
        } else {
            self.sceneView.debugOptions.remove(ARSCNDebugOptions.showFeaturePoints)
            self.sceneView.debugOptions.remove(ARSCNDebugOptions.showWorldOrigin)
        }
    }
    
    private func updateInfoLabel() {
        guard let itemName = self.currentItem?.name else {
            self.itemInfoLabel.isHidden = true
            return
        }
        self.itemInfoLabel.isHidden = false
        self.itemInfoLabel.text = "Tap anywhere to place \(itemName)"
    }
}

extension CameraViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        for itemNode in self.shownItemNodes {
            guard itemNode.anchor == anchor else {
                continue
            }
            itemNode.simdPosition = anchor.transform.translation
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            self.sceneView.updateNodes()
        }
    }
}

extension CameraViewController: ItemHandling {
    func addItem(at transform: matrix_float4x4,
                 in sceneView: SceneView) {
        guard let currentItem = self.currentItem else {
            return
        }
        
        let node = ItemNode.node(forType: currentItem.type)
        let worldTransform = SCNMatrix4(transform)
        node.setWorldTransform(worldTransform)
        self.shownItemNodes.insert(node)
        sceneView.scene.rootNode.addChildNode(node)
        node.addOrUpdateAnchor(in: sceneView.session)
        print("Added item at \(worldTransform)")
        self.currentItem = nil
    }
    
    func didSelect(node: SCNNode) {
        guard let itemNode = self.itemNode(for: node) as? ItemNode else {
            return
        }
        
        // TODO: add highlighting to the item
        itemNode.removeFromParentNode()
        self.shownItemNodes.remove(itemNode)
    }
    
    func itemNode(for node: SCNNode) -> SCNNode? {
        guard let itemNode = (node as? ItemNode) ?? (node.parent as? ItemNode) else {
            return nil
        }
        
        guard self.shownItemNodes.contains(itemNode) else {
            return nil
        }
        return itemNode
    }
}

