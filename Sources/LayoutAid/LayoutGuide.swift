#if canImport(UIKit)
import UIKit
public typealias LayoutAidGuide = UILayoutGuide
#elseif canImport(AppKit)
import AppKit
public typealias LayoutAidGuide = NSLayoutGuide
#endif
