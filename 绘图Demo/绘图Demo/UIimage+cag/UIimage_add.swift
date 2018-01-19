//
//  UIimage_add.swift
//  绘图Demo
//
//  Created by xuwenhao on 2018/1/9.
//  Copyright © 2018年 Hiniu. All rights reserved.
//  主要是绘图  解压缩图片 颜色空间之类的  

import Foundation
import UIKit

extension UIImage{
    public class func imageWithColor(color:UIColor)->UIImage{
        let rect = CGRect.init(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let conent = UIGraphicsGetCurrentContext()
        conent?.setFillColor(color.cgColor)
        conent?.fill(rect)
//        let image = UIImage.init(cgImage: (conent?.makeImage()!)!)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    //解压缩图片
    public class func imageCodeWithFile(parm:UIImage?)->UIImage?{
        let image = parm
        guard image != nil else {
            return nil
        }
        let cgimg = image?.cgImage!
        let size = image?.size ?? CGSize.zero
        let alphaInfo : CGImageAlphaInfo = cgimg!.alphaInfo
        var hasAlpha = false
        switch alphaInfo {
        case .first,.last,.premultipliedFirst,.premultipliedLast:
            hasAlpha = true
        default:
            hasAlpha = false
        }
        
        let alph = hasAlpha ? CGImageAlphaInfo.premultipliedFirst : CGImageAlphaInfo.noneSkipFirst
        let bitInfo :CGBitmapInfo = CGBitmapInfo.init(rawValue: CGBitmapInfo.byteOrder32Big.rawValue | alph.rawValue)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let cent = CGContext.init(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitInfo.rawValue, releaseCallback: nil, releaseInfo: nil)
        
        guard cent != nil else {
            return nil
        }
        cent?.draw(cgimg!, in: CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        let newCgImage =  cent?.makeImage()
        guard newCgImage != nil else {
            return nil
        }
        let newImage = UIImage.init(cgImage: newCgImage!)
        return newImage
    }
 
    //灰度图
    public class func getGrayImg(image:UIImage) -> UIImage?{
        let size = image.size
        let bitInfo : CGBitmapInfo = CGBitmapInfo.init(rawValue: CGImageAlphaInfo.none.rawValue)
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let cent = CGContext.init(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitInfo.rawValue)
        guard cent != nil else {
            return nil
        }
        cent?.draw(image.cgImage!, in: CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        let newCgImage =  cent?.makeImage()
        guard newCgImage != nil else {
            return nil
        }
    
        let newImage = UIImage.init(cgImage: newCgImage!)
        return newImage
    }
    //某像素点颜色
    public func getColorWithPoint(point:CGPoint) ->UIColor{
        let sc_w = UIScreen.main.bounds.width
        let size = self.size
        //找到对应的像素点位置
        let bt = self.size.width/sc_w
        let real_x :CGFloat = CGFloat(Int(point.x)) * bt
        let real_y :CGFloat = CGFloat(Int(point.y)) * bt
        if !CGRect.init(x: 0, y: 0, width: size.width, height: size.height).contains(CGPoint.init(x: real_x, y: real_y)) {
            return UIColor.white
        }
        let bitInfo : CGBitmapInfo = CGBitmapInfo.init(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue )

        
        var pixData :[UInt8] = [0,0,0,0]  //这个需要
        let cent = CGContext.init(data: &pixData, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: bitInfo.rawValue)
        cent?.setBlendMode(.copy)
        cent?.translateBy(x: -real_x, y: real_y-size.height)
        cent?.draw(self.cgImage!, in: CGRect.init(origin: CGPoint.zero, size: size))
        guard cent != nil else {
            return UIColor.white
        }
        //获取RGB
        let red   = CGFloat( pixData[0])/255
        let green = CGFloat( pixData[1])/255
        let blue  = CGFloat( pixData[2])/255
        let alpha = CGFloat( pixData[3])/255
        return UIColor.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    //绘制圆角
    func roundImage(radius:CGFloat) ->UIImage? {
        let size = self.size
        let rect = CGRect.init(origin: CGPoint.zero, size: size)

        var radius = radius
        if size.width < radius {
            radius = size.width/2
        }
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.red.setFill()
        UIRectFill(rect)
        let path = UIBezierPath.init(roundedRect: rect, byRoundingCorners: .allCorners, cornerRadii: CGSize.init(width: radius, height: radius))
        path.addClip()
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    //设置倾斜
    func rountRaids(radi:CGFloat) -> UIImage? {
        
        let rect = CGRect.init(origin: CGPoint.zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let cent = UIGraphicsGetCurrentContext()
//        let tran = CGAffineTransform.identity.rotated(by: radi)
        cent?.translateBy(x: size.width/2, y: size.height/2)
//        cent?.rotate(by: CGFloat(Float.pi/6))
//        cent?.concatenate(tran)
        cent?.draw(self.cgImage!, in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    
    //添加水印
    func addText(title:String) -> UIImage? {
        let newSize = UIScreen.main.bounds.size
        let rect = CGRect.init(origin: CGPoint.zero, size: newSize)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
//        let cent = UIGraphicsGetCurrentContext()
        self.draw(in: rect)
        let font :CGFloat = 20
        let atts : [NSAttributedStringKey:Any] = [NSAttributedStringKey.foregroundColor:UIColor.red,NSAttributedStringKey.font:UIFont.systemFont(ofSize: font)]
        (title as NSString).draw(in: CGRect.init(x: 0, y: 0, width: size.width, height: 30), withAttributes: atts)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func scrimage(newSize:CGSize) ->UIImage? {
        let oldSize = self.size
//        let scr_w = newSize.width/oldSize.width
//        let scr_h = newSize.height/oldSize.height
        let rect = CGRect.init(origin: CGPoint.zero, size: newSize)
        let bitInfo : CGBitmapInfo = CGBitmapInfo.init(rawValue: CGImageAlphaInfo.none.rawValue)
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let cent = CGContext.init(data: nil, width: Int(newSize.width), height: Int(newSize.height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitInfo.rawValue)
        guard cent != nil else {
            return nil
        }
        let ciCent = CIContext.init(options: nil)
        let cgi = ciCent.createCGImage(self.ciImage!, from: CGRect.init(origin: CGPoint.zero, size: oldSize))
        cent?.interpolationQuality = .none
//        cent?.scaleBy(x: scr_w, y: scr_h)
        cent?.draw(cgi!, in: rect)
        let image = cent?.makeImage()
        return UIImage.init(cgImage: image!)
    }
    
}
