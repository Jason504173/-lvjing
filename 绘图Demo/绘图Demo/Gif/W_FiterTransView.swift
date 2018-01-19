//
//  W_FiterTransView.swift
//  绘图Demo
//
//  Created by xuwenhao on 2018/1/19.
//  Copyright © 2018年 Hiniu. All rights reserved.
//

import UIKit

class W_FiterTransView: UIView {

    private let imgV = UIImageView()
    private var dislink : CADisplayLink?
    private var datModel : FileModel?
    var curTime:Float = 0
    let DefFramSecone :Int = 60
    override init(frame: CGRect) {
        super.init(frame: frame)
        imgV.frame = self.bounds
        imgV.backgroundColor = UIColor.white
        self.addSubview(imgV)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func starGif(model:FileModel)  {
        guard model.fileName != nil && !model.parmDic.isEmpty else {
            return
        }
        datModel = model
        curTime = 0
        if dislink != nil {
            dislink?.remove(from: RunLoop.current, forMode: .commonModes)
            dislink?.invalidate()
        }
        dislink = CADisplayLink.init(target: self, selector: #selector(refshUI))
        dislink?.preferredFramesPerSecond = DefFramSecone //每秒30帧
        dislink?.isPaused = false
        dislink?.add(to: RunLoop.current, forMode: .commonModes)
    }

    
    private let buildQue = DispatchQueue.init(label: "build_1_image") //并行 子线程

    @objc func refshUI()  {
        if curTime >= 1 {
            curTime = 0
        }
        datModel?.parmDic[kCIInputTimeKey] = curTime
        buildQue.async {//线程
//            print("线程里面")
            self.buildNewImage()
        }
//        print("curm=\(curTime)")
        curTime += Float(1.0/Float(DefFramSecone))
    }

    private func buildNewImage(){
        let newImage = UIImage.fiterImageWithModel(model: datModel!)
        DispatchQueue.main.async {
            self.imgV.image = newImage
        }
    }
    
}















