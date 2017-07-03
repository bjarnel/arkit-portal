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
    static let WALL_LENGTH:CGFloat = 1
    
    static let DOOR_WIDTH:CGFloat = 0.6
    static let DOOR_HEIGHT:CGFloat = 1.5
    
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
    
    class func wallSegmentNode(length:CGFloat = Nodes.WALL_LENGTH,
                               height:CGFloat = Nodes.WALL_HEIGHT,
                               maskXUpperSide:Bool = true) -> SCNNode {
        let node = SCNNode()
        
        let wallSegment = SCNBox(width: Nodes.WALL_WIDTH,
                                 height: height,
                                 length: length,
                                 chamferRadius: 0)
        wallSegment.firstMaterial?.diffuse.contents = UIImage(named: "Media.scnassets/slipperystonework-albedo.png")
        wallSegment.firstMaterial?.ambientOcclusion.contents = UIImage(named: "Media.scnassets/slipperystonework-ao.png")
        wallSegment.firstMaterial?.metalness.contents = UIImage(named: "Media.scnassets/slipperystonework-metalness.png")
        wallSegment.firstMaterial?.normal.contents = UIImage(named: "Media.scnassets/slipperystonework-normal.png")
        wallSegment.firstMaterial?.roughness.contents = UIImage(named: "Media.scnassets/slipperystonework-rough.png")
        
        wallSegment.firstMaterial?.writesToDepthBuffer = true
        wallSegment.firstMaterial?.readsFromDepthBuffer = true
        
        let wallSegmentNode = SCNNode(geometry: wallSegment)
        wallSegmentNode.renderingOrder = 200
        
        node.addChildNode(wallSegmentNode)
        
        let maskingWallSegment = SCNBox(width: Nodes.WALL_WIDTH,
                                 height: height,
                                 length: length,
                                 chamferRadius: 0)
        maskingWallSegment.firstMaterial?.diffuse.contents = UIColor.red
        maskingWallSegment.firstMaterial?.transparency = 0.000001
        maskingWallSegment.firstMaterial?.writesToDepthBuffer = true
        
        let maskingWallSegmentNode = SCNNode(geometry: maskingWallSegment)
        maskingWallSegmentNode.renderingOrder = 100   //everything inside the portal area must have higher rendering order...
        
        
        maskingWallSegmentNode.position = SCNVector3(maskXUpperSide ? Nodes.WALL_WIDTH : -Nodes.WALL_WIDTH,0,0)
        node.addChildNode(maskingWallSegmentNode)
        
        return node
    }
}
