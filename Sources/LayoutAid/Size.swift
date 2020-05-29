#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

public struct Size: LayoutConstraintsGenerator {

    public var priority: NSLayoutConstraint.Priority = .required

    public let secondItem: LayoutItem?

    public let constant: CGSize

    public let relation: NSLayoutConstraint.Relation

    public let multiplier: CGFloat

    public init(_ relation: NSLayoutConstraint.Relation, to item: LayoutItem, multiplier: CGFloat, constant: CGSize) {
        self.relation = relation
        self.secondItem = item
        self.constant = constant
        self.multiplier = multiplier
    }

    public init(_ relation: NSLayoutConstraint.Relation, to constant: CGSize) {
        self.relation = relation
        self.secondItem = nil
        self.constant = constant
        self.multiplier = 1
    }

    public init(equalTo item: LayoutItem, multiplier: CGFloat = 1, constant: CGSize = .zero) {
        self.init(.equal, to: item, multiplier: multiplier, constant: constant)
    }

    public init(greaterThanOrEqualTo item: LayoutItem, multiplier: CGFloat = 1, constant: CGSize = .zero) {
        self.init(.greaterThanOrEqual, to: item, multiplier: multiplier, constant: constant)
    }

    public init(lessThanOrEqualTo item: LayoutItem, multiplier: CGFloat = 1, constant: CGSize = .zero) {
        self.init(.lessThanOrEqual, to: item, multiplier: multiplier, constant: constant)
    }

    public init(equalTo constant: CGSize) {
        self.init(.equal, to: constant)
    }

    public init(greaterThanOrEqualTo constant: CGSize) {
        self.init(.greaterThanOrEqual, to: constant)
    }

    public init(lessThanOrEqualTo constant: CGSize) {
        self.init(.lessThanOrEqual, to: constant)
    }
}

public extension Size {

    private func makeEqualConstraints(for item: LayoutItem) -> [NSLayoutConstraint] {
        guard let secondItem = secondItem else {
            return [
                item.widthAnchor.constraint(equalToConstant: constant.width),
                item.heightAnchor.constraint(equalToConstant: constant.height)
            ]
        }

        return [
            item.widthAnchor.constraint(
                equalTo: secondItem.widthAnchor,
                multiplier: multiplier,
                constant: constant.width
            ),
            item.heightAnchor.constraint(
                equalTo: secondItem.heightAnchor,
                multiplier: multiplier,
                constant: constant.height
            )
        ]
    }

    private func makeLessThanOrEqualConstraints(for item: LayoutItem) -> [NSLayoutConstraint] {
        guard let secondItem = secondItem else {
            return [
                item.widthAnchor.constraint(lessThanOrEqualToConstant: constant.width),
                item.heightAnchor.constraint(lessThanOrEqualToConstant: constant.height)
            ]
        }

        return [
            item.widthAnchor.constraint(
                lessThanOrEqualTo: secondItem.widthAnchor,
                multiplier: multiplier,
                constant: constant.width
            ),
            item.heightAnchor.constraint(
                lessThanOrEqualTo: secondItem.heightAnchor,
                multiplier: multiplier,
                constant: constant.height
            )
        ]
    }

    private func makeGreaterThanOrEqualConstraints(for item: LayoutItem) -> [NSLayoutConstraint] {
        guard let secondItem = secondItem else {
            return [
                item.widthAnchor.constraint(greaterThanOrEqualToConstant: constant.width),
                item.heightAnchor.constraint(greaterThanOrEqualToConstant: constant.height)
            ]
        }

        return [
            item.widthAnchor.constraint(
                greaterThanOrEqualTo: secondItem.widthAnchor,
                multiplier: multiplier,
                constant: constant.width
            ),
            item.heightAnchor.constraint(
                greaterThanOrEqualTo: secondItem.heightAnchor,
                multiplier: multiplier,
                constant: constant.height
            )
        ]
    }

    func makeConstraints(for item: LayoutItem) -> [NSLayoutConstraint] {

        let constraints: [NSLayoutConstraint]

        switch relation {
        case .equal:
            constraints = makeEqualConstraints(for: item)
        case .lessThanOrEqual:
            constraints = makeLessThanOrEqualConstraints(for: item)
        case .greaterThanOrEqual:
            constraints = makeGreaterThanOrEqualConstraints(for: item)
        @unknown default:
            fatalError("Unhandled case \(relation)")
        }

        return constraints.setPriority(priority)
    }
}
