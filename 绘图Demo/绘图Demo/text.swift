//
//  text.swift
//  绘图Demo
//
//  Created by xuwenhao on 2018/1/10.
//  Copyright © 2018年 Hiniu. All rights reserved.
//   这里主要讲解下位图解压缩概念

import Foundation
import UIKit
let SCREEN_WIDTH  = UIScreen.main.bounds.width
let SCREEN_HEIGHT = UIScreen.main.bounds.height

func WLog<T>(_ message:T,file:String = #file,function :String = #function , line :Int = #line)  {
    let fileName = (file as NSString).lastPathComponent
    print("\(fileName): \(function) \(line) | \(message)")
}
/*
 主要看此文章
 http://www.cocoachina.com/ios/20170227/18784.html
 
 图片从文件中读取到显示到屏幕中 其实用了一系列处理过程
 1  取出图片 此时没有解压缩
 2  生成uiimage  传给uiimageview
 3  图层树结构改变   图片进行copy
     分配内存进行解压缩
     压缩的图片数据解码成未压缩位图形式
     渲染图层
 
 
 解压缩很耗时 我们可以开辟子线程进行强制解压缩
 位图：是一个像素数组  这个数组每个像素代表图中一个点
     (png格式是无损压缩  jpg有损压缩)
 强制解压缩：
 //CGBitmapContextCreate 已经不能能用了  用最新的方法
 CGContext.init(data: nil, width: 100, height: 100, bitsPerComponent: 8, bytesPerRow: 0, space: RGB, bitmapInfo: 自己写, releaseCallback: nil, releaseInfo: nil)

 参数含义：
 data ：如果不为 NULL ，那么它应该指向一块大小至少为 bytesPerRow * height 字节的内存；如果 为 NULL ，那么系统就会为我们自动分配和释放所需的内存，所以一般指定 NULL 即可；
 width 和 height ：位图的宽度和高度，分别赋值为图片的像素宽度和像素高度即可；
 bitsPerComponent ：像素的每个颜色分量使用的 bit 数，在 RGB 颜色空间下指定 8 即可；
 bytesPerRow ：位图的每一行使用的字节数，大小至少为 width * bytes per pixel 字节。有意思的是，当我们指定 0 时，系统不仅会为我们自动计算，而且还会进行 cache line alignment 的优化，
 space ：就是颜色空间，一般使用 RGB 即可；
 bitmapInfo ：就是我们位图的布局信息。
 
 
 //先说一些基本概念
 Pixel Format 像素格式
 包含下面信息
    Bits per component ：一个像素中每个独立的颜色分量使用的 bit 数；
    Bits per pixel ：一个像素使用的总 bit 数；
    Bytes per row ：位图中的每一行使用的字节数。
 
 颜色空间:
    其实就是格式  RGB BGR CMYK HSB ARGB RGBA 等等
 
 CGBitmapInfo 位图布局信息
 
 public struct CGBitmapInfo : OptionSet {
 public static var alphaInfoMask: CGBitmapInfo { get }
 public static var floatInfoMask: CGBitmapInfo { get }
 public static var floatComponents: CGBitmapInfo { get }
 public static var byteOrderMask: CGBitmapInfo { get }
 public static var byteOrder16Little: CGBitmapInfo { get }
 public static var byteOrder32Little: CGBitmapInfo { get }
 public static var byteOrder16Big: CGBitmapInfo { get }
 public static var byteOrder32Big: CGBitmapInfo { get }
 }
 包含下面信息
     alpha 的信息：       CGImageAlphaInfo
     颜色分量是否为浮点数 ： kCGBitmapFloatComponents
     像素格式的字节顺序   ： CGImageByteOrderInfo（kCGBitmapByteOrder32Host）
 
 
 
 
 
 
 
 */


