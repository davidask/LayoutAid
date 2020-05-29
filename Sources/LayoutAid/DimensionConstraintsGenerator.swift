#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

public protocol DimensionConstraintsGenerator: LayoutConstraintsGenerator {

    static var anchorKeyPath: KeyPath<LayoutItem, NSLayoutDimension> { get }

    var secondAnchor: NSLayoutDimension? { get }

    var relation: NSLayoutConstraint.Relation { get }

    var constant: CGFloat { get }

    var multiplier: CGFloat { get }

    init(
        _ relation: NSLayoutConstraint.Relation,
        to secondAnchor: NSLayoutDimension,
        multiplier: CGFloat,
        constant: CGFloat
    )

    init(_ relation: NSLayoutConstraint.Relation, to constant: CGFloat)
}

public extension DimensionConstraintsGenerator {

    init(
        _ relation: NSLayoutConstraint.Relation,
        to item: LayoutItem,
        multiplier: CGFloat,
        constant: CGFloat
    ) {
        self.init(relation, to: item[keyPath: Self.anchorKeyPath], multiplier: multiplier, constant: constant)
    }

    init(equalTo anchor: NSLayoutDimension, multiplier: CGFloat = 1, constant: CGFloat = 0) {
        self.init(.equal, to: anchor, multiplier: multiplier, constant: constant)
    }

    init(equalTo item: LayoutItem, multiplier: CGFloat = 1, constant: CGFloat = 0) {
        self.init(.equal, to: item, multiplier: multiplier, constant: constant)
    }

    init(equalTo constant: CGFloat) {
        self.init(.equal, to: constant)
    }

    init(lessThanOrEqualTo anchor: NSLayoutDimension, multiplier: CGFloat = 1, constant: CGFloat = 0) {
        self.init(.lessThanOrEqual, to: anchor, multiplier: multiplier, constant: constant)
    }

    init(lessThanOrEqualTo item: LayoutItem, multiplier: CGFloat = 1, constant: CGFloat = 0) {
        self.init(.lessThanOrEqual, to: item, multiplier: multiplier, constant: constant)
    }

    init(lessThanOrEqualTo constant: CGFloat) {
        self.init(.lessThanOrEqual, to: constant)
    }

    init(greaterThanOrEqualTo anchor: NSLayoutDimension, multiplier: CGFloat = 1, constant: CGFloat = 0) {
        self.init(.greaterThanOrEqual, to: anchor, multiplier: multiplier, constant: constant)
    }

    init(greaterThanOrEqualTo item: LayoutItem, multiplier: CGFloat = 1, constant: CGFloat = 0) {
        self.init(.greaterThanOrEqual, to: item, multiplier: multiplier, constant: constant)
    }

    init(greaterThanOrEqualTo constant: CGFloat) {
        self.init(.greaterThanOrEqual, to: constant)
    }

    func makeConstraints(for item: LayoutItem) -> [NSLayoutConstraint] {

        let constraint: NSLayoutConstraint

        let firstAnchor = item[keyPath: Self.anchorKeyPath]

        switch (relation, secondAnchor) {
        case (.equal, .some(let value)):
            constraint = firstAnchor.constraint(equalTo: value, multiplier: multiplier, constant: constant)
        case (.equal, .none):
            constraint = firstAnchor.constraint(equalToConstant: constant)

        case (.lessThanOrEqual, .some(let value)):
            constraint = firstAnchor.constraint(lessThanOrEqualTo: value, multiplier: multiplier, constant: constant)
        case (.lessThanOrEqual, .none):
            constraint = firstAnchor.constraint(lessThanOrEqualToConstant: constant)

        case (.greaterThanOrEqual, .some(let value)):
            constraint = firstAnchor.constraint(greaterThanOrEqualTo: value, multiplier: multiplier, constant: constant)
        case (.greaterThanOrEqual, .none):
            constraint = firstAnchor.constraint(greaterThanOrEqualToConstant: constant)

        @unknown default:
            fatalError("Unhandled case")
        }

        constraint.priority = priority

        return [constraint]
    }
}
