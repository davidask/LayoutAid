#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

#if canImport(UIKit)
public enum AxisConstraintOffset {
    case constant(_ value: CGFloat)
    case systemSpacing(_ multiplier: CGFloat)
}
#endif

public protocol AxisConstraintsGenerator: LayoutConstraintsGenerator {
    associatedtype AnchorType: AnyObject
    associatedtype Anchor: NSLayoutAnchor<AnchorType>

    var relation: NSLayoutConstraint.Relation { get }

    var secondAnchor: Anchor { get }

    #if canImport(UIKit)

    var offset: AxisConstraintOffset { get }

    static func firstAnchorKeyPath(for offset: AxisConstraintOffset) -> KeyPath<LayoutItem, Anchor>

    init(
        _ relation: NSLayoutConstraint.Relation,
        to secondAnchor: Anchor,
        offset: AxisConstraintOffset
    )
    #else

    var constant: CGFloat { get }

    static var firstAnchorKeyPath: KeyPath<LayoutItem, Anchor> { get }

    init(
        _ relation: NSLayoutConstraint.Relation,
        to secondAnchor: Anchor,
        constant: CGFloat
    )
    #endif
}

#if canImport(UIKit)
public extension AxisConstraintsGenerator {

    // MARK: Equal

    init(
        _ relation: NSLayoutConstraint.Relation,
        to item: LayoutItem,
        offset: AxisConstraintOffset
    ) {
        self.init(
            relation,
            to: item[keyPath: Self.firstAnchorKeyPath(for: offset)],
            offset: offset
        )
    }

    init(
        equalTo secondAnchor: Anchor,
        constant: CGFloat = 0
    ) {
        self.init(.equal, to: secondAnchor, offset: .constant(constant))
    }

    init(
        equalTo item: LayoutItem,
        constant: CGFloat = 0
    ) {
        self.init(.equal, to: item, offset: .constant(constant))
    }

    // MARK: Less than or equal

    init(
        lessThanOrEqualTo secondAnchor: Anchor,
        constant: CGFloat = 0
    ) {
        self.init(.lessThanOrEqual, to: secondAnchor, offset: .constant(constant))
    }

    init(
        lessThanOrEqualTo item: LayoutItem,
        constant: CGFloat = 0
    ) {
        self.init(.lessThanOrEqual, to: item, offset: .constant(constant))
    }

    // MARK: Greater than or equal

    init(
        greaterThanOrEqualTo secondAnchor: Anchor,
        constant: CGFloat = 0
    ) {
        self.init(.greaterThanOrEqual, to: secondAnchor, offset: .constant(constant))
    }

    init(
        greaterThanOrEqualTo item: LayoutItem,
        constant: CGFloat = 0
    ) {
        self.init(.greaterThanOrEqual, to: item, offset: .constant(constant))
    }
}
#else
public extension AxisConstraintsGenerator {

    // MARK: Equal

    init(
        _ relation: NSLayoutConstraint.Relation,
        to item: LayoutItem,
        constant: CGFloat
    ) {
        self.init(
            relation,
            to: item[keyPath: Self.firstAnchorKeyPath],
            constant: constant
        )
    }

    init(
        equalTo secondAnchor: Anchor,
        constant: CGFloat = 0
    ) {
        self.init(.equal, to: secondAnchor, constant: constant)
    }

    init(
        equalTo item: LayoutItem,
        constant: CGFloat = 0
    ) {
        self.init(.equal, to: item, constant: constant)
    }

    // MARK: Less than or equal

    init(
        lessThanOrEqualTo secondAnchor: Anchor,
        constant: CGFloat = 0
    ) {
        self.init(.lessThanOrEqual, to: secondAnchor, constant: constant)
    }

    init(
        lessThanOrEqualTo item: LayoutItem,
        constant: CGFloat = 0
    ) {
        self.init(.lessThanOrEqual, to: item, constant: constant)
    }

    // MARK: Greater than or equal

    init(
        greaterThanOrEqualTo secondAnchor: Anchor,
        constant: CGFloat = 0
    ) {
        self.init(.greaterThanOrEqual, to: secondAnchor, constant: constant)
    }

    init(
        greaterThanOrEqualTo item: LayoutItem,
        constant: CGFloat = 0
    ) {
        self.init(.greaterThanOrEqual, to: item, constant: constant)
    }

    func makeConstraints(for item: LayoutItem) -> [NSLayoutConstraint] {

        let constraint: NSLayoutConstraint

        let firstAnchor = item[keyPath: Self.firstAnchorKeyPath]

        switch relation {
        case .equal:
            constraint = firstAnchor.constraint(equalTo: secondAnchor, constant: constant)

        case .lessThanOrEqual:
            constraint = firstAnchor.constraint(lessThanOrEqualTo: secondAnchor, constant: constant)

        case .greaterThanOrEqual:
            constraint = firstAnchor.constraint(greaterThanOrEqualTo: secondAnchor, constant: constant)

        @unknown default:
            fatalError("Unhandled case \(relation)")
        }

        constraint.priority = priority

        return [constraint]
    }
}
#endif
