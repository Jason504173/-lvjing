//
//  DrawView.swift
//  绘图Demo
//
//  Created by xuwenhao on 2018/1/11.
//  Copyright © 2018年 Hiniu. All rights reserved.
//  画图的view

import Foundation
import UIKit

class DrawView: UIView {
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
//         drawline()
//        drawStack()
//        drawArc()
//        getPathInfo()
//        gradDraw()
        bindDraw()
    }
    
    //线
    func drawline()  {
        let cent = UIGraphicsGetCurrentContext()
        cent?.setFillColor(UIColor.gray.cgColor)//设置填充色
        cent?.fill(self.bounds) //填充
//        cent?.translateBy(x: 100, y: 100)//x y 偏移
//        cent?.scaleBy(x: 0.5, y: 0.5) // x y 缩放
//        cent?.rotate(by: CGFloat(Float.pi/6)) //旋转（顺时针）
//        let aff =  cent?.ctm //一份变换
        
        cent?.setLineWidth(5)  //线宽5
        cent?.setLineJoin(.round) //圆滑链接
        cent?.setMiterLimit(3)   //不太懂  倾斜限制？
        cent?.move(to: CGPoint.init(x: 10, y: 10))
        cent?.addLine(to: CGPoint.init(x: 100, y: 50))
        UIColor.purple.set()
        cent?.strokePath()//绘制
        
        cent?.setLineWidth(2)
        cent?.setAlpha(0.1)//透明度
        cent?.move(to: CGPoint.init(x: 10, y: 30))
        //虚线  phase:第一个绘制多少的时候开始绘制   length   绘制多少 跳过多少 反复
        cent?.setLineDash(phase: 3, lengths: [5,1,5])
        cent?.addLine(to: CGPoint.init(x: 100, y: 70))
        UIColor.red.set()
        cent?.strokePath()
     
    }
    // 矩形
    func drawStack(){
        let cent = UIGraphicsGetCurrentContext()
        cent?.setFillColor(UIColor.gray.cgColor)//设置填充色
        cent?.fill(self.bounds) //填充
        //**********************************************
//        let point1 = CGPoint.init(x: 10, y: 10)
//        let point2 = CGPoint.init(x: 100, y: 10)
//        let point3 = CGPoint.init(x: 10, y: 100)
//        let point4 = CGPoint.init(x: 100, y: 100)
//
//        cent?.move(to: point1)
//        cent?.addLine(to: point2)
//        cent?.addLine(to: point4)
//        cent?.addLine(to: point3)
//        cent?.closePath()
      
        //**********************************************
        let rect = CGRect.init(x: 10, y: 10, width: 90, height: 90)
        let path = UIBezierPath.init(rect: rect)
        //**********************************************
//        UIColor.red.set()
//        cent?.addRect(rect)
//        cent?.fillPath()
//
//
//        cent?.setLineWidth(3)
//        UIColor.black.set()
//        cent?.addPath(path.cgPath)
//        cent?.strokePath()
        
        UIColor.purple.set()
        cent?.setStrokeColor(UIColor.white.cgColor)
        cent?.setLineWidth(3)
        cent?.addPath(path.cgPath)
        cent?.drawPath(using: .fillStroke)
        cent?.strokePath()
        
        
        
    }
    //圆之类的⭕️
    func drawArc()  {
        let cent = UIGraphicsGetCurrentContext()
        cent?.setFillColor(UIColor.gray.cgColor)//设置填充色
        cent?.fill(self.bounds) //填充
        UIColor.purple.set()
        let rect = CGRect.init(x: 10, y: 10, width: 90, height: 90)
//        let path = UIBezierPath.init(rect: rect)
//                let point1 = CGPoint.init(x: 10, y: 10)
//                let point2 = CGPoint.init(x: 100, y: 10)
//                let point3 = CGPoint.init(x: 100, y: 100)
//                let point4 = CGPoint.init(x: 10, y: 100)

        cent?.addEllipse(in: rect)
        cent?.setStrokeColor(UIColor.yellow.cgColor)
        cent?.drawPath(using: .fillStroke)
        cent?.setLineWidth(2)
        cent?.strokePath()
    }
    //路径信息 、、
    func getPathInfo()  {
        let cent = UIGraphicsGetCurrentContext()
        cent?.setFillColor(UIColor.gray.cgColor)//设置填充色
        cent?.fill(self.bounds) //填充
//        let _ = cent?.isPathEmpty //是否有子路径
//        cent?.boundingBoxOfPath
        UIColor.red.set()
        let path = UIBezierPath.init(rect: CGRect.init(x: 10, y: 10, width: 90, height: 90))
        cent?.addPath(path.cgPath)
        cent?.fillPath()
         UIColor.yellow.set()
        let path1 = UIBezierPath.init(rect: CGRect.init(x: 50, y: 50, width: 90, height: 90))
        cent?.addPath(path1.cgPath)
        // 阴影 shadow
//        cent?.setShadow(offset: CGSize.init(width: 5, height: 5), blur: 0.6)
        cent?.setShadow(offset: CGSize.init(width: 10, height: 10), blur: 0.2, color: UIColor.lightGray.cgColor)
        cent?.fillPath()
   
    }
    
    //渐变
    func gradDraw()  {
        let cent = UIGraphicsGetCurrentContext()
        cent?.setFillColor(UIColor.gray.cgColor)//设置填充色
        cent?.fill(self.bounds) //填充
        let arry :[CGFloat] = [
            1,1,1,1.0,
            0.0,1.0,0.0,1.0,
            1.0,0.5,0.5,0.5
        ]
        let locaArry :[CGFloat] = [0,0.4,1]
        let grad = CGGradient.init(colorSpace: CGColorSpaceCreateDeviceRGB(), colorComponents: arry, locations: locaArry, count: locaArry.count)
       
        let point1 = CGPoint.init(x: 50, y: 50)
        let point2 = CGPoint.init(x: 100, y: 100)
        cent?.move(to: point1)
        cent?.addLine(to: point2)
        // CGGradientDrawingOptions  最后两位二进制数来判断效果  00 01 10 自己玩去
        cent?.drawRadialGradient(grad!, startCenter: point2, startRadius: 5, endCenter: point1, endRadius: 5, options: CGGradientDrawingOptions.init(rawValue: 3))
        cent?.strokePath()
    }
    
    //叠加我就写一个吧
    func bindDraw()  {
        let cent = UIGraphicsGetCurrentContext()
        cent?.setFillColor(UIColor.gray.cgColor)//设置填充色
        cent?.fill(self.bounds) //填充
        
        let path1 = UIBezierPath.init(rect: CGRect.init(x: 30, y: 70, width: 100, height: 30))
        let path2 = UIBezierPath.init(rect: CGRect.init(x: 70, y: 30, width: 30, height: 100))
        

        UIColor.purple.set()
        cent?.addPath(path1.cgPath)
        cent?.fillPath()
        
        UIColor.yellow.set()
        cent?.setBlendMode(.multiply)
        cent?.addPath(path2.cgPath)
        cent?.fillPath()
        
        /*  这个个人感觉  几种常用的就好
         R, S, and D are, respectively,
         premultiplied result, source, and destination colors with alpha; Ra,
         R 结果的颜色
         S 颜色源:自身颜色
         D 目标颜色：个人感觉就是除了自身的颜色
         
         case clear /* R = 0 */
         
         case copy /* R = S */
         
         case sourceIn /* R = S*Da */
         
         case sourceOut /* R = S*(1 - Da) */
         
         case sourceAtop /* R = S*Da + D*(1 - Sa) */
         
         case destinationOver /* R = S*(1 - Da) + D */
         
         case destinationIn /* R = D*Sa */
         
         case destinationOut /* R = D*(1 - Sa) */
         
         case destinationAtop /* R = S*(1 - Da) + D*Sa */
         
         case xor /* R = S*(1 - Da) + D*(1 - Sa) */
         
         case plusDarker /* R = MAX(0, (1 - D) + (1 - S)) */
         
         case plusLighter /* R = MIN(1, S + D) */
         */
        
        
    }
    
 
}

