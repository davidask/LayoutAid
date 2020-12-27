#if canImport(UIKit)
import UIKit
public typealias LayoutAidView = UIView
#elseif canImport(AppKit)
import AppKit
public typealias LayoutAidView = NSView
#endif

public extension LayoutAidView {
    var ancestors: AnyIterator<LayoutAidView> {

        var current = self

        return AnyIterator {
            guard let parent = current.superview else {
                return nil
            }

            current = parent
            return parent
        }
    }

    var decendants: AnyIterator<LayoutAidView> {
        var foundSubviews = subviews

        return AnyIterator {
            guard foundSubviews.isEmpty == false else {
                return nil
            }

            let subview = foundSubviews.removeFirst()
            foundSubviews.insert(contentsOf: subview.subviews, at: 0)
            return subview
        }
    }
}
