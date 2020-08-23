//
//  TriangleView.swift
//  TrianglifySwift
//
//  Created by John Wells on 8/22/20.
//  Copyright © 2020 John Wells. All rights reserved.
//

#if os(macOS)
import AppKit
#else
import UIKit
#endif


public class TriangleLayer: CAShapeLayer {
    public var triangle: Triangle?
    public var triangleStyle: Style?
        
    /* NOTE: When using TriangleLayers without enclosing TriangleViews under macOS,
       it's necessary to call style() manually, as layoutSublayers() is only ever
       automarticlly called under iOS. */
    public override func layoutSublayers() {
        super.layoutSublayers()
        
        guard superlayer != nil else { return }
        style()
    }
    
    public func style() {
        guard let style = triangleStyle else { return }
        
        fillColor       = style.fillColorClosure(self).cgColor
        strokeColor     = style.strokeColorClosure(self).cgColor
        lineWidth       = style.strokeLineWidth
        backgroundColor = Color.clear.cgColor
    }
    
    public func configure() {
        guard let triangle = triangle else { return }
        
        let trianglePath = triangle.toPath()
        let triangleFrame = trianglePath.boundingBoxOfPath
        let frameOffset = CGPoint(x: -triangleFrame.origin.x, y: -triangleFrame.origin.y)
        let triangleInBounds = triangle.offsetBy(frameOffset)
        path = triangleInBounds.toPath()
        anchorPoint = CGPoint(x:triangleInBounds.center().x / triangleFrame.width, y:triangleInBounds.center().y / triangleFrame.height)
        self.frame = triangleFrame
    }
}
