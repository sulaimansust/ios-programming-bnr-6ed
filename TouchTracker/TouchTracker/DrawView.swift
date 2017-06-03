//
//  DrawView.swift
//  TouchTracker
//
//  Created by Laurent Boileau on 2017-06-02.
//  Copyright © 2017 Big Nerd Ranch. All rights reserved.
//

import UIKit

class DrawView: UIView {

    var currentCircle: Circle? = nil
    var finishedCircles = [Circle]()

    @IBInspectable var finishedCircleColor: UIColor = UIColor.lightGray {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable var currentCircleColor: UIColor = UIColor.orange {
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

        let points = touches.map { $0.location(in: self) }
        currentCircle = Circle(points: points)

        setNeedsDisplay()
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Log statement to see the order of events
        print(#function)

        let points = touches.map { $0.location(in: self) }
        currentCircle = Circle(points: points)

        setNeedsDisplay()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Log statement to see the order of events
        print(#function)

        let points = touches.map { $0.location(in: self) }
        finishedCircles.append(Circle(points: points))
        currentCircle = nil

        setNeedsDisplay()
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Log statement to see the order of events
        print(#function)

        currentCircle = nil

        setNeedsDisplay()
    }

    // MARK: - Drawing

    func stroke(_ circle: Circle) {
        let path = UIBezierPath(ovalIn: circle.bbox)
        path.lineWidth = lineThickness
        path.lineCapStyle = .round
        path.stroke()
    }

    override func draw(_ rect: CGRect) {
        finishedCircleColor.setStroke()
        for circle in finishedCircles {
            stroke(circle)
        }

        currentCircleColor.setStroke()
        if let circle = currentCircle {
            stroke(circle)
        }
    }

}
