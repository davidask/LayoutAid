@testable import LayoutAid
import XCTest

#if canImport(UIKit)
import UIKit
typealias BaseView = View
#elseif canImport(AppKit)
import AppKit

class BaseView: View {
    override var isFlipped: Bool {
        true
    }
}

#endif

// swiftlint:disable type_body_length
final class ConstraintsBuilderTests: XCTestCase {

    var containerView: View!

    let containerSize = CGSize(width: 1_024, height: 1_024)

    override func setUp() {
        super.setUp()
        containerView = BaseView(frame: CGRect(origin: .zero, size: containerSize))
        containerView.translatesAutoresizingMaskIntoConstraints = false
    }

    override func tearDown() {
        super.tearDown()
        containerView = nil
    }

    private func layout(view: View) {
        #if canImport(UIKit)
        containerView.layoutIfNeeded()
        #elseif canImport(AppKit)
        containerView.layoutSubtreeIfNeeded()
        #endif
    }

    private func createLayoutedView(
        in superview: View,
        caller: StaticString = #function,
        @LayoutConstraintsGeneratorBuilder _ content: () -> [LayoutConstraintsGenerator]
    ) -> View {

        let view = BaseView()
        view.translatesAutoresizingMaskIntoConstraints = false
        superview.addSubview(view)

        let constraints = content().flatMap { generator in
            generator.makeConstraints(for: view)
        }

        constraints.activate()

        print("\nListing constraints for \(caller):")
        constraints.forEach { constraint in
            print(constraint)
        }

        layout(view: superview)

        if superview != containerView {
            layout(view: containerView)
        }

        return view
    }

    func testAspectRatio() {

        let view = createLayoutedView(in: containerView) {
            AspectRatio(equalTo: 0.5)
            Width(greaterThanOrEqualTo: 10)
        }

        XCTAssertGreaterThan(view.bounds.width, 0)
        XCTAssertEqual(view.bounds.width, view.bounds.height * 2)
    }

    func testCenterX() {

        let view = createLayoutedView(in: containerView) {
            CenterX(equalTo: containerView)
            Width(equalTo: 10)
        }

        XCTAssertGreaterThan(view.bounds.width, 0)
        XCTAssertEqual(view.frame.midX, view.superview?.bounds.midX)
    }

    func testCenterY() {

        let view = createLayoutedView(in: containerView) {
            CenterY(equalTo: containerView)
            Height(equalTo: 10)
        }

        XCTAssertGreaterThan(view.bounds.height, 0)
        XCTAssertEqual(view.frame.midY, view.superview?.bounds.midY)
    }

    func testEdgesEqual() {

        let view = createLayoutedView(in: containerView) {
            Edges(equalTo: containerView)
            Width(greaterThanOrEqualTo: 10)
            Height(greaterThanOrEqualTo: 10)
        }

        XCTAssertGreaterThan(view.bounds.width, 0)
        XCTAssertGreaterThan(view.bounds.height, 0)
        XCTAssertEqual(view.frame, containerView.bounds)
    }

    func testEdgesInsideOrEqual() {

        let insets = Edges.Insets(top: 10, left: 10, bottom: 10, right: 10)

        let view = createLayoutedView(in: containerView) {
            Edges(insideOrEqualTo: containerView, insets: insets)
            Width(equalTo: containerSize.width * 2)
            Height(equalTo: containerSize.height * 2)
        }

        #if canImport(UIKit)
        XCTAssertEqual(containerView.bounds.inset(by: insets), view.frame)
        #elseif canImport(AppKit)
        XCTAssertEqual(containerView.bounds.insetBy(dx: 10, dy: 10), view.frame)
        #endif
    }

    func testEdgesOutsideOrEqual() {

        let insets = Edges.Insets(top: -10, left: -10, bottom: -10, right: -10)

        let smallerView = createLayoutedView(in: containerView) {
            CenterX(equalTo: containerView)
            CenterY(equalTo: containerView)
            Width(equalTo: containerSize.width / 2)
            Height(equalTo: containerSize.height / 2)
        }

        let largerView = createLayoutedView(in: containerView) {
            CenterX(equalTo: containerView)
            CenterY(equalTo: containerView)
            Edges(outsideOrEqualTo: smallerView, insets: insets)
        }

        #if canImport(UIKit)
        XCTAssertEqual(smallerView.frame.inset(by: insets), largerView.frame)
        #elseif canImport(AppKit)
        XCTAssertEqual(smallerView.frame.insetBy(dx: -10, dy: -10), largerView.frame)
        #endif
    }

    func testHeight() {

        let view = createLayoutedView(in: containerView) {
            Height(equalTo: 100)
            Width(equalTo: 10)
        }

        XCTAssertGreaterThan(view.bounds.height, 0)
        XCTAssertEqual(view.bounds.height, 100)
    }

    func testWidth() {

        let view = createLayoutedView(in: containerView) {
            Height(equalTo: 10)
            Width(equalTo: 100)
        }

        XCTAssertGreaterThan(view.bounds.width, 0)
        XCTAssertEqual(view.bounds.width, 100)
    }

    func testLeading() {

        let view = createLayoutedView(in: containerView) {
            Height(equalTo: 10)
            Width(equalTo: 100)
            Leading(equalTo: containerView, constant: 10)
        }

        XCTAssertGreaterThan(view.bounds.width, 0)
        XCTAssertGreaterThan(view.bounds.height, 0)
        XCTAssertEqual(view.frame.origin.x, 10)
    }