/*
 CGBlendMode
 case kCGBlendModeNormal: {
 strMsg = @"kCGBlendModeNormal: 正常；也是默认的模式。前景图会覆盖背景图";
 
 case kCGBlendModeMultiply: {
 strMsg = @"kCGBlendModeMultiply: 正片叠底；混合了前景和背景的颜色，最终颜色比原先的都暗";
 
 case kCGBlendModeScreen: {
 strMsg = @"kCGBlendModeScreen: 滤色；把前景和背景图的颜色先反过来，然后混合";
 
 case kCGBlendModeOverlay: {
 strMsg = @"kCGBlendModeOverlay: 覆盖；能保留灰度信息，结合kCGBlendModeSaturation能保留透明度信息，在imageWithBlendMode方法中两次执行drawInRect方法实现我们基本需求";
 
 case kCGBlendModeDarken: {
 strMsg = @"kCGBlendModeDarken: 变暗";   //将线条色变为黑色，背景色设置为目的色
 
 case kCGBlendModeLighten: {
 strMsg = @"kCGBlendModeLighten: 变亮";
 
 case kCGBlendModeColorDodge: {
 strMsg = @"kCGBlendModeColorDodge: 颜色变淡";
 
 case kCGBlendModeColorBurn: {
 strMsg = @"kCGBlendModeColorBurn: 颜色加深";  //线条颜色（原本）加深，背景色设置为目的色
 
 case kCGBlendModeSoftLight: {
 strMsg = @"kCGBlendModeSoftLight: 柔光";
 
 case kCGBlendModeHardLight: {
 strMsg = @"kCGBlendModeHardLight: 强光";  //全为目的色
 
 case kCGBlendModeDifference: {
 strMsg = @"kCGBlendModeDifference: 插值";
 
 case kCGBlendModeExclusion: {
 strMsg = @"kCGBlendModeExclusion: 排除";
 
 case kCGBlendModeHue: {
 strMsg = @"kCGBlendModeHue: 色调";
 break;
 }
 case kCGBlendModeSaturation: {
 strMsg = @"kCGBlendModeSaturation: 饱和度";
 break;
 }
 case kCGBlendModeColor: {
 strMsg = @"kCGBlendModeColor: 颜色";   //感觉将图片线条色设置为白色，背景色设置为目的色，之后再再图片上加一个有透明度的目的色
 break;
 }
 case kCGBlendModeLuminosity: {
 strMsg = @"kCGBlendModeLuminosity: 亮度";
 break;
 }
 //Apple额外定义的枚举
 //R: premultiplied result, 表示混合结果
 //S: Source, 表示源颜色(Sa对应透明度值: 0.0-1.0)
 //D: destination colors with alpha, 表示带透明度的目标颜色(Da对应透明度值: 0.0-1.0)
 case kCGBlendModeClear: {
 strMsg = @"kCGBlendModeClear: R = 0"; //1.清空（如果图标背景色为白色则为全白）
 break;
 }
 case kCGBlendModeCopy: {
 strMsg = @"kCGBlendModeCopy: R = S";  //2全色覆盖整个图片
 break;
 }
 case kCGBlendModeSourceIn: {
 strMsg = @"kCGBlendModeSourceIn: R = S*Da";  //3.线条变色
 break;
 }
 case kCGBlendModeSourceOut: {
 strMsg = @"kCGBlendModeSourceOut: R = S*(1 - Da)";  //4.背景变为目的色,线条自动变为白色（比如图标线条原为蓝色，会自动变为白色）
 break;
 }
 case kCGBlendModeSourceAtop: {
 strMsg = @"kCGBlendModeSourceAtop: R = S*Da + D*(1 - Sa)";   //5.线条变色，目前感觉和SourceIn效果一致
 break;
 }
 case kCGBlendModeDestinationOver: {
 strMsg = @"kCGBlendModeDestinationOver: R = S*(1 - Da) + D";  //6.背景色变为目的色，线条色不变
 break;
 }
 case kCGBlendModeDestinationIn: {
 strMsg = @"kCGBlendModeDestinationIn: R = D*Sa；能保留透明度信息";  //7.只看到线条色（本色），无其他颜色
 break;
 }   case kCGBlendModeDestinationOut: {
 strMsg = @"kCGBlendModeDestinationOut: R = D*(1 - Sa)";     //8.空白什么都没哟
 break;
 }
 case kCGBlendModeDestinationAtop: {
 strMsg = @"kCGBlendModeDestinationAtop: R = S*(1 - Da) + D*Sa";  //9.会把整个矩形的背景填充目的色（如图9系列）原色保留
 break;
 }
 case kCGBlendModeXOR: {
 strMsg = @"kCGBlendModeXOR: R = S*(1 - Da) + D*(1 - Sa)";  //10.线条变白，背景色变为目的色
 break;
 }
 case kCGBlendModePlusDarker: {
 strMsg = @"kCGBlendModePlusDarker: R = MAX(0, (1 - D) + (1 - S))";  //11.线条变为黑色， 背景色变为目的色
 break;
 }
 case kCGBlendModePlusLighter: {
 strMsg = @"kCGBlendModePlusLighter: R = MIN(1, S + D)（最后一种混合模式）";  //12.线条变为白色（混合色：如color为红色，就是偏粉色的白，有一定透明度的感觉）
 break;
 }
 default: {
 break;
 }
 */

