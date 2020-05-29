#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

public struct Center: LayoutConstraintsGenerator {

    public var priority: NSLayoutConstraint.Priority = .required

    public let secondItem: LayoutItem

    public let offset: CGSize

    public init(equalTo item: LayoutItem, offset: CGSize = .zero) {
        self.secondItem = item
        self.offset = offset
    }
}

public extension Center {
    func makeConstraints(for item: LayoutItem) -> [NSLayoutConstraint] {

        return [
            item.centerXAnchor.constraint(equalTo: secondItem.centerXAnchor, constant: offset.width),
            item.centerYAnchor.constraint(equalTo: secondItem.centerYAnchor, constant: offset.height)
        ].setPriority(priority)
    }
}
