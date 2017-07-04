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
    
    class func horizonNode(radius:CGFloat = WALL_LENGTH,
                           height:CGFloat = Nodes.WALL_HEIGHT,
                           segments:Int = 1000) -> SCNNode {
        var indices: [Int32] = []
        var vertices: [SCNVector3] = []
        var textureCoords = [CGPoint]()
        let textureRelativeSize = CGSize(width: 1.0 / CGFloat(segments),
                                         height: 1.0 / CGFloat(segments))
        let anglePart:Float = 180.0 / Float(segments)
        let startAngle:Float = -180.0
        
        for i in 0..<segments {
            let fromAngle = startAngle + anglePart * Float(i)
            let toAngle = startAngle + anglePart * Float(i + 1)
            
            let x1 = cos(fromAngle.degreesToRadians) * Float(radius)
            let z1 = sin(fromAngle.degreesToRadians) * Float(radius)
            
            let x2 = cos(toAngle.degreesToRadians) * Float(radius)
            let z2 = sin(toAngle.degreesToRadians) * Float(radius)
            
            let topLeftPos = SCNVector3(x1, Float(height), z1)
            let topRightPos = SCNVector3(x2, Float(height), z2)
            let bottomLeftPos = SCNVector3(x1, 0, z1)
            let bottomRightPos = SCNVector3(x2, 0, z2)
            
            // topLeftPos, topRightPos, bottomLeftPos
            indices.append(Int32(vertices.count))
            vertices.append(topLeftPos)
            textureCoords.append(CGPoint(x: textureRelativeSize.width * CGFloat(i),
                                         y: 0))
            
            indices.append(Int32(vertices.count))
            vertices.append(topRightPos)
            textureCoords.append(CGPoint(x: textureRelativeSize.width * CGFloat(i + 1),
                                         y: 0))
            
            indices.append(Int32(vertices.count))
            vertices.append(bottomLeftPos)
            textureCoords.append(CGPoint(x: textureRelativeSize.width * CGFloat(i),
                                         y: 1))
            
            // topRightPos, bottomRightPos, bottomLeftPos
            indices.append(Int32(vertices.count))
            vertices.append(topRightPos)
            textureCoords.append(CGPoint(x: textureRelativeSize.width * CGFloat(i + 1),
                                         y: 0))
            
            indices.append(Int32(vertices.count))
            vertices.append(bottomRightPos)
            textureCoords.append(CGPoint(x: textureRelativeSize.width * CGFloat(i + 1),
                                         y: 1))
            
            indices.append(Int32(vertices.count))
            vertices.append(bottomLeftPos)
            textureCoords.append(CGPoint(x: textureRelativeSize.width * CGFloat(i),
                                         y: 1))
        }
        
        let vertexSource = SCNGeometrySource(vertices: vertices)
        let textureSource = SCNGeometrySource(textureCoordinates: textureCoords)
        let element = SCNGeometryElement(indices: indices,
                                         primitiveType: .triangles)
        let geometry =  SCNGeometry(sources: [vertexSource, textureSource],
                                    elements: [element])
        // http://www.astron.nl/~oosterlo/Album/Oz2007/Uluru2007/slides/uluru-6Crop.html
        geometry.firstMaterial?.diffuse.contents = UIImage(named: "Media.scnassets/uluru.jpg")
        geometry.firstMaterial?.cullMode = .front
        
        
        let node = SCNNode(geometry: geometry)
        node.renderingOrder = 200
        
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
        
        if maskYUpperSide {
            segment.firstMaterial?.diffuse.contents = UIColor(red:0.39, green:0.55, blue:0.78, alpha:1.0)
        } else {
            segment.firstMaterial?.lightingModel = .physicallyBased
            segment.firstMaterial?.diffuse.contents = UIImage(named: "Media.scnassets/slipperystonework-albedo.png")
            segment.firstMaterial?.ambientOcclusion.contents = UIImage(named: "Media.scnassets/slipperystonework-ao.png")
            segment.firstMaterial?.metalness.contents = UIImage(named: "Media.scnassets/slipperystonework-metalness.png")
            segment.firstMaterial?.normal.contents = UIImage(named: "Media.scnassets/slipperystonework-normal.png")
            segment.firstMaterial?.roughness.contents = UIImage(named: "Media.scnassets/slipperystonework-rough.png")
        }
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
                               maskOutsets:CGFloat = 0.002,
                               maskXUpperSide:Bool = true) -> SCNNode {
        let node = SCNNode()
        
        let wallSegment = SCNBox(width: Nodes.WALL_WIDTH,
                                 height: height,
                                 length: length,
                                 chamferRadius: 0)
        //wallSegment.firstMaterial?.diffuse.contents = UIImage(named: "Media.scnassets/horizon.jpg")
        
        wallSegment.firstMaterial?.lightingModel = .physicallyBased
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
                                 length: length + maskOutsets * 2,
                                 chamferRadius: 0)
        maskingWallSegment.firstMaterial?.diffuse.contents = UIColor.red
        maskingWallSegment.firstMaterial?.transparency = 0.000001
        maskingWallSegment.firstMaterial?.writesToDepthBuffer = true
        
        let maskingWallSegmentNode = SCNNode(geometry: maskingWallSegment)
        maskingWallSegmentNode.renderingOrder = 100   //everything inside the portal area must have higher rendering order...
        
        
        maskingWallSegmentNode.position = SCNVector3(maskXUpperSide ? Nodes.WALL_WIDTH + maskOutsets : -(Nodes.WALL_WIDTH + maskOutsets),0,0)
        node.addChildNode(maskingWallSegmentNode)
        
        return node
    }
}
