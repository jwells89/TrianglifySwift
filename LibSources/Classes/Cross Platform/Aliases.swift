//
//  File.swift
//  
//
//  Created by John Wells on 8/22/20.
//

#if os(macOS)
import AppKit

public typealias Color = NSColor

#else
import UIKit

public typealias Color = UIColor
#endif

