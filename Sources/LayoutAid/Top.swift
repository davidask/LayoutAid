#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

public struct Top: YAxisConstraintsGenerator {

    public var secondAnchor: NSLayoutYAxisAnchor

    public var priority: NSLayoutConstraint.Priority = .required

    public let relation: NSLayoutConstraint.Relation

    #if canImport(UIKit)

    public let offset: AxisConstraintOffset

    public init(
        _ relation: NSLayoutConstraint.Relation,
        to secondAnchor: NSLayoutYAxisAnchor,
        offset: AxisConstraintOffset
    ) {
        self.secondAnchor = secondAnchor
        self.offset = offset
        self.relation = relation
    }

    public static func firstAnchorKeyPath(
        for offset: AxisConstraintOffset
    ) -> KeyPath<LayoutItem, NSLayoutYAxisAnchor> {
        switch offset {
        case .constant:
            return \.topAnchor
        case .systemSpacing:
            return \.bottomAnchor
        }
    }

    #else

    public let constant: CGFloat

    public init(
        _ relation: NSLayoutConstraint.Relation,
        to secondAnchor: NSLayoutYAxisAnchor,
        constant: CGFloat
    ) {
        self.secondAnchor = secondAnchor
        self.constant = constant
        self.relation = relation
    }

    public static var firstAnchorKeyPath: KeyPath<LayoutItem, NSLayoutYAxisAnchor> = \.topAnchor

    #endif
}
