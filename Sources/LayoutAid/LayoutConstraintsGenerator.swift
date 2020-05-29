#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

public protocol LayoutConstraintsGenerator {

    var priority: NSLayoutConstraint.Priority { get set }

    func makeConstraints(for item: LayoutItem) -> [NSLayoutConstraint]
}

public extension LayoutConstraintsGenerator {

    func priority(_ value: NSLayoutConstraint.Priority) -> Self {
        var new = self
        new.priority = value
        return new
    }
}

@_functionBuilder
public struct LayoutConstraintsGeneratorBuilder {

    public static func buildBlock(_ component: LayoutConstraintsGenerator...) -> [LayoutConstraintsGenerator] {
        component
    }
}
