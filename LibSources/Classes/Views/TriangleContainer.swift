//
//  TrianglesView.swift
//  TrianglifySwift
//
//  Created by Bohdan Orlov on 29/09/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

#if os(macOS)
import AppKit

open class TriangleContainer: NSView {
    public var trianglesStyle: Style?
    public private(set) var triangleViews = [TriangleView]()

    open override func layout() {
        super.layout()
        self.generateTriangles()
    }

    open func generateTriangles() {
        self.removeTriangles()
        let verticesConfig = VerticesGenerator.Configuration(size: self.bounds.size)
        let vertices = VerticesGenerator.generate(configuration: verticesConfig)
        let triangles = Delaunay.triangulate(vertices)
        let style = self.trianglesStyle ?? Style()
        for triangle in triangles {
            let triangleView = TriangleView(triangle:triangle, style: style)
            self.triangleViews.append(triangleView)
            self.addSubview(triangleView)
        }
    }

    open func removeTriangles() {
        for triangleView in self.triangleViews {
            triangleView.removeFromSuperview()
        }
        self.triangleViews.removeAll()
    }
}
#else
import UIKit

open class TriangleContainer: UIView {
    public var trianglesStyle: Style?
    public private(set) var triangleViews = [TriangleView]()

    open override func layoutSubviews() {
        super.layoutSubviews()
        self.generateTriangles()
    }

    open func generateTriangles() {
        self.removeTriangles()
        let verticesConfig = VerticesGenerator.Configuration(size: self.bounds.size)
        let vertices = VerticesGenerator.generate(configuration: verticesConfig)
        let triangles = Delaunay.triangulate(vertices)
        let style = self.trianglesStyle ?? Style()
        for triangle in triangles {
            let triangleView = TriangleView(triangle:triangle, style: style)
            self.triangleViews.append(triangleView)
            self.addSubview(triangleView)
        }
    }

    open func removeTriangles() {
        for triangleView in self.triangleViews {
            triangleView.removeFromSuperview()
        }
        self.triangleViews.removeAll()
    }
}
#endif
