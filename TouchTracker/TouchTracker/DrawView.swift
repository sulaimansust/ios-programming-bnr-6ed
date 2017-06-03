//
//  DrawView.swift
//  TouchTracker
//
//  Created by Laurent Boileau on 2017-06-02.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import UIKit

class DrawView: UIView {

    var currentLines = [NSValue:Line]()
    var finishedLines = [Line]()

    @IBInspectable var finishedLineColor: UIColor = UIColor.black {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable var currentLineColor: UIColor = UIColor.red {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable var lineThickness: CGFloat = 10 {
        didSet {
            setNeedsDisplay()
        }
    }

    // MARK: - UIResponder Methods

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Log statement to see the order of events
        print(#function)

        for touch in touches {
            let location = touch.location(in: self)

            let newLine = Line(begin: location, end: location)

            let key = NSValue(nonretainedObject: touch)
            currentLines[key] = newLine
        }

        setNeedsDisplay()
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Log statement to see the order of events
        print(#function)

        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            currentLines[key]?.end = touch.location(in: self)
        }

        setNeedsDisplay()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Log statement to see the order of events
        print(#function)

        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            if var line = currentLines[key] {
                line.end = touch.location(in: self)

                finishedLines.append(line)
                currentLines.removeValue(forKey: key)
            }
        }

        setNeedsDisplay()
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Log statement to see the order of events
        print(#function)

        currentLines.removeAll()

        setNeedsDisplay()
    }

    // MARK: - Drawing

    func stroke(_ line: Line) {
        let path = UIBezierPath()
        path.lineWidth = lineThickness
        path.lineCapStyle = .round

        path.move(to: line.begin)
        path.addLine(to: line.end)
        path.stroke()
    }

    override func draw(_ rect: CGRect) {
        // Draw finished lines in black
        finishedLineColor.setStroke()
        for line in finishedLines {
            stroke(line)
        }

        for (_, line) in currentLines {
            color(forLine: line).setStroke()
            stroke(line)
        }
    }

    func color(forLine line: Line) -> UIColor {
        let angleClassification = line.classification
        switch angleClassification {
        case .q1:
            return UIColor.green
        case .q2:
            return UIColor.blue
        case .q3:
            return UIColor.purple
        case .q4:
            return UIColor.orange
        }
    }

}
