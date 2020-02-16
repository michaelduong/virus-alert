//
//  FloatingPanel.swift
//  VirusAlert
//
//  Created by Swift Team Six on 2/15/20.
//  Copyright © 2020 Turnt Labs. All rights reserved.
//

import FloatingPanel

class FloatingPanelStatsLayout: FloatingPanelLayout {
    var initialPosition: FloatingPanelPosition {
        return .half
    }

    var topInteractionBuffer: CGFloat { return 0.0 }
    var bottomInteractionBuffer: CGFloat { return 0.0 }

    func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
        case .full: return 312.0
        case .half: return 186.0
        case .tip: return 62.0
        default: return nil
        }
    }

    func backdropAlphaFor(position: FloatingPanelPosition) -> CGFloat {
        return 0.0
    }
}

class FloatingPanelStatsBehavior: FloatingPanelBehavior {
    var velocityThreshold: CGFloat {
        return 15.0
    }

    func interactionAnimator(_ fpc: FloatingPanelController, to targetPosition: FloatingPanelPosition, with velocity: CGVector) -> UIViewPropertyAnimator {
        let timing = timeingCurve(to: targetPosition, with: velocity)
        return UIViewPropertyAnimator(duration: 0, timingParameters: timing)
    }

    private func timeingCurve(to: FloatingPanelPosition, with velocity: CGVector) -> UITimingCurveProvider {
        let damping = self.damping(with: velocity)
        return UISpringTimingParameters(dampingRatio: damping,
                                        frequencyResponse: 0.4,
                                        initialVelocity: velocity)
    }

    private func damping(with velocity: CGVector) -> CGFloat {
        switch velocity.dy {
        case ...(-velocityThreshold):
            return 0.7
        case velocityThreshold...:
            return 0.7
        default:
            return 1.0
        }
    }
}
