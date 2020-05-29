#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

public protocol YAxisConstraintsGenerator: AxisConstraintsGenerator
where AnchorType == NSLayoutYAxisAnchor, Anchor == NSLayoutYAxisAnchor {}

#if canImport(UIKit)
public extension YAxisConstraintsGenerator {

    init(
        equalToSystemSpacingBelow secondAnchor: Anchor,
        multiplier: CGFloat = 1
    ) {
        self.init(.equal, to: secondAnchor, offset: .systemSpacing(multiplier))
    }

    init(
        equalToSystemSpacingBelow item: LayoutItem,
        multiplier: CGFloat = 1
    ) {
        self.init(.equal, to: item, offset: .systemSpacing(multiplier))
    }

    // MARK: Less than or equal

    init(
        lessThanOrEqualToSystemSpacingBelow secondAnchor: Anchor,
        multiplier: CGFloat = 1
    ) {
        self.init(.lessThanOrEqual, to: secondAnchor, offset: .systemSpacing(multiplier))
    }

    init(
        lessThanOrEqualToSystemSpacingBelow item: LayoutItem,
        multiplier: CGFloat = 1
    ) {
        self.init(.lessThanOrEqual, to: item, offset: .systemSpacing(multiplier))
    }

    // MARK: Greater than or equal

    init(
        greaterThanOrEqualToSystemSpacingBelow secondAnchor: Anchor,
        multiplier: CGFloat = 1
    ) {
        self.init(.greaterThanOrEqual, to: secondAnchor, offset: .systemSpacing(multiplier))
    }

    init(
        greaterThanOrEqualToSystemSpacingBelow item: LayoutItem,
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
            constraint = firstAnchor.constraint(equalToSystemSpacingBelow: secondAnchor, multiplier: value)

        case (.lessThanOrEqual, .constant(let value)):
            constraint = firstAnchor.constraint(lessThanOrEqualTo: secondAnchor, constant: value)
        case (.lessThanOrEqual, .systemSpacing(let value)):
            constraint = firstAnchor.constraint(lessThanOrEqualToSystemSpacingBelow: secondAnchor, multiplier: value)

        case (.greaterThanOrEqual, .constant(let value)):
            constraint = firstAnchor.constraint(greaterThanOrEqualTo: secondAnchor, constant: value)
        case (.greaterThanOrEqual, .systemSpacing(let value)):
            constraint = firstAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: secondAnchor, multiplier: value)

        @unknown default:
            fatalError("Unhandled case \(relation)")
        }

        constraint.priority = priority

        return [constraint]
    }
}
#endif
