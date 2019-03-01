//
//  LineGraphView.swift
//  LineGraphSample
//
//  Created by Vy Nguyen on 12/25/18.
//  Copyright © 2018 VVLab. All rights reserved.
//

import Foundation
import UIKit

//#import "MYGraphView.h"

struct GraphItemPoint {
    let itemID: Int
    let value: CGFloat
}

struct GraphItem {
    let stringLabel: String
    let valueArray: [GraphItemPoint]
}

class LineGraphView: BaseCustomView {

    let defaultColor = UIColor.gray
    let pointRadius = 3
    
    let displayValueLabel:Bool = true
    let displayAllValue:Bool = true
    let startFromZero:Bool = true
    
    let maxStepCount:CGFloat = 10
    let rulerSpliter:CGFloat = 10
    let footerStepCount:CGFloat = 5
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    var mainScrollContent: UIView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var leftRuler: UIView!

    var graphValues:[GraphItem] = []
    var lineColors = [UIColor.red, UIColor.green, UIColor.blue]
    
    func getColorForIndex(index: Int) -> UIColor {
        if lineColors.indices.contains(index) {
            return lineColors[index]
        } else {
            return defaultColor
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.fillData()
    }

    func fillData() {
        var minValue:CGFloat = startFromZero ? 0 :self.getMinGraphValue()
        var maxValue:CGFloat = self.getMaxGraphValue()
        let step:CGFloat = self.getGetStepWithMinValue(minValue: minValue, maxValue:maxValue)
        minValue = self.fRoundDown(number: minValue, withStep:step)
        maxValue = self.fRoundUp(number: maxValue, withStep:step)
        // clear old data;
        for view in self.leftRuler.subviews {
            view.removeFromSuperview()
        }
        self.leftRuler.layer.sublayers = nil
        //
        for view in self.footerView.subviews {
            view.removeFromSuperview()
        }
        self.footerView.layer.sublayers = nil
        //
        if mainScrollContent == nil {
            mainScrollContent = UIView.init(frame: mainScrollView.frame)
            mainScrollView.addSubview(mainScrollContent)
        }
        for view in self.mainScrollContent.subviews {
            view.removeFromSuperview()
        }
        self.mainScrollContent.layer.sublayers = nil
        //
        self.drawLeftRulerWithMinValue(minValue: minValue, MaxValue:maxValue, Step:step)
        self.drawFooter()
        self.drawContent()
        self.drawScrollaberContent(minValue: minValue, MaxValue: maxValue, Step: step)
    }
    func drawGraph() {

    }
    func drawLeftRulerWithMinValue(minValue:CGFloat, MaxValue maxValue:CGFloat, Step step:CGFloat) {
        self.drawText(text: "left ruler", onView:self.leftRuler, at:CGPoint.init(x:5,y: 10))
        // Drawing ruler
        let marginLeft:CGFloat = CGFloat(self.leftRuler.frame.width)
        let yBottom:CGFloat = CGFloat(self.frame.size.height - self.footerView.frame.size.height)
        let frmPoint:CGPoint = CGPoint.init(x:CGFloat(marginLeft),y: 0)
        let toPoint:CGPoint = CGPoint.init(x:CGFloat(marginLeft),y: CGFloat(yBottom))
        self.drawLineAt(view: self.leftRuler, From:frmPoint, to:toPoint)

        let stepCount:Int = Int((maxValue - minValue)/step)

        let layoutStep:CGFloat = yBottom / CGFloat(stepCount)
        var startValue:CGFloat = maxValue
        for i in 0...stepCount {
            let ySpliter:CGFloat = CGFloat(Float(i)) * layoutStep
            let fPoint:CGPoint = CGPoint.init(x: CGFloat(marginLeft), y: CGFloat(ySpliter))
            let tPoint:CGPoint = CGPoint.init(x: CGFloat(marginLeft - rulerSpliter),y: CGFloat(ySpliter))
            self.drawLineAt(view: self.leftRuler, From:fPoint, to:tPoint)
            let lblPoint:CGPoint = CGPoint.init(x:CGFloat(rulerSpliter),y: CGFloat(ySpliter))
            self.drawText(text: self.stringValue(value: Float(startValue)), onView:self.leftRuler, at:lblPoint)
            startValue -= step
        }
    }

    func stringValue(value:Float) -> String! {
        return String(format:"%.1f",value)
    }
    func drawFooter() {
        self.drawText(text: "this is footer", onView:self.footerView, at: CGPoint.init(x:200,y: 40))
        // Drawing ruler
        let marginLeft:Float = Float(self.leftRuler.frame.width)
        let frmPoint:CGPoint = CGPoint.init(x: Int(marginLeft), y: 0)
        let toPoint:CGPoint = CGPoint.init(x:self.frame.size.width, y: 0)
        self.drawLineAt(view: self.footerView, From:frmPoint, to:toPoint)
    }
    func drawContent() {
        //Drawing some thing not scroll
    }
    func drawScrollaberContent(minValue:CGFloat, MaxValue maxValue:CGFloat, Step step:CGFloat) {
        // draw
        var xPoint:CGFloat = 30
        let footerStepW:CGFloat = self.getFooterStepWidth()
        var yPoint:CGFloat
        let yBottom:CGFloat = self.frame.size.height - self.footerView.frame.size.height
        let layoutValue:CGFloat = yBottom / (maxValue - minValue)

        let previousValue:NSMutableDictionary! = NSMutableDictionary()
        
        for item in self.graphValues {
            for index in 0..<item.valueArray.count {
                let itemPoint = item.valueArray[index]
                yPoint = (maxValue - itemPoint.value) * layoutValue
                let point:CGPoint = CGPoint.init(x: xPoint, y: yPoint)
                let color:UIColor =  getColorForIndex(index: index)
                self.drawPoint(view: self.mainScrollContent, at:point, color:color)
                if displayValueLabel {
                    self.drawText(text: self.stringValue(value: Float(itemPoint.value)), onView:self.mainScrollContent, at: CGPoint.init(x:xPoint,y: yPoint - 20))
                }
                let key:String! = String(format:"%d", itemPoint.itemID)
                if (previousValue.object(forKey: key) != nil) {
                    let value:NSValue! = previousValue.object(forKey: key) as? NSValue
                    self.drawDashedLineAt(view: self.mainScrollContent, From: point, to: value.cgPointValue , color:color)
                }
                previousValue.setObject(NSValue(cgPoint:point), forKey:key! as NSCopying)
            }
            self.drawLineAt(view: self.mainScrollContent, From:CGPoint.init(x:xPoint,y: yBottom), to: CGPoint.init(x:xPoint, y: yBottom + rulerSpliter))
            self.drawText(text: item.stringLabel, onView:self.mainScrollContent, at: CGPoint.init(x: xPoint, y: yBottom + 2 * rulerSpliter))
            xPoint += footerStepW
        }
        // set content size
        let contentRect:CGRect = self.mainScrollView.frame
        let contentWidth:Float = Float(max((self.frame.size.width - self.leftRuler.frame.size.width), (CGFloat)(xPoint)))
        self.mainScrollContent.frame = CGRect.init(x: contentRect.origin.x, y: contentRect.origin.y, width: CGFloat(contentWidth), height: self.frame.size.height)
        self.mainScrollView.contentSize = self.mainScrollContent.frame.size
    }
    func getFooterStepWidth() -> CGFloat {
        return self.mainScrollContent.frame.width / footerStepCount
    }
    // pragma Calculator

    func getMaxGraphValue() -> CGFloat {
        var maxValue:CGFloat = 0
        for item in self.graphValues {
            for itemPoint in item.valueArray {
                if maxValue < itemPoint.value {
                    maxValue = itemPoint.value
                }
            }
        }
        return maxValue
    }

    func getMinGraphValue() -> CGFloat {
        var minValue:CGFloat = CGFloat(MAXFLOAT)
        for item in self.graphValues {
            for itemPoint in item.valueArray {
                if minValue > itemPoint.value {
                    minValue = itemPoint.value
                }
            }
        }
        return minValue
    }
    func fRoundUp(number:CGFloat, withStep step:CGFloat) -> CGFloat {
        var count:CGFloat = number/step
        count = count.rounded(.up)
        return count * step
    }
    func fRoundDown(number:CGFloat, withStep step:CGFloat) -> CGFloat {
        var count:CGFloat = number/step
        count = count.rounded(.down)
        return count * step
    }
    func getGetStepWithMinValue(minValue:CGFloat, maxValue:CGFloat) -> CGFloat {
        let maxRange:CGFloat = maxValue - minValue
        let step:CGFloat = maxRange / CGFloat(maxStepCount)
        if step <= 0.1 {
            return 0.1
        } else if step <= 1 {
            return 1
        } else if step <= 5 {
            return 5
        } else if step <= 10 {
            return 10
        } else if step <= 100 {
            return self.fRoundUp(number: step, withStep:10)
        } else {
            let numberString:String! = String(format:"%.1f",step)
            return self.fRoundUp(number: step, withStep:( pow(10,CGFloat(numberString.count - 1))))
        }
    }

    // pragma Drawing Util
    func drawLineAt(view:UIView!, From frmPoint:CGPoint, to toPoint:CGPoint, color:UIColor!) {
        let path:UIBezierPath! = UIBezierPath()
        path.move(to: frmPoint)
        path.addLine(to: toPoint)

        let shapeLayer:CAShapeLayer! = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 1.0
        shapeLayer.fillColor = UIColor.clear.cgColor
        view.layer.addSublayer(shapeLayer)
    }
    func drawDashedLineAt(view:UIView!, From frmPoint:CGPoint, to toPoint:CGPoint, color:UIColor!) {
        let path:UIBezierPath! = UIBezierPath()
        path.move(to: frmPoint)
        path.addLine(to: toPoint)

        let shapeLayer:CAShapeLayer! = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 1.0
        shapeLayer.lineDashPattern = [10,5]
        shapeLayer.fillColor = UIColor.clear.cgColor
        view.layer.addSublayer(shapeLayer)
    }
    func drawLineAt(view:UIView!, From frmPoint:CGPoint, to toPoint:CGPoint) {
        self.drawLineAt(view: view, From:frmPoint, to:toPoint, color:defaultColor)
    }
    func drawPoint(view:UIView!, at point:CGPoint, color:UIColor!) {
        let rect:CGRect = CGRect.init(x: point.x - CGFloat(pointRadius), y: point.y - CGFloat(pointRadius), width: CGFloat(2 * pointRadius), height: CGFloat(2 * pointRadius))
        let path:UIBezierPath! = UIBezierPath(ovalIn: rect)

        let shapeLayer:CAShapeLayer! = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 1.0
        shapeLayer.fillColor = UIColor.clear.cgColor
        view.layer.addSublayer(shapeLayer)
    }
    func drawPoint(view:UIView!, at point:CGPoint) {
        self.drawPoint(view: view, at:point, color: defaultColor)
    }
    // Drawing some text on view
    func drawText(text:String!, onView view:UIView!, at position:CGPoint, color:UIColor!) {
        let lbl = UILabel.init(frame: CGRect.init(origin: position, size: CGSize.zero))
        lbl.text = text
        lbl.textAlignment = .center
        lbl.textColor = defaultColor
        lbl.font = UIFont(name: "AlNile", size:10.0)
        let fixedWidth:CGFloat = lbl.frame.size.width
        let newSize:CGSize = lbl.sizeThatFits(CGSize.init(width:fixedWidth,height: CGFloat(MAXFLOAT)))
        var newFrame:CGRect = lbl.frame
        newFrame.size = CGSize.init(width:CGFloat(fmaxf(Float(newSize.width), Float(fixedWidth))),height: newSize.height)
        lbl.frame = newFrame
        view.addSubview(lbl)
    }
    func drawText(text:String!, onView view:UIView!, at position:CGPoint) {
        self.drawText(text: text, onView:view, at:position, color: defaultColor)
    }
}
