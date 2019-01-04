//
//  SetCardView.swift
//  setGame
//
//  Created by Abram Himmer on 6/1/18.
//  Copyright © 2018 Abram Himmer. All rights reserved.
//

import UIKit


class SetCardView: UIView {

    //internal drawing vars
     var number: Int = 1 {didSet{ setNeedsDisplay()}}
     var shape: Int = 1 {didSet{ setNeedsDisplay()}}
     var shade: Int = 1 {didSet{ setNeedsDisplay()}}
     var color: Int = 1 {didSet{ setNeedsDisplay()}}
    var faceUp = false {didSet {setNeedsDisplay()}}
    
    
    //border color var
    @IBInspectable var border: String = "untouched" {didSet{ setNeedsDisplay()}}
    
    var size: CGFloat = 0
    var offset: CGFloat = 0
    var drawingColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    var borderColor = #colorLiteral(red: 1, green: 0.808293173, blue: 0.2171398683, alpha: 0)
    
    enum Border: String {
        case untouched
        case selected
        case matched
        case mismatched
        case hinted
    }
    
    enum Shape: Int {
        case diamond = 1
        case oval = 2
        case squiggle = 3
    }
    
    enum Color: Int {
        case green = 1
        case red = 2
        case blue = 3
    }
    
    enum Shade: Int {
        case filled = 1
        case striped = 2
        case outlined = 3
    }

    enum Number: Int {
        case one = 1
        case two = 2
        case three = 3
    }
    
    override func draw(_ rect: CGRect) {

        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.width/10)
        roundedRect.addClip()
        #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).setFill()
        roundedRect.fill()
        
