//
//  ViewController.swift
//  AR-Portal
//
//  Created by Bjarne Lundgren on 02/07/2017.
//  Copyright © 2017 Silicon.dk ApS. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    @IBOutlet weak var planeSearchLabel: UILabel!
    @IBOutlet weak var sceneView: ARSCNView!
    
    // State
    private func updatePlaneOverlay() {
        DispatchQueue.main.async {
            
            self.planeSearchLabel.isHidden = self.currentPlane != nil
            
            if self.planeCount == 0 {
                self.planeSearchLabel.text = "Move around to allow the app the find a plane..."
            } else {
                self.planeSearchLabel.text = "Tap on a plane surface to place board..."
            }
            
        }
    }
    
    var planeCount = 0 {
        didSet {
            updatePlaneOverlay()
        }
    }
    var currentPlane:SCNNode? {
        didSet {
            updatePlaneOverlay()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(didTap))
        sceneView.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingSessionConfiguration()
        configuration.planeDetection = .horizontal
        configuration.isLightEstimationEnabled = true
        
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    private func anyPlaneFrom(location:CGPoint) -> (SCNNode, SCNVector3)? {
        let results = sceneView.hitTest(location,
                                        types: ARHitTestResult.ResultType.existingPlaneUsingExtent)
        
        print("anyPlaneFrom results \(results)")
        guard results.count > 0,
              let anchor = results[0].anchor,
              let node = sceneView.node(for: anchor) else { return nil }
        
        return (node, SCNVector3.positionFromTransform(results[0].worldTransform))
    }
    
    @objc func didTap(_ sender:UITapGestureRecognizer) {
        let location = sender.location(in: sceneView)
        
        print("didTap \(location)")
        
        guard currentPlane == nil,
              let newPlaneData = anyPlaneFrom(location: location) else { return }
        
        
        print("adding wall???")
        currentPlane = newPlaneData.0
        
        
        let wallNode = SCNNode()
        wallNode.position = newPlaneData.1
        
        // back
        for i in 0..<3 {
            let z:Float = Float(Nodes.WALL_LENGTH) * Float(i)
            let y:Float = Float(Nodes.WALL_HEIGHT) * Float(0.5)
            let x1:Float = 0
            let x2:Float = Float(Nodes.WALL_WIDTH)
            
            let maskingWallSegmentNode = Nodes.maskingWallSegmentNode()
            maskingWallSegmentNode.position = SCNVector3(x1, y, z)
            wallNode.addChildNode(maskingWallSegmentNode)
            
            let wallSegmentNode = Nodes.wallSegmentNode()
            wallSegmentNode.position = SCNVector3(x2, y, z)
            wallNode.addChildNode(wallSegmentNode)
        }
        
        // sides
        for i in 0..<3 {
            let x:Float = Float(Nodes.WALL_LENGTH) * Float(i)
            let y:Float = Float(Nodes.WALL_HEIGHT) * Float(0.5)
            let z1:Float = 0
            let z2:Float = Float(Nodes.WALL_WIDTH)
            let z3:Float = Float(Nodes.WALL_LENGTH) * Float(3)
            let z4:Float = Float(Nodes.WALL_LENGTH) * Float(3) + Float(Nodes.WALL_WIDTH)
            
            let maskingWallSegmentNode = Nodes.maskingWallSegmentNode()
            maskingWallSegmentNode.eulerAngles = SCNVector3(0, 90.0.degreesToRadians, 0)
            maskingWallSegmentNode.position = SCNVector3(x, y, z1)
            wallNode.addChildNode(maskingWallSegmentNode)
            
            let wallSegmentNode = Nodes.wallSegmentNode()
            wallSegmentNode.eulerAngles = SCNVector3(0, 90.0.degreesToRadians, 0)
            wallSegmentNode.position = SCNVector3(x, y, z2)
            wallNode.addChildNode(wallSegmentNode)
            
            let maskingWallSegmentNode2 = Nodes.maskingWallSegmentNode()
            maskingWallSegmentNode2.eulerAngles = SCNVector3(0, -90.0.degreesToRadians, 0)
            maskingWallSegmentNode2.position = SCNVector3(x, y, z3)
            wallNode.addChildNode(maskingWallSegmentNode2)
            
            let wallSegmentNode2 = Nodes.wallSegmentNode()
            wallSegmentNode2.eulerAngles = SCNVector3(0, -90.0.degreesToRadians, 0)
            wallSegmentNode2.position = SCNVector3(x, y, z4)
            wallNode.addChildNode(wallSegmentNode2)
        }
        
        sceneView.scene.rootNode.addChildNode(wallNode)
    }
    
    /// MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
    }
    
    // did at plane(?)
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        planeCount += 1
    }
    
    // did update plane?
    func renderer(_ renderer: SCNSceneRenderer, willUpdate node: SCNNode, for anchor: ARAnchor) {
        
    }
    
    // did remove plane?
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        if node == currentPlane {
            //TODO: cleanup
        }
        
        if planeCount > 0 {
            planeCount -= 1
        }
    }

}

