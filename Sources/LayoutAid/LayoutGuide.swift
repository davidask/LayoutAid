#if canImport(UIKit)
import UIKit
public typealias LayoutGuide = UILayoutGuide
#elseif canImport(AppKit)
import AppKit
public typealias LayoutGuide = NSLayoutGuide
#endif
