#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

public struct AspectRatio {

    public var aspectRatio: CGFloat

    public var priority: NSLayoutConstraint.Priority

    public let relation: NSLayoutConstraint.Relation

    init(_ relation: NSLayoutConstraint.Relation, to ratio: CGFloat) {
        self.relation = relation
        self.aspectRatio = ratio
        self.priority = .required
    }

    init(equalTo ratio: CGFloat) {
        self.init(.equal, to: ratio)
    }

    init(lessThanOrEqualTo ratio: CGFloat) {
        self.init(.lessThanOrEqual, to: ratio)
    }

    init(greaterThanOrEqualTo ratio: CGFloat) {
        self.init(.greaterThanOrEqual, to: ratio)
    }
}

extension AspectRatio: LayoutConstraintsGenerator {
    public func makeConstraints(for item: LayoutItem) -> [NSLayoutConstraint] {
        let constraint: NSLayoutConstraint

        switch relation {
        case .equal:
            constraint = item.heightAnchor.constraint(equalTo: item.widthAnchor, multiplier: aspectRatio)
        case .lessThanOrEqual:
            constraint = item.heightAnchor.constraint(lessThanOrEqualTo: item.widthAnchor, multiplier: aspectRatio)
        case .greaterThanOrEqual:
            constraint = item.heightAnchor.constraint(greaterThanOrEqualTo: item.widthAnchor, multiplier: aspectRatio)
        @unknown default:
            fatalError("Unhandled case \(relation)")
        }

        constraint.priority = priority

        return [constraint]
    }
}