        if faceUp {
            switch border {
            case Border.untouched.rawValue: borderColor = #colorLiteral(red: 1, green: 0.808293173, blue: 0.2171398683, alpha: 0)
            case Border.matched.rawValue: borderColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            case Border.selected.rawValue: borderColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
            case Border.mismatched.rawValue: borderColor = #colorLiteral(red: 0.7960784314, green: 0.2549019608, blue: 0.3294117647, alpha: 1)
            case Border.hinted.rawValue: borderColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
            default: break
            }
            
            switch color {
            case Color.green.rawValue: drawingColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            case Color.blue.rawValue: drawingColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
            case Color.red.rawValue: drawingColor = #colorLiteral(red: 0.7960784314, green: 0.2549019608, blue: 0.3294117647, alpha: 1)
            default: break
            }
            
            switch number {
            case Number.one.rawValue: size = constants.thirdsSize
            case Number.two.rawValue: size = constants.thirdsSize; offset = 11/48
            case Number.three.rawValue: size = constants.thirdsSize
            default: break
            }
            
            switch shape {
            case Shape.diamond.rawValue: drawDiamond()
            case Shape.oval.rawValue: drawOval()
            case Shape.squiggle.rawValue: drawSquiggle()
            default: break
            }
            self.layer.borderWidth = { () -> CGFloat in
                return (self.frame.size.width+self.frame.size.height)/50
            }()
            self.layer.borderColor = borderColor.cgColor
        } else {
        }
        
    }
    
    private func finishDrawing( path: UIBezierPath){
        var arrOfPaths = [UIBezierPath]()
        
        drawingColor.setFill()
        drawingColor.setStroke()
        
        let calcLineWidth = { () -> CGFloat in
            return (self.frame.size.width+self.frame.size.height)/100
        }()
        
        path.lineWidth = calcLineWidth
        arrOfPaths.append(path)
        
//        let context = UIGraphicsGetCurrentContext()
//        context?.saveGState()
        
        switch number {
        case Number.two.rawValue:
            
            let path2 = path.copy() as! UIBezierPath
            path2.apply(CGAffineTransform(translationX: -(bounds.width*2*offset), y: 0))
            arrOfPaths.append(path2)
            
            //context?.translateBy(x:  -(bounds.width*2*offset), y: 0)
            //path.stroke()
            
        case Number.three.rawValue:

            let path2 = path.copy() as! UIBezierPath
            let path3 = path.copy() as! UIBezierPath

            path2.apply(CGAffineTransform(translationX: -bounds.width*size, y: 0))
            path3.apply(CGAffineTransform(translationX: +bounds.width*size, y: 0))

            arrOfPaths.append(path2)
            arrOfPaths.append(path3)

        default: break
        }
        
        //context?.restoreGState()

        
        for pathS in arrOfPaths {
            //draw stripes
            
            if shade == Shade.striped.rawValue {
                let context = UIGraphicsGetCurrentContext()
                context?.saveGState()
                
                pathS.addClip()
                
                let stripe = UIBezierPath()
                stripe.lineWidth = calcLineWidth
                
                var yOffset: CGFloat = 0.0
                let calcOffset = { () -> CGFloat in
                    return self.frame.size.height/10
                }()
                for _ in 0...15 {
                    stripe.move(to: CGPoint(x: bounds.minX, y: bounds.minY+yOffset))
                    stripe.addLine(to: CGPoint(x: bounds.maxX, y: bounds.minY+yOffset))
                    yOffset += calcOffset
                }
                
                
                stripe.stroke()
                context?.restoreGState()
            }
            
            pathS.stroke()
            if shade == Shade.filled.rawValue {
                pathS.fill()
            }
        }
        offset = 0
    }
    
    private func drawDiamond(){
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: bounds.width*size*constants.diamondLeftX + (bounds.width*offset), y: bounds.height*constants.diamondLeftY))
        path.addLine(to: CGPoint(x: bounds.width*size*constants.diamondTopX + (bounds.width*offset), y: bounds.height*constants.diamondTopY))
        path.addLine(to: CGPoint(x: bounds.width*size*constants.diamondRightX + (bounds.width*offset), y: bounds.height*constants.diamondRightY))
        path.addLine(to: CGPoint(x: bounds.width*size*constants.diamondBottomX + (bounds.width*offset), y: bounds.height*constants.diamondBottomY))
        path.close()

        finishDrawing (path: path)
    }
    
    
    
    private func drawSquiggle(){
        let path = UIBezierPath()
        //start point - top left
        path.move(to: CGPoint(
            x: bounds.width*size*constants.squiggleLeftTopStartX + (bounds.width*offset),
            y: bounds.height*constants.squiggleLeftTopStartY)
        )
       
        //top left curve
        path.addQuadCurve(
            to: CGPoint(
                x: bounds.width*size*constants.squiggleLeftTopToX + (bounds.width*offset),
                y: bounds.height*constants.squiggleLeftTopToY),
            controlPoint: CGPoint(
                x: bounds.width*size*constants.squiggleLeftTopCPX + (bounds.width*offset),
                y: bounds.height*constants.squiggleLeftTopCPY)
        )
        
        //bottom left curve
        path.addQuadCurve(
            to: CGPoint(
                x: bounds.width*size*constants.squiggleLeftBottomToX + (bounds.width*offset),
                y: bounds.height*constants.squiggleLeftBottomToY),
            controlPoint: CGPoint(
                x: bounds.width*size*constants.squiggleLeftBottomCPX + (bounds.width*offset),
                y: bounds.height*constants.squiggleLeftBottomCPY)
        )
        
        //bottom right curve
        path.addQuadCurve(
            to: CGPoint(
                x: bounds.width*size*constants.squiggleRightBottomToX + (bounds.width*offset),
                y: bounds.height*constants.squiggleRightBottomToY),
            controlPoint: CGPoint(
                x: bounds.width*size*constants.squiggleRightBottomCPX + (bounds.width*offset),
                y: bounds.height*constants.squiggleRightBottomCPY)
        )
        
        //top right curve
        path.addQuadCurve(
            to: CGPoint(
                x: bounds.width*size*constants.squiggleLeftTopStartX + (bounds.width*offset),
                y: bounds.height*constants.squiggleLeftTopStartY),
            controlPoint: CGPoint(
                x: bounds.width*size*constants.squiggleRightTopCPX + (bounds.width*offset),
                y: bounds.height*constants.squiggleRightTopCPY)
        )

        finishDrawing (path: path)
    }
    
    
    
    private func drawOval(){
        let path = UIBezierPath()
        
        //middle point
        path.move(to: CGPoint(
            x: bounds.width*size*constants.ovalTopCenterX + (bounds.width*offset),
            y: bounds.height*constants.ovalTopCenterY
        ))
    
        path.addLine(
            to: CGPoint(
                x: bounds.width*size*constants.ovalTopLeftCurveStartX + (bounds.width*offset),
                y: bounds.height*constants.ovalTopLeftCurveStartY
            )
        )
        
        path.addQuadCurve(
            to: CGPoint(
                x: bounds.width*size*constants.ovalTopLeftCurveToX + (bounds.width*offset),
                y: bounds.height*constants.ovalTopLeftCurveToY
            ),
            controlPoint: CGPoint(
                x: bounds.width*size*constants.ovalTopLeftCurveCPX + (bounds.width*offset),
                y: bounds.height*constants.ovalTopLeftCurveCPY
        ))
        
        path.addLine(
            to: CGPoint(
                x: bounds.width*size*constants.ovalBottomLeftCurveStartX + (bounds.width*offset),
                y: bounds.height*constants.ovalBottomLeftCurveStartY
            )
        )
        
        path.addQuadCurve(
            to: CGPoint(
                x: bounds.width*size*constants.ovalBottomLeftCurveToX + (bounds.width*offset),
                y: bounds.height*constants.ovalBottomLeftCurveToY
            ),
            controlPoint: CGPoint(
                x: bounds.width*size*constants.ovalBottomLeftCurveCPX + (bounds.width*offset),
                y: bounds.height*constants.ovalBottomLeftCurveCPY
        ))
        
        
        path.addLine(
            to: CGPoint(
                x: bounds.width*size*constants.ovalBottomRightCurveStartX + (bounds.width*offset),
                y: bounds.height*constants.ovalBottomRightCurveStartY
            )
        )
        
        path.addQuadCurve(
            to: CGPoint(
                x: bounds.width*size*constants.ovalBottomRightCurveToX + (bounds.width*offset),
                y: bounds.height*constants.ovalBottomRightCurveToY
            ),
            controlPoint: CGPoint(
                x: bounds.width*size*constants.ovalBottomRightCurveCPX + (bounds.width*offset),
                y: bounds.height*constants.ovalBottomRightCurveCPY
        ))
        
        path.addLine(
            to: CGPoint(
                x: bounds.width*size*constants.ovalTopRightCurveStartX + (bounds.width*offset),
                y: bounds.height*constants.ovalTopRightCurveStartY
            )
        )
        
        path.addQuadCurve(
            to: CGPoint(
                x: bounds.width*size*constants.ovalTopRightCurveToX + (bounds.width*offset),
                y: bounds.height*constants.ovalTopRightCurveToY
            ),
            controlPoint: CGPoint(
                x: bounds.width*size*constants.ovalTopRightCurveCPX + (bounds.width*offset),
                y: bounds.height*constants.ovalTopRightCurveCPY
        ))
        
        path.close()
        
        finishDrawing (path: path)
    }
    
    private struct constants {
        
        
        //should be used from each shapes reference spot. So if it is the middle shape, multiple the appropiate constant by it's origin x, which for the middle shape is bounds.width*constants.thirdsPadding
        
        //Layout constants
        static let thirdsSize: CGFloat = 1/3
        static let halfSize: CGFloat = 5/10
        
        //oval constants
        static let ovalTopCenterX: CGFloat = 15/10
        static let ovalTopCenterY: CGFloat = 1/10
        
        static let ovalTopLeftCurveStartX: CGFloat = 13/10
        static let ovalTopLeftCurveStartY: CGFloat = 1/10
        
        static let ovalTopLeftCurveToX: CGFloat = 11/10
        static let ovalTopLeftCurveToY: CGFloat = 3/10
        static let ovalTopLeftCurveCPX: CGFloat = 11/10
        static let ovalTopLeftCurveCPY: CGFloat = 1/10
        
        static let ovalBottomLeftCurveStartX: CGFloat = 11/10
        static let ovalBottomLeftCurveStartY: CGFloat = 7/10
        
        static let ovalBottomLeftCurveToX: CGFloat = 13/10
        static let ovalBottomLeftCurveToY: CGFloat = 9/10
        static let ovalBottomLeftCurveCPX: CGFloat = 11/10
        static let ovalBottomLeftCurveCPY: CGFloat = 9/10
        
        static let ovalBottomRightCurveStartX: CGFloat = 17/10
        static let ovalBottomRightCurveStartY: CGFloat = 9/10
        
        static let ovalBottomRightCurveToX: CGFloat = 19/10
        static let ovalBottomRightCurveToY: CGFloat = 7/10
        static let ovalBottomRightCurveCPX: CGFloat = 19/10
        static let ovalBottomRightCurveCPY: CGFloat = 9/10
        
        static let ovalTopRightCurveStartX: CGFloat = 19/10
        static let ovalTopRightCurveStartY: CGFloat = 3/10
        
        static let ovalTopRightCurveToX: CGFloat = 17/10
        static let ovalTopRightCurveToY: CGFloat = 1/10
        static let ovalTopRightCurveCPX: CGFloat = 19/10
        static let ovalTopRightCurveCPY: CGFloat = 1/10
        
        
        //squiggle constants
        static let squiggleLeftTopStartX: CGFloat = 12/10
        static let squiggleLeftTopStartY: CGFloat = 1/10
        
        static let squiggleLeftTopToX: CGFloat = 12/10
        static let squiggleLeftTopToY: CGFloat = 5/10
        static let squiggleLeftTopCPX: CGFloat = 15/10
        static let squiggleLeftTopCPY: CGFloat = 2/10
        
        static let squiggleLeftBottomToX: CGFloat = 18/10
        static let squiggleLeftBottomToY: CGFloat = 9/10
        static let squiggleLeftBottomCPX: CGFloat = 10/10
        static let squiggleLeftBottomCPY: CGFloat = 8/10
        
        static let squiggleRightBottomToX: CGFloat = 18/10
        static let squiggleRightBottomToY: CGFloat = 5/10
        static let squiggleRightBottomCPX: CGFloat = 15/10
        static let squiggleRightBottomCPY: CGFloat = 8/10
        
        static let squiggleRightTopCPX: CGFloat = 20/10
        static let squiggleRightTopCPY: CGFloat = 2/10
        
        //diamondConstants
        
        static let diamondLeftX: CGFloat = 11/10
        static let diamondLeftY: CGFloat = 5/10
        
        static let diamondTopX: CGFloat = 15/10
        static let diamondTopY: CGFloat = 1/10
        
        static let diamondRightX: CGFloat = 19/10
        static let diamondRightY: CGFloat = 5/10
        
        static let diamondBottomX: CGFloat = 15/10
        static let diamondBottomY: CGFloat = 9/10
    }
    
    
}
