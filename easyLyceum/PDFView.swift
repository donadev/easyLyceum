//
//  PDFView.swift
//  easyLyceum
//
//  Created by Luigi Donadel on 20/10/16.
//  Copyright © 2016 ilma. All rights reserved.
//

import Cocoa
import Quartz

var onMouseDownHandler : (() -> ())!
var onMouseUpHandler : (() -> ())!

var startPoint : NSPoint!
var shapeLayer : CAShapeLayer!
var selectedSquareAnnotation : PDFAnnotationSquare?
extension PDFView {
    func setOnMouseDownHandler(handler : @escaping () -> ()) {
        onMouseDownHandler = handler
    }
    func setOnMouseUpHandler(handler : @escaping () -> ()) {
        onMouseUpHandler = handler
    }
    func getSelectedAnnotation() -> PDFAnnotationSquare? {
        return selectedSquareAnnotation
    }
    func isSelectionBoxVisible() -> Bool {
        return shapeLayer != nil && shapeLayer.superlayer != nil && shapeLayer.path != nil
    }
    func getSelection() -> NSRect? {
        var rect = shapeLayer?.path?.boundingBox
        guard rect != nil else {
            return nil
        }
        
        rect!.origin = correct(point: rect!.origin)
        return rect
    }
    func correct(point : CGPoint) -> CGPoint {
        return CGPoint(x: point.x - 7, y: point.y - 10)
    }
    open override func mouseUp(with event: NSEvent) {
        super.mouseUp(with: event)
        onMouseUpHandler()
    }
    func removeSelectionBox() {
        if shapeLayer != nil {
            shapeLayer.removeFromSuperlayer()
        }
        shapeLayer = nil
    }
    override open func mouseDown(with event: NSEvent) {
        
        startPoint = self.documentView!.convert(event.locationInWindow, from: nil)
        selectedSquareAnnotation = self.currentPage!.annotation(at: correct(point: startPoint)) as? PDFAnnotationSquare
        onMouseDownHandler()
        removeSelectionBox()
        shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = 1.0
        shapeLayer.fillColor = NSColor.clear.cgColor
        shapeLayer.strokeColor = NSColor.black.cgColor
        shapeLayer.lineDashPattern = [10,5]
        if let newLayer = self.documentView?.layer {
            newLayer.addSublayer(shapeLayer)
        }
        
        var dashAnimation = CABasicAnimation()
        dashAnimation = CABasicAnimation(keyPath: "lineDashPhase")
        dashAnimation.duration = 0.75
        dashAnimation.fromValue = 0.0
        dashAnimation.toValue = 15.0
        dashAnimation.repeatCount = .infinity
        shapeLayer.add(dashAnimation, forKey: "linePhase")
        super.mouseDown(with: event)
        
    }
    
    override open func mouseDragged(with event: NSEvent) {
        if let layer = shapeLayer {
            let point : NSPoint = self.documentView!.convert(event.locationInWindow, from: nil)
            let path = CGMutablePath()
            path.move(to: startPoint)
            path.addLine(to: CGPoint(x: startPoint.x, y: point.y))
            path.addLine(to: point)
            path.addLine(to: CGPoint(x: point.x, y: startPoint.y))
            path.closeSubpath()
            layer.path = path
        }
    }
    
    
}
