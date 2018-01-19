//
//  UIimage+Filter.swift
//  绘图Demo
//
//  Created by xuwenhao on 2018/1/15.
//  Copyright © 2018年 Hiniu. All rights reserved.
//  这个主要是加滤镜之类的

import Foundation
import UIKit
extension UIImage   {
    
    func fiterImageName(type:String) ->UIImage? {
        let input = CIImage.init(cgImage: self.cgImage!)
        let filt = CIFilter.init(name: type)
        filt?.setValue(input, forKey: kCIInputImageKey)
//        filt?.setValue(3, forKey: kCIInputScaleKey)
//        filt?.setValue(Float.pi/3, forKey: kCIInputAngleKey)
//        filt?.setValue(CIColor.init(color: UIColor.red), forKey: kCIInputColorKey)
//        filt?.setValue(0.5, forKey: kCIInputIntensityKey)
        let cent = CIContext.init(options: nil)
        let outImg = filt?.outputImage
        guard outImg != nil else {
            return self
        }
        let newImage =  cent.createCGImage(outImg!, from: (outImg?.extent)!)
        guard newImage != nil else {
            return self
        }
        return UIImage.init(cgImage: newImage!)
    }
    
    //二维码
     class func fiterCodeimage(title:String) ->UIImage? {
        let data = title.data(using: .utf8)
        let filt = CIFilter.init(name: "CIQRCodeGenerator")
        filt?.setDefaults()
        filt?.setValue(data, forKey: "inputMessage")
        let outimg = filt?.outputImage  //放大图再说 这个尺寸太小了
        guard outimg != nil else {
            return nil
        }
        let orignImage = UIImage.init(ciImage: outimg!) //
        return orignImage.scrimage(newSize: CGSize.init(width: SCREEN_WIDTH, height: SCREEN_WIDTH))
    }

    //加马赛克
    func addMSK(leave:Int) ->UIImage? {
        let cent = CIContext.init(options: nil)
        let filter = CIFilter.init(name: "CIPixellate")
        let inputImage = CIImage.init(image: self)
        let vect = CIVector.init(x: size.width/2, y: size.height/2)
        filter?.setDefaults()
        filter?.setValue(vect, forKey: "inputCenter")
        filter?.setValue(leave, forKey: "inputScale")
        filter?.setValue(inputImage!, forKey: "inputImage")
        let cgimage =  cent.createCGImage((filter?.outputImage)!, from: (filter?.outputImage?.extent)!)
        let newImage = UIImage.init(cgImage: cgimage!, scale: self.scale, orientation: self.imageOrientation)
        return newImage
    }
    
    
    //用model 生成的图片
    
     class func fiterImageWithModel(model:FileModel) -> UIImage?{
        guard model.fileName != nil && model.supName != nil else {
            return placHoldImage
        }
        if model.fileName == "CIColorCubesMixedWithMask" {//这个真是日了狗了
            return placHoldImage
        }      
        
        let filte = CIFilter.init(name: model.fileName!, withInputParameters: model.parmDic)
        let outciImage : CIImage? = filte?.outputImage
        guard outciImage != nil else {
            return placHoldImage
        }
//        let newImage = UIImage.init(ciImage: outciImage!)
//        return newImage
        let cent = CIContext.init(options: nil)
        var rect = outciImage?.extent ?? CGRect.zero
        if rect.width > 1e5 || rect.height > 1e5 {
            rect = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_WIDTH)
        }
        
        let newciImage = cent.createCGImage(outciImage!, from: rect)
        guard newciImage != nil else {
            return placHoldImage
        }
        return UIImage.init(cgImage: newciImage!)
    }
}

let placHoldImage = UIImage.init(named: "22222.jpg")


/*
 CIImage类用于描述一张图片. CoreImage的图片是不可变的. 通过将CIImage对象与其它Core Image的类(比如CIFilter, CIContext, CIVector, 和CIColor)结合, 实现利用Core Image内建的滤镜来进行图片处理. 根据多种来源提供的数据来创建CIImage对象, 包括Quartz 2D, Core Video图像缓存(CVImageBufferRef), 基于URL的对象, 和NSData对象.
 尽管CIImage对象拥有与之关联的图片数据, 但本质上并不是一张图片. 你可以它CIImage对象为一个图片的"配方". CIImage对象拥有生成一张图片所具备的所有信息, 但Core Image并不会真正的去渲染一张图片, 除非被要求这么做. 这种"延迟计算(lzay evaluation)"方式让Core Image的操作尽可能的高效.
 CIContext和CIImage对象都是不可修改的, 意味着它们可以在线程之间安全的共享. 多个线程可以使用同样的GPU或者CPU的CIContext对象来渲染CIImage对象. 然而, CIFilter对象的情况则不同, 它是可以被修改的. CIFilter对象不能在线程之间安全的共享. 如果你的App是支持多线程的, 每一个线程都需要创建自己的CIFilter对象. 否则App的行为将出乎你的意料.
 
 Core Image提供了为图片分析常见缺陷并自动调整修复的方法. 提供一系列用来纠正这些不足的滤镜. 通过为滤镜预设相关值, 实现如变更色调, 饱合度, 对比度, 阴影, 去除红眼或其它闪光伪迹, 来提高图片的质量.
 CoreImage
 （2）是一个图像框架 它基于OpenGL顶层创建底层则用着色器来处理图像
 （3）它利用了GPU基于硬件加速来处理图像
 （4）CoreImage中有很多滤镜
 （5）它们能够一次给予一张图像或者视频帧多种视觉效果 -> 滤镜链
 （6）而且滤镜可以连接起来组成一个滤镜链 把滤镜效果叠加起来处理图像
 
 //下面是所有滤镜分类  我们可以一个一个测试  反正有时间
 
 public let kCICategoryDistortionEffect: String 扭曲效果
 public let kCICategoryGeometryAdjustment: String
 public let kCICategoryCompositeOperation: String
 public let kCICategoryHalftoneEffect: String
 public let kCICategoryColorAdjustment: String 色彩调整
 public let kCICategoryColorEffect: String
 public let kCICategoryTransition: String
 public let kCICategoryTileEffect: String  //瓦片效果
 public let kCICategoryGenerator: String
 @available(iOS 5.0, *)
 public let kCICategoryReduction: String
 public let kCICategoryGradient: String
 public let kCICategoryStylize: String
 public let kCICategorySharpen: String
 public let kCICategoryBlur: String   高斯
 public let kCICategoryVideo: String  视频
 public let kCICategoryStillImage: String
 public let kCICategoryInterlaced: String
 public let kCICategoryNonSquarePixels: String
 public let kCICategoryHighDynamicRange: String
 public let kCICategoryBuiltIn: String
 @available(iOS 9.0, *)
 public let kCICategoryFilterGenerator: String

 常用的
 //怀旧-->CIPhotoEffectInstant单色-->CIPhotoEffectMono
 //黑白-->CIPhotoEffectNoir褪色-->CIPhotoEffectFade
 //色调-->CIPhotoEffectTonal冲印-->CIPhotoEffectProcess
 //岁月-->CIPhotoEffectTransfer铬黄-->CIPhotoEffectChrome
 */


