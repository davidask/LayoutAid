#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

@available(macOS 15.15, iOS 13, macCatalyst 13, tvOS 13, *)
public struct DirectionalEdges {

    #if canImport(UIKit)

    public typealias Insets = NSDirectionalEdgeInsets

    public typealias Edge = UIDirectionalRectEdge

    private enum InsetsType {
        case edgeInsets(Insets)
        case systemSpacing(_ multiplier: CGFloat)
    }

    private let insets: InsetsType

    private init(_ edge: Edge, _ relation: NSLayoutConstraint.Relation, to item: LayoutItem, insets: InsetsType) {
        self.edge = edge
        self.relation = relation
        self.secondItem = item
        self.insets = insets
    }

    #else

    public typealias Insets = NSDirectionalEdgeInsets

    public typealias Edge = NSDirectionalRectEdge

    private let insets: Insets

    private init(_ edge: Edge, _ relation: NSLayoutConstraint.Relation, to item: LayoutItem, insets: Insets) {
        self.edge = edge
        self.relation = relation
        self.secondItem = item
        self.insets = insets
    }

    #endif

    public var priority: NSLayoutConstraint.Priority = .required

    private let relation: NSLayoutConstraint.Relation

    public let edge: Edge

    public var secondItem: LayoutItem
}

@available(macOS 15.15, iOS 13, macCatalyst 13, tvOS 13, *)
extension DirectionalEdges: LayoutConstraintsGenerator {

    #if canImport(UIKit)
    public init(_ edge: Edge = .all, equalTo item: LayoutItem, insets: Insets = .zero) {
        self.init(edge, .equal, to: item, insets: .edgeInsets(insets))
    }

    public init(_ edge: Edge = .all, outsideOrEqualTo item: LayoutItem, insets: Insets = .zero) {
        self.init(edge, .greaterThanOrEqual, to: item, insets: .edgeInsets(insets))
    }

    public init(_ edge: Edge = .all, insideOrEqualTo item: LayoutItem, insets: Insets = .zero) {
        self.init(edge, .lessThanOrEqual, to: item, insets: .edgeInsets(insets))
    }

    public init(_ edge: Edge = .all, equalTo item: LayoutItem, insetBySystemSpacingMultipliedBy multiplier: CGFloat) {
        self.init(edge, .equal, to: item, insets: .systemSpacing(multiplier))
    }

    public init(
        _ edge: Edge = .all,
        outsideOrEqualTo item: LayoutItem,
        insetBySystemSpacingMultipliedBy multiplier: CGFloat
    ) {
        self.init(edge, .greaterThanOrEqual, to: item, insets: .systemSpacing(multiplier))
    }

    public init(
        _ edge: Edge = .all,
        insideOrEqualTo item: LayoutItem,
        insetBySystemSpacingMultipliedBy multiplier: CGFloat
    ) {
        self.init(edge, .lessThanOrEqual, to: item, insets: .systemSpacing(multiplier))
    }
    #else
    public init(_ edge: Edge = .all, equalTo item: LayoutItem, insets: Insets = .zero) {
        self.init(edge, .equal, to: item, insets: insets)
    }

    public init(_ edge: Edge = .all, outsideOrEqualTo item: LayoutItem, insets: Insets = .zero) {
        self.init(edge, .greaterThanOrEqual, to: item, insets: insets)
    }

    public init(_ edge: Edge = .all, insideOrEqualTo item: LayoutItem, insets: Insets = .zero) {
        self.init(edge, .lessThanOrEqual, to: item, insets: insets)
    }

    #endif

    private func makeEqualEdgeInsetsConstraints(for item: LayoutItem, insets: Insets) -> [NSLayoutConstraint] {
        item.anchor {
            if edge.contains(.leading) {
                Leading(equalTo: secondItem.leadingAnchor, constant: insets.leading)
            }

            if edge.contains(.trailing) {
                Trailing(equalTo: secondItem.trailingAnchor, constant: -insets.trailing)
            }

            if edge.contains(.top) {
                Top(equalTo: secondItem.topAnchor, constant: insets.top)
            }

            if edge.contains(.bottom) {
                Bottom(equalTo: secondItem.bottomAnchor, constant: -insets.bottom)
            }
        }
    }

