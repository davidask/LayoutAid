#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

public struct Edges {

    #if canImport(UIKit)

    public typealias Insets = UIEdgeInsets

    public typealias Edge = UIRectEdge

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

    public typealias Insets = NSEdgeInsets

    public typealias Edge = Set<NSRectEdge>

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

extension Edges: LayoutConstraintsGenerator {

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
    public init(_ edge: Edge = Edge.Element.all, equalTo item: LayoutItem, insets: Insets = .zero) {
        self.init(edge, .equal, to: item, insets: insets)
    }

    public init(_ edge: Edge = Edge.Element.all, outsideOrEqualTo item: LayoutItem, insets: Insets = .zero) {
        self.init(edge, .greaterThanOrEqual, to: item, insets: insets)
    }

    public init(_ edge: Edge = Edge.Element.all, insideOrEqualTo item: LayoutItem, insets: Insets = .zero) {
        self.init(edge, .lessThanOrEqual, to: item, insets: insets)
    }

    #endif

    private func makeEqualEdgeInsetsConstraints(for item: LayoutItem, insets: Insets) -> [NSLayoutConstraint] {
        item.anchor {
            Left(equalTo: secondItem.leftAnchor, constant: insets.left)
            Right(equalTo: secondItem.rightAnchor, constant: -insets.right)
            Top(equalTo: secondItem.topAnchor, constant: insets.top)
            Bottom(equalTo: secondItem.bottomAnchor, constant: -insets.bottom)
        }
    }

    private func makeGreaterThanOrEqualEdgeInsetsConstraints(
        for item: LayoutItem, insets: Insets
    ) -> [NSLayoutConstraint] {
        item.anchor {
            Left(lessThanOrEqualTo: secondItem.leftAnchor, constant: insets.left)
            Right(greaterThanOrEqualTo: secondItem.rightAnchor, constant: -insets.right)
            Top(lessThanOrEqualTo: secondItem.topAnchor, constant: insets.top)
            Bottom(greaterThanOrEqualTo: secondItem.bottomAnchor, constant: -insets.bottom)
        }
    }

    private func makeLessThanOrEqualEdgeInsetsConstraints(
        for item: LayoutItem, insets: Insets
    ) -> [NSLayoutConstraint] {

        item.anchor {
            Left(greaterThanOrEqualTo: secondItem.leftAnchor, constant: insets.left)
            Right(lessThanOrEqualTo: secondItem.rightAnchor, constant: -insets.right)
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
            Left(equalToSystemSpacingAfter: secondItem.leftAnchor, multiplier: multiplier)
            Right(equalToSystemSpacingAfter: secondItem.rightAnchor, multiplier: -multiplier)
            Top(equalToSystemSpacingBelow: secondItem.topAnchor, multiplier: multiplier)
            Bottom(equalToSystemSpacingBelow: secondItem.bottomAnchor, multiplier: -multiplier)
        }
    }

    private func makeLessThanOrEqualSystemSpacingInsetConstraints(
        for item: LayoutItem,
        multiplier: CGFloat
    ) -> [NSLayoutConstraint] {
        item.anchor {
            Left(greaterThanOrEqualToSystemSpacingAfter: secondItem.leftAnchor, multiplier: multiplier)
            Right(lessThanOrEqualToSystemSpacingAfter: secondItem.rightAnchor, multiplier: -multiplier)
            Top(greaterThanOrEqualToSystemSpacingBelow: secondItem.topAnchor, multiplier: multiplier)
            Bottom(lessThanOrEqualToSystemSpacingBelow: secondItem.bottomAnchor, multiplier: -multiplier)
        }
    }

    private func makeGreaterThanOrEqualSystemSpacingInsetConstraints(
        for item: LayoutItem,
        multiplier: CGFloat
    ) -> [NSLayoutConstraint] {
        item.anchor {
            Left(lessThanOrEqualToSystemSpacingAfter: secondItem.leftAnchor, multiplier: multiplier)
            Right(greaterThanOrEqualToSystemSpacingAfter: secondItem.rightAnchor, multiplier: -multiplier)
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

#if os(macOS)
public extension Edges.Insets {
    static var zero: Edges.Insets {
        Edges.Insets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
#endif

#if canImport(UIKit)
public extension Edges.Edge {

    static var vertical: Edges.Edge {
        [.top, .bottom]
    }

    static var horizontal: Edges.Edge {
        [.left, .right]
    }
}
#elseif os(macOS)
public extension NSRectEdge {
    static var all: Set<NSRectEdge> {
        NSRectEdge.horizontal.union(NSRectEdge.vertical)
    }

    static var vertical: Set<NSRectEdge> {
        [.minY, .maxY]
    }

    static var horizontal: Set<NSRectEdge> {
        [.minX, .minY]
    }
}
#endif