    func testTrailing() {

        let view = createLayoutedView(in: containerView) {
            Height(equalTo: 10)
            Width(equalTo: 100)
            Trailing(equalTo: containerView, constant: -10)
        }

        XCTAssertGreaterThan(view.bounds.width, 0)
        XCTAssertGreaterThan(view.bounds.height, 0)
        XCTAssertEqual(view.frame.maxX, view.superview!.bounds.maxX - 10)
    }

    func testLeft() {

        let view = createLayoutedView(in: containerView) {
            Height(equalTo: 10)
            Width(equalTo: 100)
            Left(equalTo: containerView, constant: 10)
        }

        XCTAssertGreaterThan(view.bounds.width, 0)
        XCTAssertGreaterThan(view.bounds.height, 0)
        XCTAssertEqual(view.frame.origin.x, 10)
    }

    func testRight() {

        let view = createLayoutedView(in: containerView) {
            Height(equalTo: 10)
            Width(equalTo: 100)
            Right(equalTo: containerView, constant: -10)
        }

        XCTAssertGreaterThan(view.bounds.width, 0)
        XCTAssertGreaterThan(view.bounds.height, 0)
        XCTAssertEqual(view.frame.maxX, view.superview!.bounds.maxX - 10)
    }

    func testTop() {

        let view = createLayoutedView(in: containerView) {
            Height(equalTo: 10)
            Width(equalTo: 100)
            Top(equalTo: containerView, constant: 10)
        }

        XCTAssertGreaterThan(view.bounds.width, 0)
        XCTAssertGreaterThan(view.bounds.height, 0)
        XCTAssertEqual(view.frame.origin.y, 10)
    }

    func testBottom() {

        let view = createLayoutedView(in: containerView) {
            Height(equalTo: 10)
            Width(equalTo: 100)
            Bottom(equalTo: containerView, constant: -10)
        }

        XCTAssertGreaterThan(view.bounds.width, 0)
        XCTAssertGreaterThan(view.bounds.height, 0)
        XCTAssertEqual(view.frame.maxY, view.superview!.bounds.maxY - 10)
    }

    func testPerformance() {

        measure {
            let view = View()
            view.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(view)

            NSLayoutConstraint.activate {
                view.anchor {
                    Leading(equalTo: containerView)
                    Trailing(equalTo: containerView)
                    Top(equalTo: containerView)
                    Bottom(equalTo: containerView)
                }
            }
        }
    }

    func testFallbackPerformance() {

        measure {
            let view = View()
            view.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(view)

            NSLayoutConstraint.activate([
                view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                view.topAnchor.constraint(equalTo: containerView.topAnchor),
                view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
        }
    }

    #if canImport(UIKit)
    func testUIKitUsageExample() {

        //import LayoutAid

        class MyViewController: UIViewController {

            lazy var containerView = UIView()

            lazy var iconView = UIImageView()

            lazy var label = UILabel()

            override func viewDidLoad() {
                super.viewDidLoad()

                view.addSubview(iconView)
                iconView.translatesAutoresizingMaskIntoConstraints = false

                view.addSubview(label)
                label.translatesAutoresizingMaskIntoConstraints = false

                NSLayoutConstraint.activate {
                    containerView.anchor(
                        Edges(equalTo: view.layoutMarginsGuide)
                    )

                    iconView.anchor {
                        Width(equalTo: 50)
                        AspectRatio(equalTo: 1)
                        Center(equalTo: containerView)
                    }

                    label.anchor {
                        Top(equalToSystemSpacingBelow: iconView)
                        CenterX(equalTo: containerView.readableContentGuide)
                        Width(lessThanOrEqualTo: containerView.readableContentGuide, multiplier: 0.5)
                    }
                }
            }
        }
    }

    #if os(iOS)
    func testKeyboardUsageExample() {
        //import LayoutAid

        class MyViewController: UIViewController {

            lazy var keyboardBackgroundView = UIView()

            lazy var keyboardAvoidingView = UIImageView()

            override func viewDidLoad() {
                super.viewDidLoad()

                view.addSubview(keyboardBackgroundView)
                keyboardBackgroundView.translatesAutoresizingMaskIntoConstraints = false

                view.addSubview(keyboardAvoidingView)
                keyboardAvoidingView.translatesAutoresizingMaskIntoConstraints = false

                NSLayoutConstraint.activate {
                    keyboardBackgroundView.anchor(
                        Edges(equalTo: view.keyboardLayoutGuide)
                    )

                    keyboardAvoidingView.anchor {
                        Leading(equalTo: view)
                        Trailing(equalTo: view)
                        Top(equalTo: view.safeAreaLayoutGuide)
                        Bottom(lessThanOrEqualTo: view.keyboardSafeAreaLayoutGuide)
                    }
                }
            }
        }
    }
    #endif
    #endif
}

extension ConstraintsBuilderTests {

    static var allTests: [(String, (ConstraintsBuilderTests) -> () -> Void)] {
        let result = [
            ("testAspectRatio", testAspectRatio),
            ("testCenterX", testCenterX),
            ("textCenterY", testCenterY),
            ("testLeading", testLeading),
            ("testTrailing", testTrailing),
            ("testTop", testTop),
            ("testBottom", testBottom),
            ("testLeft", testLeft),
            ("testRight", testRight),
            ("testEdgesEqual", testEdgesEqual),
            ("testEdgesInsideOrEqual", testEdgesInsideOrEqual),
            ("testEdgesOutsideOrEqual", testEdgesOutsideOrEqual),
            ("testHeight", testHeight),
            ("testWidth", testWidth)
        ]

        return result
    }
}
// swiftlint:enable type_body_length
