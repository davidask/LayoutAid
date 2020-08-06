#if canImport(UIKit) && os(iOS)
import UIKit

public class KeyboardLayoutGuide: UILayoutGuide {

    private var observer: Keyboard.Observer?

    private var constraints: [NSLayoutConstraint] = []

    private weak var heightConstraint: NSLayoutConstraint?

    override public var owningView: UIView? {
        didSet {

            // Do nothing if the owning view doesn't change
            guard oldValue !== owningView else {
                return
            }

            defer {
                updateHeightConstraintIfNeeded()
            }

            // If it did, deactivate the previous constraints
            NSLayoutConstraint.deactivate(constraints)
            constraints = []

            // If owning view is nil, do nothing else
            guard let owningView = owningView else {
                observer?.remove()
                return
            }

            // As a last step, activate new constraints
            defer {
                NSLayoutConstraint.activate(constraints)

                if observer == nil {
                    observer = Keyboard.addObserver(for: .willChangeFrame) { [weak self] transition in
                        guard let weakSelf = self else {
                            return
                        }

                        weakSelf.owningView?.layoutIfNeeded()

                        guard weakSelf.updateHeightConstraintIfNeeded() else {
                            return
                        }

                        transition?.addAnimations {
                            weakSelf.owningView?.layoutIfNeeded()
                        }
                    }
                }
            }

            // Append new constraints
            constraints += [
                leadingAnchor.constraint(equalTo: owningView.leadingAnchor),
                trailingAnchor.constraint(equalTo: owningView.trailingAnchor),
                bottomAnchor.constraint(equalTo: owningView.bottomAnchor)
            ]

            let newHeightConstraint = heightAnchor.constraint(equalToConstant: 0)
            self.heightConstraint = newHeightConstraint
            constraints.append(newHeightConstraint)
        }
    }

    deinit {
        observer?.remove()
    }

    @discardableResult
    private func updateHeightConstraintIfNeeded() -> Bool {

        guard let heightConstraint = heightConstraint else {
            return false
        }

        guard let endFrame = Keyboard.frame(in: owningView) else {
            return false
        }

        heightConstraint.constant = endFrame.intersection(owningView?.bounds ?? UIScreen.main.bounds).height

        return true
    }
}

public extension UIView {

    var keyboardLayoutGuide: UILayoutGuide {

        let identifier = "__keyboardLayoutGuide"

        guard let existing = layoutGuides.first(where: { $0.identifier == identifier }) else {
            let new = KeyboardLayoutGuide()
            new.identifier = identifier
            addLayoutGuide(new)
            return new
        }

        return existing
    }

    var keyboardSafeAreaLayoutGuide: UILayoutGuide {

        let identifier = "__keyboardSareaAreaLayoutGuide"

        guard let existing = layoutGuides.first(where: { $0.identifier == identifier }) else {
            let new = UILayoutGuide()
            new.identifier = identifier
            addLayoutGuide(new)

            NSLayoutConstraint.activate([
                new.leadingAnchor.constraint(equalTo: leadingAnchor),
                new.trailingAnchor.constraint(equalTo: trailingAnchor),
                new.topAnchor.constraint(equalTo: topAnchor),
                new.bottomAnchor.constraint(equalTo: keyboardLayoutGuide.topAnchor)
            ])

            return new
        }

        return existing
    }
}

#endif
