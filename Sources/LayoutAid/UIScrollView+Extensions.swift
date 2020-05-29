#if canImport(UIKit)
import UIKit

#if os(iOS)
public extension UIScrollView {

    private static var KeyboardObserver = "__KeyboardObserver"

    private var keyboardObserver: Keyboard.Observer? {
        get {
            return objc_getAssociatedObject(self, &UIScrollView.KeyboardObserver) as? Keyboard.Observer
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(
                    self,
                    &UIScrollView.KeyboardObserver,
                    newValue as Keyboard.Observer?,
                    .OBJC_ASSOCIATION_RETAIN_NONATOMIC
                )
            }
        }
    }

    func beginAdjustingContentInsetForKeyboard() {
        keyboardObserver = Keyboard.addObserver(for: .willChangeFrame) { [weak self] transition in
            guard let weakSelf = self else {
                return
            }

            guard let transition = transition else {
                weakSelf.adjustContentInsetForKeyboard()
                return
            }

            transition.addAnimations {
                weakSelf.adjustContentInsetForKeyboard()
            }
        }
    }

    func endAdjustingContentInsetForKeyboard() {
        keyboardObserver?.remove()
        keyboardObserver = nil
    }

    func adjustContentInsetForKeyboard() {

        var keyboardBottomInset: CGFloat

        // If the keyboard reports having a frame, calculate the appropriate insets,
        // otherwise we can safely assume that there should be no insets
        if let frame = Keyboard.frame(in: self) {
            keyboardBottomInset =
                bounds.height // Get the height of this view, i.e. the scroll view
                - frame.minY // Subtract the position of the keyboard frame on the y axis

            keyboardBottomInset += contentOffset.y
        } else {
            keyboardBottomInset = 0
        }

        // These are the insets we will apply to the scrollView
        var insets = contentInset

        if keyboardBottomInset > safeAreaInsets.bottom {
            insets.bottom = keyboardBottomInset - safeAreaInsets.bottom
        } else {
            insets.bottom = 0
        }

       contentInset = insets
       scrollIndicatorInsets = contentInset
    }
}
#endif

public extension UIScrollView {
    var contentOffsetMax: CGPoint {

        var offset = CGPoint(
            x: contentSize.width - bounds.size.width,
            y: contentSize.height - bounds.size.height
        )

        if #available(iOS 11, *) {
            offset.x += adjustedContentInset.right
            offset.y += adjustedContentInset.bottom
        } else {
            offset.x += contentInset.right
            offset.y += contentInset.bottom
        }

        return offset
    }

    var contentOffsetMin: CGPoint {

        if #available(iOS 11, *) {
            return CGPoint(
                x: -adjustedContentInset.left,
                y: -adjustedContentInset.top
            )
        } else {
            return CGPoint(
                x: -contentInset.left,
                y: -contentInset.top
            )
        }
    }

    var adjustedContentOffset: CGPoint {
        get {
            var offset = contentOffset

            let insets: UIEdgeInsets

            if #available(iOS 11, *) {
                insets = adjustedContentInset
            } else {
                insets = contentInset
            }

            offset.x += insets.left
            offset.y += insets.top

            return offset
        }
        set {

            let insets: UIEdgeInsets

            if #available(iOS 11, *) {
                insets = adjustedContentInset
            } else {
                insets = contentInset
            }

            contentOffset = CGPoint(
                x: newValue.x - insets.left,
                y: newValue.y - insets.top
            )
        }
    }

    var visibleRect: CGRect {
        return CGRect(origin: adjustedContentOffset, size: bounds.size)
    }
}

#endif
