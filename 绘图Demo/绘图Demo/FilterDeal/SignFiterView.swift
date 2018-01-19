//
//  SignFiterView.swift
//  绘图Demo
//
//  Created by xuwenhao on 2018/1/16.
//  Copyright © 2018年 Hiniu. All rights reserved.
//

import UIKit

let BlockArry = ["CILineOverlay","CIAttributedTextImageGenerator","CITextImageGenerator"]


class SignFiterView: UIView {
    
    @IBOutlet weak var imageH: NSLayoutConstraint!
    
    @IBOutlet weak var subLb: UILabel!
    @IBOutlet weak var supLb: UILabel!
    @IBAction func btnClick(_ sender: Any) {
        alerView.refshUI(dic: parmDic, par: dataModel.parmDic)
        self.addSubview(alerView)
    }
    private var dataModel = FileModel()
    private var parmDic = [String:Any]()
    @IBOutlet weak var imageV: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func refshUI(model:FileModel)  {
        dataModel = model
        subLb.text = model.fileName
        supLb.text = model.supName
        imageV.image = nil
        if BlockArry.contains(model.fileName!) {
            imageV.backgroundColor = UIColor.white
            imageV.contentMode = .center
        }else{
            imageV.contentMode = .scaleToFill
            imageV.backgroundColor = UIColor.black
        }
        
        
        
        if model.supName == kCICategoryGenerator || model.supName == kCICategoryGradient {
            imageH.constant = SCREEN_WIDTH 
        }else{
            let ciimg = dataModel.parmDic[kCIInputImageKey] as? CIImage
            guard ciimg != nil && model.fileName != nil else {
                return
            }
            let size = ciimg?.extent.size ?? CGSize.zero
            guard size != CGSize.zero else {
                return
            }
            imageH.constant = SCREEN_WIDTH * size.height/size.width
        }
        
        reSetImage()
        let filt : CIFilter  = CIFilter.init(name: model.fileName!)!
        parmDic = filt.attributes
        alerView.valueClick = {[unowned self] obj in
            let obj = obj as! [String:Any]
            self.repliceNewParm(dic: obj)
        }
    }
    
    func repliceNewParm(dic:[String:Any])  {
        for (key,value) in dic {
            dataModel.parmDic[key] = value
        }
        reSetImage()
    }
    
    //这个是做图片的
    private let buildQue = DispatchQueue.init(label: "build_image") //并行 子线程
    private func reSetImage(){ //不管什么原因过来就需要重新刷新图片
        guard  dataModel.fileName != nil else {
            return
        }
//        let semap = DispatchSemaphore.init(value: 1)  不用信号量了
        buildQue.async {//线程
            self.buildNewImage()
        }
    }
    
    private func buildNewImage(){
        let newImage = UIImage.fiterImageWithModel(model: dataModel)
        dataModel.image = newImage
        DispatchQueue.main.async {
            self.imageV.image = newImage
        }
        
    }
    
    
    
    
    
    
    
    

    private var alerView : SeleAlerView = {
        let v = Bundle.main.loadNibNamed("SeleAlerView", owner: self, options: nil)?.first as! SeleAlerView
        v.frame = CGRect.init(x: 0, y: SCREEN_HEIGHT - 250, width: SCREEN_WIDTH, height: 250)
        return v
    }()

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let num = touches.first?.tapCount ?? 0
        if num >= 3 {
            UIView.animate(withDuration: 0.25, animations: {
                self.frame = CGRect.init(origin: CGPoint.init(x: SCREEN_WIDTH, y: self.frame.origin.y), size: self.frame.size)
            }) { (flg) in

                self.alerView.removeFromSuperview()
                self.removeFromSuperview()
            }
        }else if num == 2{
            self.alerView.removeFromSuperview()
        }
    }
    
 
}
