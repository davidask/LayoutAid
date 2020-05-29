#if canImport(UIKit)
import UIKit
public typealias View = UIView
#elseif canImport(AppKit)
import AppKit
public typealias View = NSView
#endif

public extension View {
    var ancestors: AnyIterator<View> {

        var current = self

        return AnyIterator {
            guard let parent = current.superview else {
                return nil
            }

            current = parent
            return parent
        }
    }

    var decendants: AnyIterator<View> {
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
