#if canImport(UIKit) && os(iOS)
import UIKit

public final class Keyboard {

    public class Animator {
        public let curve: UIView.AnimationCurve
        public let duration: TimeInterval

        private var animations: [() -> Void] = []

        fileprivate init?(notification: Notification) {
            guard
                let userInfo = notification.userInfo,
                let animationCurveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int,
                let animationCurve = UIView.AnimationCurve(rawValue: animationCurveValue),
                let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
                    return nil
            }

            self.curve = animationCurve
            self.duration = duration
        }

        public func addAnimations(_  block: @escaping () -> Void) {
            animations.append( block)
        }

        fileprivate func animate() {
            UIView.beginAnimations("keyboard", context: nil)
            UIView.setAnimationBeginsFromCurrentState(true)
            UIView.setAnimationCurve(curve)
            UIView.setAnimationDuration(duration)
            while animations.isEmpty == false {
                animations.removeFirst()()
            }
            UIView.commitAnimations()
        }
    }

    public enum Event {
        case willChangeFrame
        case willShow
        case willHide
    }

    public class Observer: Equatable {
        fileprivate var callback: (Animator?) -> Void
        public let event: Event

        public func remove() {
            Keyboard.removeObserver(self)
        }

        fileprivate init(event: Event, block: @escaping (Animator?) -> Void) {
            self.event = event
            self.callback = block
        }

        public static func == (lhs: Observer, rhs: Observer) -> Bool {
            return lhs === rhs
        }
    }

    private static var observers: [Observer] = [] {
        didSet {
            if observers.isEmpty {
                deregisterForKeyboardNotifications()
            } else {
                registerForKeyboardNotificationsIfNeeded()
            }
        }
    }

    public private(set) static var frameOnScreen: CGRect?

    public static func frame(in view: UIView?) -> CGRect? {

        guard let frame = frameOnScreen else {
            return nil
        }

        guard let view = view else {
            return frame
        }

        return view.convert(frame, from: nil)
    }

    public private(set) static var isObservingKeyboardNotifications = false

    public private(set) static var isObservingApplicationNotifications = false

    static let keyboardNotificationNames: [Notification.Name] = [
        UIResponder.keyboardWillChangeFrameNotification,
        UIResponder.keyboardWillShowNotification,
        UIResponder.keyboardWillHideNotification
    ]

    static let applicationNotificationNames: [Notification.Name] = [
        UIApplication.didBecomeActiveNotification,
        UIApplication.willResignActiveNotification
    ]

    static func registerForKeyboardNotificationsIfNeeded() {

        registerForApplicationNotificationsIfNeeded()

        guard isObservingKeyboardNotifications == false else {
            return
        }

        for notificationName in keyboardNotificationNames {
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(handleKeyboardNotification(notification:)),
                name: notificationName,
                object: nil
            )
        }

        isObservingKeyboardNotifications = true
    }

    static func deregisterForKeyboardNotifications() {
        for notificationName in keyboardNotificationNames {
            NotificationCenter.default.removeObserver(
                self,
                name: notificationName,
                object: nil
            )
        }

        isObservingKeyboardNotifications = false
    }

    static func registerForApplicationNotificationsIfNeeded() {
        guard isObservingApplicationNotifications == false else {
            return
        }

        for notificationName in applicationNotificationNames {
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(handleApplicationNotification(notification:)),
                name: notificationName,
                object: UIApplication.shared
            )
        }

        isObservingApplicationNotifications = true
    }

    @discardableResult
    public static func addObserver(for event: Event, _ body: @escaping (Animator?) -> Void) -> Observer {
        let observer = Observer(event: event, block: body)
        observers.append(observer)
        return observer
    }

    public static func removeObserver(_ observer: Observer) {
        observers = observers.filter { existing in
            existing != observer
        }
    }

    private static func withObservers(for event: Event, _ body: (Observer) throws -> Void) rethrows {
        for observer in observers where observer.event == event {
            try body(observer)
        }
    }

    // MARK: - Notification handling
    @objc
    private static func handleKeyboardNotification(notification: Notification) {

        guard let userInfo = notification.userInfo else {
            return
        }

        frameOnScreen = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue

        let animator = Animator(notification: notification)

        switch notification.name {

        case UIResponder.keyboardWillChangeFrameNotification:
            withObservers(for: .willChangeFrame) { observer in
                observer.callback(animator)
            }

        case UIResponder.keyboardWillShowNotification:
            withObservers(for: .willShow) { observer in
                observer.callback(animator)
            }

        case UIResponder.keyboardWillHideNotification:
            withObservers(for: .willHide) { observer in
                observer.callback(animator)
            }

        default:
            break
        }

        animator?.animate()
    }

    @objc
    private static func handleApplicationNotification(notification: Notification) {

        switch notification.name {

        case UIApplication.willResignActiveNotification:
            deregisterForKeyboardNotifications()

        case UIApplication.didBecomeActiveNotification:
            registerForKeyboardNotificationsIfNeeded()

        default:
            break
        }
    }
}

#endif
