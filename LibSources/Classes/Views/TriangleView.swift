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
    public var triangleLayer: TriangleLayer {
        return self.layer as! TriangleLayer
    }
    
    public var action: Selector?
    public var target: AnyObject?
    
    public init(triangle: Triangle, style: Style = Style()) {
        self.triangle = triangle
        self.style = style
        super.init(frame: CGRect.zero)
        self.layer = CAShapeLayer()
        self.configure()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        if self.superview != nil {
            triangleLayer.style()
        }
    }
    
    public override func mouseUp(with event: NSEvent) {
        super.mouseUp(with: event)
        
        guard let action = action, let target = target else { return }
        
        _ = target.perform(action, with: self)
    }
    
    public func configure() {
        triangleLayer.triangle = triangle
        triangleLayer.triangleStyle = style
        triangleLayer.configure()
        frame = triangleLayer.frame
    }
}

#else
import UIKit

open class TriangleView: UIView {
    var triangle: Triangle
    var style: Style
    
    public var triangleLayer: TriangleLayer {
        return self.layer as! TriangleLayer
    }
    
    open override class var layerClass: AnyClass { return TriangleLayer.self }

    public init(triangle: Triangle, style: Style = Style()) {
        self.triangle = triangle
        self.style = style
        super.init(frame: CGRect.zero)
        self.configure()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return self.triangleLayer.path!.contains(point)
    }

    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if superview != nil {
            triangleLayer.style()
        }
    }
    
    public func configure() {
        triangleLayer.triangle = triangle
        triangleLayer.triangleStyle = style
        triangleLayer.configure()
        frame = triangleLayer.frame
    }
}
#endif

extension TriangleView: TriangleRenderer {
    
}
