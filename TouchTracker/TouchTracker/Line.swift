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
    var mid: CGPoint {
        return CGPoint(x: (begin.x + end.x) / 2, y: (begin.y + end.y) / 2)
    }
}
