//
//  ViewController.swift
//  绘图Demo
//
//  Created by xuwenhao on 2018/1/9.
//  Copyright © 2018年 Hiniu. All rights reserved.
//  主要研究 Core Graphics  绘制图片  然后滤镜

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var colorImageV: UIImageView!
    @IBOutlet weak var imgHlayout: NSLayoutConstraint!
    
    @IBOutlet weak var imgWlayout: NSLayoutConstraint!
    
    @IBOutlet weak var imageV: UIImageView!
    private var image = UIImage.init(named: "22222.jpg")!

    private let draV = DrawView.init(frame: CGRect.init(x: 40, y: 100, width: 200, height: 200))
    override func viewDidLoad() {
        super.viewDidLoad()
//        imageV.contentMode = .scaleAspectFit
        
        
        
        
//        let image1 = UIImage.init(named: "IMG_0888.jpg")
//        let image2 = UIImage.init(named: "IMG_0888.jpg")
//        if (image1?.isEqual(image2))! {
//            print("-====")
//        }
//        if image1 == image2 {
//            print("***********")
//
//        }
//        move()
//        scarFunc()
//        imageColor()
//        viewRound()
//        recodeImg()
//        grayimage()
//        imageRound()
//        roateImage()
//        mskImage()
//        self.view.addSubview(draV)
        self.view.addSubview(filtView)
    }
 
    //平移
    func move()  {
        let size = image.size
        UIGraphicsBeginImageContextWithOptions(CGSize.init(width: size.width*2, height: size.height), false, 0)
        image.draw(at: CGPoint.zero)
        image.draw(at: CGPoint.init(x: size.width, y: 0))
        let newImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        imageV.image = newImg
        let wh = size.width/size.height
        imgHlayout.constant = imgWlayout.constant / wh
    }
    
    func scarFunc()  {
        let size = image.size
        let newSize = CGSize.init(width: size.width*1.5, height: size.height*1.5)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        image.draw(in: CGRect.init(origin: CGPoint.zero, size: newSize))
        image.draw(in: CGRect.init(x: newSize.width/4, y: newSize.height/4, width: newSize.width/2, height: newSize.height/2), blendMode: .plusDarker, alpha: 1)
        let newImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        imageV.image = newImg
        let wh = size.width/size.height
        imgHlayout.constant = imgWlayout.constant / wh

    }
    
    func imageColor()  {
        let image = UIImage.imageWithColor(color: UIColor.lightGray)
        colorImageV.image = image
         
    }
    
    func viewRound()  {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 50))
        self.view.addSubview(view)
        view.backgroundColor = UIColor.red
        view.center = self.view.center
        let maspath = UIBezierPath.init(roundedRect: view.bounds, byRoundingCorners: UIRectCorner(rawValue: UIRectCorner.topLeft.rawValue|UIRectCorner.bottomRight.rawValue), cornerRadii: CGSize.init(width: 10, height: 10))
        let shaLayer = CAShapeLayer.init()
        shaLayer.frame = view.bounds
        shaLayer.path = maspath.cgPath
        view.layer.mask = shaLayer
    }
    
    func imageRound()  {
        let origimg =  UIImage.init(named: "IMG_0888.jpg")
        let newImage = origimg?.roundImage(radius: 500)
        let size = origimg?.size ?? CGSize.zero
        let wh = size.width/size.height
        imgHlayout.constant = imgWlayout.constant / wh
        imageV.image = newImage
    }
    
    func roateImage()  {
        let origimg =  UIImage.init(named: "IMG_0888.jpg")
        let newImage = origimg?.rountRaids(radi: CGFloat(Float.pi/6))
        let size = origimg?.size ?? CGSize.zero
        let wh = size.width/size.height
        imgHlayout.constant = imgWlayout.constant / wh
        imageV.image = newImage
    }
    
    
    //强制解压缩文件 然后绘制图片
    func recodeImg()  {
        let origimg =  UIImage.init(named: "IMG_0888.jpg")
        let size = origimg?.size ?? CGSize.zero
        let wh = size.width/size.height
        imgHlayout.constant = imgWlayout.constant / wh
//        imageV.image = UIImage.imageCodeWithFile(parm: origimg)
//       imageV.image = origimg?.addText(title: "2010-09-09")
        imageV.image = UIImage.fiterCodeimage(title: "你个傻瓜！")
    }
    
    //灰色图片
    func grayimage()  {
        let origimg =  UIImage.init(named: "IMG_0888.jpg")
        let size = origimg?.size ?? CGSize.zero
        let wh = size.width/size.height
        imgHlayout.constant = imgWlayout.constant / wh
        imageV.image = UIImage.getGrayImg(image: origimg!)
    }

    //马赛克
    func mskImage()  {
        let origimg =  UIImage.init(named: "IMG_0888.jpg")
        let size = origimg?.size ?? CGSize.zero
        let wh = size.width/size.height
        imgHlayout.constant = imgWlayout.constant / wh
        imageV.image = origimg?.addMSK(leave: 50)
    }
    
 
    
    
    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let touch = touches.first
//        let point = touch?.location(in: imageV)
//        if imageV.bounds.contains(point!) {//如果包含这个点 就去吧
//            let color = imageV.image?.getColorWithPoint(point: point!)
//            let newImage = UIImage.imageWithColor(color: color!)
//            colorImageV.image = newImage
//
//        }
//    }
    
    
    //懒加载
    private lazy var filtView : FilerCatListView = {
        let v = Bundle.main.loadNibNamed("FilerCatListView", owner: self, options: nil)?.first as! FilerCatListView
        v.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        return v
    }()
    
    
    
    
}





