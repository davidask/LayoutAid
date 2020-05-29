#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

public struct CenterX: XAxisConstraintsGenerator {

    public var secondAnchor: NSLayoutXAxisAnchor

    public var priority: NSLayoutConstraint.Priority = .required

    public let relation: NSLayoutConstraint.Relation

    #if canImport(UIKit)

    public let offset: AxisConstraintOffset

    public init(
        _ relation: NSLayoutConstraint.Relation,
        to secondAnchor: NSLayoutXAxisAnchor,
        offset: AxisConstraintOffset
    ) {
        self.secondAnchor = secondAnchor
        self.offset = offset
        self.relation = relation
    }

    public static func firstAnchorKeyPath(
        for offset: AxisConstraintOffset
    ) -> KeyPath<LayoutItem, NSLayoutXAxisAnchor> {
        switch offset {
        case .constant:
            return \.centerXAnchor
        case .systemSpacing:
            return \.trailingAnchor
        }
    }

    #else

    public let constant: CGFloat

    public init(_ relation: NSLayoutConstraint.Relation, to secondAnchor: NSLayoutXAxisAnchor, constant: CGFloat) {
        self.relation = relation
        self.secondAnchor = secondAnchor
        self.constant = constant
    }

    public static var firstAnchorKeyPath: KeyPath<LayoutItem, NSLayoutXAxisAnchor> = \.centerXAnchor

    #endif
}
