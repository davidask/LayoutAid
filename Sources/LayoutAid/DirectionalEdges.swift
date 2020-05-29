#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

@available(macOS 15.15, iOS 11, macCatalyst 13, *)
public struct DirectionalEdges {

    #if canImport(UIKit)
    private enum InsetsType {
        case edgeInsets(NSDirectionalEdgeInsets)
        case systemSpacing(_ multiplier: CGFloat)
    }

    private let insets: InsetsType

    private init(_ relation: NSLayoutConstraint.Relation, to item: LayoutItem, insets: InsetsType) {
        self.relation = relation
        self.secondItem = item
        self.insets = insets
    }

    #else

    private let insets: NSDirectionalEdgeInsets

    private init(_ relation: NSLayoutConstraint.Relation, to item: LayoutItem, insets: NSDirectionalEdgeInsets) {
        self.relation = relation
        self.secondItem = item
        self.insets = insets
    }

    #endif

    public var priority: NSLayoutConstraint.Priority = .required

    private let relation: NSLayoutConstraint.Relation

    public var secondItem: LayoutItem
}

@available(macOS 15.15, iOS 11, macCatalyst 13, *)
extension DirectionalEdges: LayoutConstraintsGenerator {

    #if canImport(UIKit)
    public init(equalTo item: LayoutItem, insets: NSDirectionalEdgeInsets = .zero) {
        self.init(.equal, to: item, insets: .edgeInsets(insets))
    }

    public init(outsideOrEqualTo item: LayoutItem, insets: NSDirectionalEdgeInsets = .zero) {
        self.init(.greaterThanOrEqual, to: item, insets: .edgeInsets(insets))
    }

    public init(insideOrEqualTo item: LayoutItem, insets: NSDirectionalEdgeInsets = .zero) {
        self.init(.lessThanOrEqual, to: item, insets: .edgeInsets(insets))
    }

    public init(equalTo item: LayoutItem, insetBySystemSpacingMultipliedBy multiplier: CGFloat) {
        self.init(.equal, to: item, insets: .systemSpacing(multiplier))
    }

    public init(outsideOrEqualTo item: LayoutItem, insetBySystemSpacingMultipliedBy multiplier: CGFloat) {
        self.init(.greaterThanOrEqual, to: item, insets: .systemSpacing(multiplier))
    }

    public init(insideOrEqualTo item: LayoutItem, insetBySystemSpacingMultipliedBy multiplier: CGFloat) {
        self.init(.lessThanOrEqual, to: item, insets: .systemSpacing(multiplier))
    }
    #else
    public init(equalTo item: LayoutItem, insets: NSDirectionalEdgeInsets = .zero) {
        self.init(.equal, to: item, insets: insets)
    }

    public init(outsideOrEqualTo item: LayoutItem, insets: NSDirectionalEdgeInsets = .zero) {
        self.init(.greaterThanOrEqual, to: item, insets: insets)
    }

    public init(insideOrEqualTo item: LayoutItem, insets: NSDirectionalEdgeInsets = .zero) {
        self.init(.lessThanOrEqual, to: item, insets: insets)
    }

    #endif

    private func makeEqualEdgeInsetsConstraints(
        for item: LayoutItem,
        insets: NSDirectionalEdgeInsets
    ) -> [NSLayoutConstraint] {
        item.anchor {
            Leading(equalTo: secondItem.leadingAnchor, constant: insets.leading)
            Trailing(equalTo: secondItem.trailingAnchor, constant: -insets.trailing)
            Top(equalTo: secondItem.topAnchor, constant: insets.top)
            Bottom(equalTo: secondItem.bottomAnchor, constant: -insets.bottom)
        }
    }

    private func makeGreaterThanOrEqualEdgeInsetsConstraints(
        for item: LayoutItem, insets: NSDirectionalEdgeInsets
    ) -> [NSLayoutConstraint] {
        item.anchor {
            Leading(lessThanOrEqualTo: secondItem.leadingAnchor, constant: insets.leading)
            Trailing(greaterThanOrEqualTo: secondItem.leadingAnchor, constant: -insets.trailing)
            Top(lessThanOrEqualTo: secondItem.topAnchor, constant: insets.top)
            Bottom(greaterThanOrEqualTo: secondItem.bottomAnchor, constant: -insets.bottom)
        }
    }

