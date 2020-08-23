//
//  Style.swift
//  Pods
//
//  Created by Bohdan Orlov on 01/10/2016.
//
//

import Foundation

#if os(macOS)
import AppKit

public extension NSView {
    func relativePositionInParent() -> CGPoint {
        guard let superview = self.superview else { assert(false); return CGPoint.zero}
        let superviewWidth = superview.bounds.size.width
        let superviewHeight = superview.bounds.size.height
        let centerInBounds = CGPoint(x: min(max(0, self.frame.midX), superviewWidth), y: min(max(0, self.frame.midY), superviewHeight))
        let point = CGPoint(x: centerInBounds.x / superviewWidth, y: centerInBounds.y / superviewHeight)
        return point
    }
}
#else
import UIKit

public extension UIView {
    func relativePositionInParent() -> CGPoint {
        guard let superview = self.superview else { assert(false); return CGPoint.zero}
        let superviewWidth = superview.bounds.size.width
        let superviewHeight = superview.bounds.size.height
        let centerInBounds = CGPoint(x: min(max(0, self.center.x), superviewWidth), y: min(max(0, self.center.y), superviewHeight))
        let point = CGPoint(x: centerInBounds.x / superviewWidth, y: centerInBounds.y / superviewHeight)
        return point
    }
}

#endif

public extension CAShapeLayer {
    func relativePositionInParent() -> CGPoint {
        guard let superlayer = self.superlayer else { assert(false); return CGPoint.zero}
        let superviewWidth = superlayer.bounds.size.width
        let superviewHeight = superlayer.bounds.size.height
        let centerInBounds = CGPoint(x: min(max(0, self.frame.midX), superviewWidth), y: min(max(0, self.frame.midY), superviewHeight))
        let point = CGPoint(x: centerInBounds.x / superviewWidth, y: centerInBounds.y / superviewHeight)
        return point
    }
}

public protocol TriangleRenderer {
    func relativePositionInParent() -> CGPoint
}

extension CAShapeLayer: TriangleRenderer {
    
}

public struct Style {
    public let colorsX: [Color]
    public let colorsY: [Color]
    public let fillColorClosure: ((TriangleRenderer) -> Color)
    public let strokeColorClosure: ((TriangleRenderer) -> Color)
    public let strokeLineWidth: CGFloat

    public init(colorsX: [Color] = [Color.randomColor(), Color.randomColor(), Color.randomColor()],
                colorsY: [Color] = [Color.randomColor(), Color.randomColor(), Color.randomColor()],
                fillColorClosure: ((TriangleRenderer) -> Color)? = nil,
                strokeColorClosure: ((TriangleRenderer) -> Color)? = nil,
                strokeLineWidth: CGFloat = 0.51) {
        self.colorsX = colorsX
        self.colorsY = colorsY
        self.fillColorClosure = fillColorClosure ?? Style.gradientColorClosure(colorsX: colorsX, colorsY: colorsY)
        self.strokeColorClosure = strokeColorClosure ?? Style.gradientColorClosure(colorsX: colorsX, colorsY: colorsY)
        self.strokeLineWidth = strokeLineWidth
    }

    private static func gradientColorClosure(colorsX: [Color], colorsY: [Color]) -> (TriangleRenderer) -> Color {
        return { triangleView in
            let point = triangleView.relativePositionInParent()
            let color = Color.interpolateFrom(fromColor: Color.interpolate(colors: colorsX, progress: point.x), to: Color.interpolate(colors: colorsY, progress: point.y), withProgress: 0.5)
            return color
        }
    }
}
