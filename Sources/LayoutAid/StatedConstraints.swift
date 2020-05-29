#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

public final class StatedConstraints<State: Hashable> {

    public var state: State {
        didSet {
            updateConstraints()
        }
    }

    private var constraintsByState: [State: [NSLayoutConstraint]] = [:]

    public init(state: State) {
        self.state = state
    }

    public var isActive = false {
        didSet {
            updateConstraints()
        }
    }

    public func constraints(for state: State) -> [NSLayoutConstraint] {
        return constraintsByState[state] ?? []
    }

    public func addConstraints<S>(_ constraints: S, for state: State) where S: Sequence, S.Element: NSLayoutConstraint {
        var existing = constraintsByState[state] ?? []

        existing.append(contentsOf: Array(constraints) as [NSLayoutConstraint])
        constraintsByState[state] = existing
        updateConstraints()
    }

    public func addConstraints(for state: State, @NSLayoutConstraint.Builder _ content: () -> [NSLayoutConstraint]) {
        addConstraints(content(), for: state)
    }

    public func removeConstraints(for state: State) {
        constraintsByState[state]?.deactivate()
        constraintsByState[state] = nil
    }

    private func updateConstraints() {
        guard isActive else {

            let constraintsToDeactivate = constraintsByState.values.flatMap { constraints in
                return constraints.filter { constraint in
                    return constraint.isActive == true
                }
            }

            constraintsToDeactivate.deactivate()

            return
        }

        let constraintsToDeactivate = constraintsByState.flatMap { state, constraints in
            return constraints.filter { constraint in
                return constraint.isActive == true && self.state != state
            }
        }

        let constraintsToActivate = constraintsByState.flatMap { state, constraints in
            return constraints.filter { constraint in
                return constraint.isActive == false && self.state == state
            }
        }

        constraintsToDeactivate.deactivate()
        constraintsToActivate.activate()
    }
}
