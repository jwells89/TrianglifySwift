//
//  TriangleView.swift
//  TrianglifySwift
//
//  Created by Bohdan Orlov on 29/09/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

#if os(macOS)
import AppKit

public class TriangleView: NSView {
    public let triangle: Triangle
    public let style: Style
    public var triangleLayer: CAShapeLayer {
        return self.layer as! CAShapeLayer
    }
    
    public var action: Selector?
    public var target: AnyObject?
    
    public init(triangle: Triangle, style: Style = Style()) {
        self.triangle = triangle
        self.style = style
        super.init(frame: CGRect.zero)
        self.layer = CAShapeLayer()
        self.configure(layer: self.triangleLayer, for: self.triangle)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        if self.superview != nil {
            self.styleTriangleLayer()
        }
    }
    
    public override func mouseUp(with event: NSEvent) {
        super.mouseUp(with: event)
        
        guard let action = action, let target = target else { return }
        
        _ = target.perform(action, with: self)
    }
    
    public func configure(layer: CAShapeLayer, for triangle: Triangle) {
        let trianglePath = triangle.toPath()
        let triangleFrame = trianglePath.boundingBoxOfPath
        let frameOffset = CGPoint(x: -triangleFrame.origin.x, y: -triangleFrame.origin.y)
        let triangleInBounds = triangle.offsetBy(frameOffset)
        layer.path = triangleInBounds.toPath()
        layer.anchorPoint = CGPoint(x:triangleInBounds.center().x / triangleFrame.width, y:triangleInBounds.center().y / triangleFrame.height)
        self.frame = triangleFrame
    }
}

#else
import UIKit

open class TriangleView: UIView {
    public let triangle: Triangle
    public let style: Style
    public var triangleLayer: CAShapeLayer {
        return self.layer as! CAShapeLayer
    }

    public init(triangle: Triangle, style: Style = Style()) {
        self.triangle = triangle
        self.style = style
        super.init(frame: CGRect.zero)
        self.configure(layer: self.triangleLayer, for: self.triangle)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return self.triangleLayer.path!.contains(point)
    }

    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if self.superview != nil {
            self.styleTriangleLayer()
        }
    }

    open override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }
    
    public func configure(layer: CAShapeLayer, for triangle: Triangle) {
        let trianglePath = triangle.toPath()
        let triangleFrame = trianglePath.boundingBoxOfPath
        let frameOffset = CGPoint(x: -triangleFrame.origin.x, y: -triangleFrame.origin.y)
        let triangleInBounds = triangle.offsetBy(frameOffset)
        layer.path = triangleInBounds.toPath()
        layer.anchorPoint = CGPoint(x:triangleInBounds.center().x / triangleFrame.width, y:triangleInBounds.center().y / triangleFrame.height)
        self.frame = triangleFrame
    }
}
#endif

extension TriangleView {
    open func styleTriangleLayer() {
        self.triangleLayer.fillColor = self.style.fillColorClosure(self).cgColor
        self.triangleLayer.strokeColor = self.style.strokeColorClosure(self).cgColor
        self.triangleLayer.lineWidth = self.style.strokeLineWidth
        self.triangleLayer.backgroundColor = Color.clear.cgColor
    }
}
