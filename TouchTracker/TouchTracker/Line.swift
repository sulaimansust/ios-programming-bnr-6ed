//
//  Line.swift
//  TouchTracker
//
//  Created by Laurent Boileau on 2017-06-02.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import Foundation
import CoreGraphics

struct Line {
    var begin = CGPoint.zero
    var end = CGPoint.zero

    var delta: CGPoint {
        return CGPoint(x: end.x - begin.x, y: end.y - begin.y)
    }

    var angle: Measurement<UnitAngle> {
        guard begin != end else {
            return Measurement(value: 0.0, unit: .degrees)
        }

        let dx = abs(Double(delta.x))
        let dy = abs(Double(delta.y))

        let radAngle = Measurement(value: -atan2(dy, dx), unit: UnitAngle.radians)
        return radAngle.converted(to: UnitAngle.degrees)
    }

    var classification: AngleClassification {
        print("----------------")
        print("delta: \(delta)")
        print("angle: \(angle)")
        let _classification = AngleClassification.classification(forAngle: angle)
        print("classification: \(_classification)")
        return _classification
    }
}


enum AngleClassification {
    case q1
    case q2
    case q3
    case q4

    static let q1Range =    0 ..<  90.0
    static let q2Range =   90 ..< 180.0
    static let q3Range = -180 ..< -90.0
    static let q4Range =  -90 ..<   0.0

    static func classification(forAngle angle: Measurement<UnitAngle>) -> AngleClassification {
        let degAngle = angle.unit == .degrees ? angle : angle.converted(to: .degrees)

        let angleValue = degAngle.value
        if q1Range.contains(angleValue) {
            return .q1
        } else if q2Range.contains(angleValue) {
            return .q2
        } else if q3Range.contains(angleValue) {
            return .q3
        } else {
            return .q4
        }
    }

}
