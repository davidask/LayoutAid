#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

public protocol LayoutItem {

    var leadingAnchor: NSLayoutXAxisAnchor { get }

    var trailingAnchor: NSLayoutXAxisAnchor { get }

    var leftAnchor: NSLayoutXAxisAnchor { get }

    var rightAnchor: NSLayoutXAxisAnchor { get }

    var topAnchor: NSLayoutYAxisAnchor { get }

    var bottomAnchor: NSLayoutYAxisAnchor { get }

    var centerXAnchor: NSLayoutXAxisAnchor { get }

    var centerYAnchor: NSLayoutYAxisAnchor { get }

    var widthAnchor: NSLayoutDimension { get }

    var heightAnchor: NSLayoutDimension { get }
}

extension LayoutAidView: LayoutItem {}
extension LayoutAidGuide: LayoutItem {}

public extension LayoutItem {

    func anchor(
        @LayoutConstraintsGeneratorBuilder _ content: () -> [LayoutConstraintsGenerator]) -> [NSLayoutConstraint] {
        content().flatMap { generator in
            generator.makeConstraints(for: self)
        }
    }

    func anchor(_ generator: LayoutConstraintsGenerator) -> [NSLayoutConstraint] {
        generator.makeConstraints(for: self)
    }
}