    private func makeLessThanOrEqualEdgeInsetsConstraints(
        for item: LayoutItem, insets: NSDirectionalEdgeInsets
    ) -> [NSLayoutConstraint] {

        item.anchor {
            Leading(greaterThanOrEqualTo: secondItem.leadingAnchor, constant: insets.leading)
            Trailing(lessThanOrEqualTo: secondItem.trailingAnchor, constant: -insets.trailing)
            Top(greaterThanOrEqualTo: secondItem.topAnchor, constant: insets.top)
            Bottom(lessThanOrEqualTo: secondItem.bottomAnchor, constant: -insets.bottom)
        }
    }

    #if canImport(UIKit)
    private func makeEqualSystemSpacingInsetConstraints(
        for item: LayoutItem,
        multiplier: CGFloat
    ) -> [NSLayoutConstraint] {
        item.anchor {
            Leading(equalToSystemSpacingAfter: secondItem.leadingAnchor, multiplier: multiplier)
            Trailing(equalToSystemSpacingAfter: secondItem.trailingAnchor, multiplier: -multiplier)
            Top(equalToSystemSpacingBelow: secondItem.topAnchor, multiplier: multiplier)
            Bottom(equalToSystemSpacingBelow: secondItem.bottomAnchor, multiplier: -multiplier)
        }
    }

    private func makeLessThanOrEqualSystemSpacingInsetConstraints(
        for item: LayoutItem,
        multiplier: CGFloat
    ) -> [NSLayoutConstraint] {
        item.anchor {
            Leading(greaterThanOrEqualToSystemSpacingAfter: secondItem.leadingAnchor, multiplier: multiplier)
            Trailing(lessThanOrEqualToSystemSpacingAfter: secondItem.trailingAnchor, multiplier: -multiplier)
            Top(greaterThanOrEqualToSystemSpacingBelow: secondItem.topAnchor, multiplier: multiplier)
            Bottom(lessThanOrEqualToSystemSpacingBelow: secondItem.bottomAnchor, multiplier: -multiplier)
        }
    }

    private func makeGreaterThanOrEqualSystemSpacingInsetConstraints(
        for item: LayoutItem,
        multiplier: CGFloat
    ) -> [NSLayoutConstraint] {
        item.anchor {
            Leading(lessThanOrEqualToSystemSpacingAfter: secondItem.leadingAnchor, multiplier: multiplier)
            Trailing(greaterThanOrEqualToSystemSpacingAfter: secondItem.trailingAnchor, multiplier: -multiplier)
            Top(lessThanOrEqualToSystemSpacingBelow: secondItem.topAnchor, multiplier: multiplier)
            Bottom(greaterThanOrEqualToSystemSpacingBelow: secondItem.bottomAnchor, multiplier: -multiplier)
        }
    }
    #endif

    private func makeEqualConstraints(
        for item: LayoutItem
    ) -> [NSLayoutConstraint] {

        #if canImport(UIKIt)
        switch insets {
        case let .edgeInsets(insets):
            return makeEqualEdgeInsetsConstraints(for: item, insets: insets)
        case let .systemSpacing(multiplier):
            return makeEqualSystemSpacingInsetConstraints(for: item, multiplier: multiplier)
        }
        #else
        return makeEqualEdgeInsetsConstraints(for: item, insets: insets)
        #endif
    }

    private func makeGreaterThanOrEqualConstraints(
        for item: LayoutItem
    ) -> [NSLayoutConstraint] {

        #if canImport(UIKit)
        switch insets {
        case let .edgeInsets(insets):
            return makeGreaterThanOrEqualEdgeInsetsConstraints(for: item, insets: insets)
        case let .systemSpacing(multiplier):
            return makeGreaterThanOrEqualSystemSpacingInsetConstraints(for: item, multiplier: multiplier)
        }
        #else
        return makeGreaterThanOrEqualEdgeInsetsConstraints(for: item, insets: insets)
        #endif
    }

    private func makeLessThanOrEqualConstraints(
        for item: LayoutItem
    ) -> [NSLayoutConstraint] {

        #if canImport(UIKit)
        switch insets {
        case let .edgeInsets(insets):
            return makeLessThanOrEqualEdgeInsetsConstraints(for: item, insets: insets)
        case let .systemSpacing(multiplier):
            return makeLessThanOrEqualSystemSpacingInsetConstraints(for: item, multiplier: multiplier)
        }
        #else
        return makeLessThanOrEqualEdgeInsetsConstraints(for: item, insets: insets)
        #endif
    }

    public func makeConstraints(for item: LayoutItem) -> [NSLayoutConstraint] {

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

@available(macOS 15.15, iOS 11, macCatalyst 13, *)
public extension NSDirectionalEdgeInsets {
    static var zero: NSDirectionalEdgeInsets {
        NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
    }
}
