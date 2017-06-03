//
//  Circle.swift
//  TouchTracker
//
//  Created by Laurent Boileau on 2017-06-02.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import Foundation
import CoreGraphics

struct Circle {
    var bbox = CGRect.zero

    init(bbox: CGRect) {
        self.bbox = bbox
    }

    init(points: [CGPoint]) {
        let rects = points.map { point in
            return CGRect(x: point.x, y: point.y, width: 0, height: 0)
        }

        for rect in rects {
            if bbox == CGRect.zero {
                self.bbox = rect
            } else {
                self.bbox = self.bbox.union(rect)
            }
        }
    }
}
