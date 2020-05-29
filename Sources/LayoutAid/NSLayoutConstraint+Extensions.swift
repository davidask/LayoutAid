#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

public extension NSLayoutConstraint {

    #if canImport(UIKit)
    typealias Priority = UILayoutPriority
    #endif

    @_functionBuilder
    struct Builder {
        public static func buildBlock(_ components: [NSLayoutConstraint]...) -> [NSLayoutConstraint] {
            components.flatMap { component in
                component
            }
        }

        public static func buildExpression<S>(
            _ expression: S
        ) -> [NSLayoutConstraint] where S: Sequence, S.Element: NSLayoutConstraint {
            Array(expression)
        }

        public static func buildExpression(
            _ expression: NSLayoutConstraint
        ) -> [NSLayoutConstraint] {
            [expression]
        }
    }

    static func build(@Builder _ content: () -> [NSLayoutConstraint]) -> [NSLayoutConstraint] {
        content()
    }

    static func activate(@Builder _ content: () -> [NSLayoutConstraint]) {
        build(content).activate()
    }
}

public extension Sequence where Element: NSLayoutConstraint {
    func activate() {
        NSLayoutConstraint.activate(Array(self))
    }

    func deactivate() {
        NSLayoutConstraint.deactivate(Array(self))
    }

    func setPriority(_ value: NSLayoutConstraint.Priority) -> Self {
        for element in self {
            element.priority = value
        }

        return self
    }
}
