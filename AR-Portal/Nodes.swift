//
//  Nodes.swift
//  AR-Portal
//
//  Created by Bjarne Lundgren on 02/07/2017.
//  Copyright © 2017 Silicon.dk ApS. All rights reserved.
//

import Foundation
import SceneKit

final class Nodes {
    static let WALL_WIDTH:CGFloat = 0.02
    static let WALL_HEIGHT:CGFloat = 2.2
    static let WALL_LENGTH:CGFloat = 0.3
    
    class func maskingWallSegmentNode() -> SCNNode {
        let wallSegment = SCNBox(width: Nodes.WALL_WIDTH,
                                 height: Nodes.WALL_HEIGHT,
                                 length: Nodes.WALL_LENGTH,
                                 chamferRadius: 0)
        wallSegment.firstMaterial?.diffuse.contents = UIColor.red
        wallSegment.firstMaterial?.transparency = 0.000001
        wallSegment.firstMaterial?.writesToDepthBuffer = true
        
        let node = SCNNode(geometry: wallSegment)
        node.renderingOrder = 100   //everything inside the portal area must have higher rendering order...
        
        return node
    }
    
    class func plane(pieces:Int, maskYUpperSide:Bool = true) -> SCNNode {
        let maskSegment = SCNBox(width: Nodes.WALL_LENGTH * CGFloat(pieces),
                                 height: Nodes.WALL_WIDTH,
                                 length: Nodes.WALL_LENGTH * CGFloat(pieces),
                                 chamferRadius: 0)
        maskSegment.firstMaterial?.diffuse.contents = UIColor.red
        maskSegment.firstMaterial?.transparency = 0.000001
        maskSegment.firstMaterial?.writesToDepthBuffer = true
        let maskNode = SCNNode(geometry: maskSegment)
        maskNode.renderingOrder = 100
        
        let segment = SCNBox(width: Nodes.WALL_LENGTH * CGFloat(pieces),
                                 height: Nodes.WALL_WIDTH,
                                 length: Nodes.WALL_LENGTH * CGFloat(pieces),
                                 chamferRadius: 0)
        segment.firstMaterial?.diffuse.contents = UIImage(named: "Media.scnassets/slipperystonework-albedo.png")
        segment.firstMaterial?.ambientOcclusion.contents = UIImage(named: "Media.scnassets/slipperystonework-ao.png")
        segment.firstMaterial?.metalness.contents = UIImage(named: "Media.scnassets/slipperystonework-metalness.png")
        segment.firstMaterial?.normal.contents = UIImage(named: "Media.scnassets/slipperystonework-normal.png")
        segment.firstMaterial?.roughness.contents = UIImage(named: "Media.scnassets/slipperystonework-rough.png")
        segment.firstMaterial?.writesToDepthBuffer = true
        segment.firstMaterial?.readsFromDepthBuffer = true
        
        let segmentNode = SCNNode(geometry: segment)
        segmentNode.renderingOrder = 200
        
        let node = SCNNode()
        segmentNode.position = SCNVector3(Nodes.WALL_WIDTH * 0.5, 0, 0)
        node.addChildNode(segmentNode)
        maskNode.position = SCNVector3(Nodes.WALL_WIDTH * 0.5, maskYUpperSide ? Nodes.WALL_WIDTH : -Nodes.WALL_WIDTH, 0)
        node.addChildNode(maskNode)
        return node
    }
    
    class func wall(pieces:Int, maskXUpperSide:Bool = true) -> SCNNode {
        let node = SCNNode()
        
        for i in 0..<pieces {
            let segment = self.wallSegmentNode(withMask: true, maskXUpperSide: maskXUpperSide)
            segment.position = SCNVector3(0,
                                          Float(Nodes.WALL_HEIGHT) * 0.5,
                                          0 - (Float(Nodes.WALL_LENGTH) * Float(pieces) * 0.5)
                                            + Float(i) * Float(Nodes.WALL_LENGTH)
                                            + Float(Nodes.WALL_LENGTH) * 0.5)
            node.addChildNode(segment)
        }
        
        return node
    }
    
    class func wallSegmentNode(withMask:Bool = true, maskXUpperSide:Bool = true) -> SCNNode {
        if withMask {
            let node = SCNNode()
            let wallSegmentNode = self.wallSegmentNode(withMask: false)
            node.addChildNode(wallSegmentNode)
            
            let maskingWallSegmentNode = self.maskingWallSegmentNode()
            maskingWallSegmentNode.position = SCNVector3(maskXUpperSide ? Nodes.WALL_WIDTH : -Nodes.WALL_WIDTH,0,0)
            node.addChildNode(maskingWallSegmentNode)
            
            return node
            
        } else {
            let wallSegment = SCNBox(width: Nodes.WALL_WIDTH,
                                     height: Nodes.WALL_HEIGHT,
                                     length: Nodes.WALL_LENGTH,
                                     chamferRadius: 0)
            wallSegment.firstMaterial?.diffuse.contents = UIImage(named: "Media.scnassets/slipperystonework-albedo.png")
            wallSegment.firstMaterial?.ambientOcclusion.contents = UIImage(named: "Media.scnassets/slipperystonework-ao.png")
            wallSegment.firstMaterial?.metalness.contents = UIImage(named: "Media.scnassets/slipperystonework-metalness.png")
            wallSegment.firstMaterial?.normal.contents = UIImage(named: "Media.scnassets/slipperystonework-normal.png")
            wallSegment.firstMaterial?.roughness.contents = UIImage(named: "Media.scnassets/slipperystonework-rough.png")
            
            wallSegment.firstMaterial?.writesToDepthBuffer = true
            wallSegment.firstMaterial?.readsFromDepthBuffer = true
            
            let node = SCNNode(geometry: wallSegment)
            node.renderingOrder = 200
        
            return node
        }
    }
}