/*
 一些画图函数  oc 风格  可以转化为swift
 CGContextSaveGState：压栈操作，保存一份当前图形上下文
 CGContextRestoreGState：出栈操作，恢复一份当前图形上下文
 
 CTM（current transformation matrix当前转换矩阵）
 CGContextScaleCTM：坐标系X,Y缩放
 CGContextTranslateCTM：坐标系平移
 CGContextRotateCTM：坐标系旋转
 CGContextConcatCTM：
 CGContextGetCTM：获得一份CTM
 
 CGContextSetLineWidth：
 CGContextSetLineCap：
 CGContextSetLineJoin：
 CGContextSetMiterLimit：
 CGContextSetLineDash：
 CGContextSetFlatness：
 CGContextSetAlpha：//设置透明度
 
 CGContextSetBlendMode：
 
 CGContextBeginPath：
 CGContextMoveToPoint：画笔移动到该点开始画线
 CGContextAddLineToPoint：画直线到该点
 CGContextAddCurveToPoint：画三次曲线函数
 CGContextAddQuadCurveToPoint：画二次曲线
 
 CGContextClosePath：闭合曲线
 CGContextAddRect：画矩形
 CGContextAddRects：
 CGContextAddLines：
 
 CGContextAddEllipseInRect：椭圆
 
 CGContextAddArc：
 CGContextAddArcToPoint：
 
 CGContextAddPath：
 CGContextCopyPath：
 CGContextReplacePathWithStrokedPath：
 CGContextIsPathEmpty：表示目前的图形上下文是否包含任何的子路径。
 

 
 */




/*
 画图顺序
 UIGraphicsGetCurrentContext() //获取上下文
 setFillColor  //填充颜色
 
 
 */







