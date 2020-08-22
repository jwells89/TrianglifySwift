//
//  Edge.swift
//  DelaunaySwift
//
//  Created by Alex Littlejohn on 2016/04/07.
//  Copyright © 2016 zero. All rights reserved.
//

#if os(macOS)
    import AppKit
#else
    import UIKit
#endif

struct Edge: Hashable, Equatable {
    let vertex1: Vertex
    let vertex2: Vertex
}
