//
//  Nodes.swift
//  AR-Portal
//
//  Created by Bjarne Lundgren on 02/07/2017.
//  Copyright © 2017 Silicon.dk ApS. All rights reserved.
//

import Foundation
import SceneKit

let bitMaskForMaskingNodes = 64

final class Nodes {
    static let WALL_WIDTH:CGFloat = 0.02
    static let WALL_HEIGHT:CGFloat = 2
    static let WALL_LENGTH:CGFloat = 1
    
    class func maskingWallSegmentNode() -> SCNNode {
        let wallSegment = SCNBox(width: Nodes.WALL_WIDTH,
                                 height: Nodes.WALL_HEIGHT,
                                 length: Nodes.WALL_LENGTH,
                                 chamferRadius: 0)
        wallSegment.firstMaterial?.diffuse.contents = UIColor.red
        wallSegment.firstMaterial?.transparency = 0.000001
        wallSegment.firstMaterial?.writesToDepthBuffer = true
        
        let node = SCNNode(geometry: wallSegment)
        node.categoryBitMask = bitMaskForMaskingNodes
        node.renderingOrder = 100
        
        return node
    }
    
    class func wallSegmentNode() -> SCNNode {
        let wallSegment = SCNBox(width: Nodes.WALL_WIDTH,
                                 height: Nodes.WALL_HEIGHT,
                                 length: Nodes.WALL_LENGTH,
                                 chamferRadius: 0)
        wallSegment.firstMaterial?.diffuse.contents = UIColor.brown
        wallSegment.firstMaterial?.writesToDepthBuffer = true
        wallSegment.firstMaterial?.readsFromDepthBuffer = true
        
        let node = SCNNode(geometry: wallSegment)
        node.renderingOrder = 200
        
        return node
    }
}
