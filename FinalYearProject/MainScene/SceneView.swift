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
    func addItem(at transform: matrix_float4x4, in scene: SceneView)
    func didSelect(node: SCNNode)
    func hasItem(for node: SCNNode) -> Bool
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
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(with:)))
        self.addGestureRecognizer(panRecognizer)
        
        let rotationRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(viewRotated(with:)))
        self.addGestureRecognizer(rotationRecognizer)
        
    }

    @objc func viewTapped(with tapRecognizer: UITapGestureRecognizer) {
        guard let delegate = self.itemHandler else {
            return
        }
        
        if let existingNode = self.findNode(for: tapRecognizer) {
            delegate.didSelect(node: existingNode)
            return
        }
        
        let tapLocation = tapRecognizer.location(in: self)

        if let featurePoint = self.hitTest(tapLocation, types: .featurePoint).first {
            delegate.addItem(at: featurePoint.worldTransform, in: self)
            return
        }
    }
    
    private var nodeBeingPanned: SCNNode? = nil
    private var currentPanPosition: CGPoint? = nil
    @objc func viewPanned(with panRecognizer: UIPanGestureRecognizer) {
        switch panRecognizer.state {
        case .began:
            guard let existingNode = self.findNode(for: panRecognizer) else {
                break
            }
            self.nodeBeingPanned = existingNode
            let position = self.projectPoint(existingNode.position)
            self.currentPanPosition = CGPoint(x: CGFloat(position.x), y: CGFloat(position.y))
        case .changed:
            guard var currentPosition = self.currentPanPosition else {
                break
            }
            let translation = panRecognizer.translation(in: self)
            currentPosition.x += translation.x
            currentPosition.y += translation.y
            self.currentPanPosition = currentPosition
            panRecognizer.setTranslation(.zero, in: self)
        case .ended:
            guard let nodeBeingPanned = self.nodeBeingPanned as? ItemNode else {
                break
            }
            nodeBeingPanned.addOrUpdateAnchor(in: self.session)
            fallthrough
        case .cancelled,
             .failed,
             .possible:
            self.nodeBeingPanned = nil
            self.currentPanPosition = nil
        }
    }
    
    private var nodeBeingRotated: SCNNode? = nil
    @objc func viewRotated(with rotationRecognizer: UIRotationGestureRecognizer) {
        switch rotationRecognizer.state {
        case .began:
            self.nodeBeingRotated = self.findNode(for: rotationRecognizer)
        case .changed:
            guard let node = self.nodeBeingRotated else {
                break
            }
            self.rotate(node, at: Float(rotationRecognizer.rotation))
            rotationRecognizer.rotation = 0.0
        case .ended,
             .cancelled,
             .failed,
             .possible:
            self.nodeBeingRotated = nil
        }
    }
    
    /// This function updates the nodes being currently interacted with.
    /// This function should be called at every scene render
    public func updateNodes() {
        if let nodeBeingPanned = self.nodeBeingPanned,
            let currentPosition = self.currentPanPosition {
            self.translate(nodeBeingPanned,
                      to: currentPosition)
        }
    }
    
    private func translate(_ node: SCNNode, to position: CGPoint) {
        let types: ARHitTestResult.ResultType = [
            .existingPlaneUsingGeometry,
            .existingPlane,
            .estimatedHorizontalPlane,
            // .estimatedVerticalPlane,
        ]
        
        guard let worldTransformTranslation = self.hitTest(for: node, position: position, types: types)?.worldTransform.translation else {
            // no results found
            return
        }
        node.simdPosition = worldTransformTranslation
    }
    
    private func rotate(_ node: SCNNode, at angle: Float) {
        //let node = node.childNodes.first ?? node
        // Works when object viewed from above, if viewed from below angle needs to be added
        node.eulerAngles.y -= angle
    }
    
    private func hitTest(for node: SCNNode, position: CGPoint, types: ARHitTestResult.ResultType) -> ARHitTestResult? {
        let results = self.hitTest(position, types: types)
        if let existingGeometryResult = SceneView.existingGeometryResult(from: results) {
            // Found result on existing geometry
            return existingGeometryResult
        } else if let existingPlaneResult = SceneView.existingPlaneResult(from: results, near: node) {
            // Found result on existing plane close to the object
            return existingPlaneResult
        } else if let estimatedPlaneResults = SceneView.estimatedHorizontalPlaneResult(from: results) {
            // Found result on estimated plane
            return estimatedPlaneResults
        }
        return nil
    }
    
    private static func existingGeometryResult(from results: [ARHitTestResult]) -> ARHitTestResult? {
        return results.first(where: { $0.type == .existingPlaneUsingGeometry })
    }
    
    private static func existingPlaneResult(from results: [ARHitTestResult], near node: SCNNode) -> ARHitTestResult? {
        for result in results {
            if result.type == .existingPlane &&
                (result.anchor as? ARPlaneAnchor)?.alignment == .horizontal &&
                fabs(node.position.y - result.worldTransform.translation.y) < 0.05 {
                return result
            }
        }
        
        return nil
    }
    
    private static func estimatedHorizontalPlaneResult(from results: [ARHitTestResult]) -> ARHitTestResult? {
        return results.first(where: { $0.type == .estimatedHorizontalPlane })
    }
    
    private func findNode(for gestureRecognizer: UIGestureRecognizer) -> SCNNode? {
        guard let itemHandler = self.itemHandler else {
            return nil
        }
        let tapLocation = gestureRecognizer.location(in: self)
        
        let hitTestResults = self.hitTest(tapLocation)
        
        for node in hitTestResults.map({ $0.node }) {
            if itemHandler.hasItem(for: node) {
                return node
            }
        }
        
        return nil
    }
}
