#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

public struct Height: DimensionConstraintsGenerator {

    public static let anchorKeyPath: KeyPath<LayoutItem, NSLayoutDimension> = \.heightAnchor

    public let secondAnchor: NSLayoutDimension?

    public let relation: NSLayoutConstraint.Relation

    public let constant: CGFloat

    public let multiplier: CGFloat

    public var priority: NSLayoutConstraint.Priority = .required

    public init(_ relation: NSLayoutConstraint.Relation, to constant: CGFloat) {
        self.relation = relation
        self.constant = constant
        self.secondAnchor = nil
        self.multiplier = 1
    }

    public init(
        _ relation: NSLayoutConstraint.Relation,
        to secondAnchor: NSLayoutDimension,
        multiplier: CGFloat,
        constant: CGFloat
    ) {
        self.relation = relation
        self.constant = constant
        self.secondAnchor = secondAnchor
        self.multiplier = multiplier
    }
}
