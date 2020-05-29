#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

public protocol XAxisConstraintsGenerator: AxisConstraintsGenerator
where AnchorType == NSLayoutXAxisAnchor, Anchor == NSLayoutXAxisAnchor {}

#if canImport(UIKit)
public extension XAxisConstraintsGenerator {

    init(
        equalToSystemSpacingAfter secondAnchor: Anchor,
        multiplier: CGFloat = 1
    ) {
        self.init(.equal, to: secondAnchor, offset: .systemSpacing(multiplier))
    }

    init(
        equalToSystemSpacingAfter item: LayoutItem,
        multiplier: CGFloat = 1
    ) {
        self.init(.equal, to: item, offset: .systemSpacing(multiplier))
    }

    // MARK: Less than or equal

    init(
        lessThanOrEqualToSystemSpacingAfter secondAnchor: Anchor,
        multiplier: CGFloat = 1
    ) {
        self.init(.lessThanOrEqual, to: secondAnchor, offset: .systemSpacing(multiplier))
    }

    init(
        lessThanOrEqualToSystemSpacingAfter item: LayoutItem,
        multiplier: CGFloat = 1
    ) {
        self.init(.lessThanOrEqual, to: item, offset: .systemSpacing(multiplier))
    }

    // MARK: Greater than or equal

    init(
        greaterThanOrEqualToSystemSpacingAfter secondAnchor: Anchor,
        multiplier: CGFloat = 1
    ) {
        self.init(.greaterThanOrEqual, to: secondAnchor, offset: .systemSpacing(multiplier))
    }

    init(
        greaterThanOrEqualToSystemSpacingAfter item: LayoutItem,
        multiplier: CGFloat = 1
    ) {
        self.init(.greaterThanOrEqual, to: item, offset: .systemSpacing(multiplier))
    }

    func makeConstraints(for item: LayoutItem) -> [NSLayoutConstraint] {

        let constraint: NSLayoutConstraint

        let firstAnchor = item[keyPath: Self.firstAnchorKeyPath(for: offset)]

        switch (relation, offset) {
        case (.equal, .constant(let value)):
            constraint = firstAnchor.constraint(equalTo: secondAnchor, constant: value)
        case (.equal, .systemSpacing(let value)):
            constraint = firstAnchor.constraint(equalToSystemSpacingAfter: secondAnchor, multiplier: value)

        case (.lessThanOrEqual, .constant(let value)):
            constraint = firstAnchor.constraint(lessThanOrEqualTo: secondAnchor, constant: value)
        case (.lessThanOrEqual, .systemSpacing(let value)):
            constraint = firstAnchor.constraint(lessThanOrEqualToSystemSpacingAfter: secondAnchor, multiplier: value)

        case (.greaterThanOrEqual, .constant(let value)):
            constraint = firstAnchor.constraint(greaterThanOrEqualTo: secondAnchor, constant: value)
        case (.greaterThanOrEqual, .systemSpacing(let value)):
            constraint = firstAnchor.constraint(greaterThanOrEqualToSystemSpacingAfter: secondAnchor, multiplier: value)

        @unknown default:
            fatalError("Unhandled case \(relation)")
        }

        constraint.priority = priority

        return [constraint]
    }
}
#endif