    private func makeGreaterThanOrEqualEdgeInsetsConstraints(
        for item: LayoutItem, insets: Insets
    ) -> [NSLayoutConstraint] {
        item.anchor {
            if edge.contains(.leading) {
                Leading(lessThanOrEqualTo: secondItem.leadingAnchor, constant: insets.leading)
            }

            if edge.contains(.trailing) {
                Trailing(greaterThanOrEqualTo: secondItem.trailingAnchor, constant: -insets.trailing)
            }

            if edge.contains(.top) {
            Top(lessThanOrEqualTo: secondItem.topAnchor, constant: insets.top)
            }

            if edge.contains(.bottom) {
                Bottom(greaterThanOrEqualTo: secondItem.bottomAnchor, constant: -insets.bottom)
            }
        }
    }

    private func makeLessThanOrEqualEdgeInsetsConstraints(
        for item: LayoutItem, insets: Insets
    ) -> [NSLayoutConstraint] {

        item.anchor {
            if edge.contains(.leading) {
                Leading(greaterThanOrEqualTo: secondItem.leadingAnchor, constant: insets.leading)
            }

            if edge.contains(.trailing) {
                Trailing(lessThanOrEqualTo: secondItem.trailingAnchor, constant: -insets.trailing)
            }

            if edge.contains(.top) {
                Top(greaterThanOrEqualTo: secondItem.topAnchor, constant: insets.top)
            }

            if edge.contains(.bottom) {
                Bottom(lessThanOrEqualTo: secondItem.bottomAnchor, constant: -insets.bottom)
            }
        }
    }

    #if canImport(UIKit)
    private func makeEqualSystemSpacingInsetConstraints(
        for item: LayoutItem,
        multiplier: CGFloat
    ) -> [NSLayoutConstraint] {
        item.anchor {
            if edge.contains(.leading) {
                Leading(equalToSystemSpacingAfter: secondItem.leadingAnchor, multiplier: multiplier)
            }

            if edge.contains(.trailing) {
                Trailing(equalToSystemSpacingAfter: secondItem.trailingAnchor, multiplier: -multiplier)
            }

            if edge.contains(.top) {
                Top(equalToSystemSpacingBelow: secondItem.topAnchor, multiplier: multiplier)
            }

            if edge.contains(.bottom) {
                Bottom(equalToSystemSpacingBelow: secondItem.bottomAnchor, multiplier: -multiplier)
            }
        }
    }

    private func makeLessThanOrEqualSystemSpacingInsetConstraints(
        for item: LayoutItem,
        multiplier: CGFloat
    ) -> [NSLayoutConstraint] {
        item.anchor {
            if edge.contains(.leading) {
                Leading(greaterThanOrEqualToSystemSpacingAfter: secondItem.leadingAnchor, multiplier: multiplier)
            }
            if edge.contains(.trailing) {
                Trailing(lessThanOrEqualToSystemSpacingAfter: secondItem.trailingAnchor, multiplier: -multiplier)
            }
            if edge.contains(.top) {
                Top(greaterThanOrEqualToSystemSpacingBelow: secondItem.topAnchor, multiplier: multiplier)
            }
            if edge.contains(.bottom) {
                Bottom(lessThanOrEqualToSystemSpacingBelow: secondItem.bottomAnchor, multiplier: -multiplier)
            }
        }
    }

    private func makeGreaterThanOrEqualSystemSpacingInsetConstraints(
        for item: LayoutItem,
        multiplier: CGFloat
    ) -> [NSLayoutConstraint] {
        item.anchor {
            if edge.contains(.leading) {
                Leading(lessThanOrEqualToSystemSpacingAfter: secondItem.leadingAnchor, multiplier: multiplier)
            }

            if edge.contains(.trailing) {
                Trailing(greaterThanOrEqualToSystemSpacingAfter: secondItem.trailingAnchor, multiplier: -multiplier)
            }

            if edge.contains(.top) {
                Top(lessThanOrEqualToSystemSpacingBelow: secondItem.topAnchor, multiplier: multiplier)
            }

            if edge.contains(.bottom) {
                Bottom(greaterThanOrEqualToSystemSpacingBelow: secondItem.bottomAnchor, multiplier: -multiplier)
            }
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
