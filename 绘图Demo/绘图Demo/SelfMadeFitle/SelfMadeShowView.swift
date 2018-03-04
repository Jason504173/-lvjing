//
//  SelfMadeShowView.swift
//  绘图Demo
//
//  Created by xuwenhao on 2018/2/24.
//  Copyright © 2018年 Hiniu. All rights reserved.
//  显示的视图

import UIKit

class SelfMadeShowView: UIView {

    
    @IBAction func slideChanger(_ sender: Any) {
        fiterShowValue(value: sliderV.value)
    }
    
    @IBOutlet weak var sliderV: UISlider!
    override func awakeFromNib() {
        super.awakeFromNib()
        sliderV.value = 0.5
        sliderV.minimumValue = 0
        sliderV.maximumValue = 1
        sliderV.isContinuous  = true
        self.addSubview(fiterView)
    }
    
    func fiterShow(type:Int8)  {
        sliderV.value = 0.5
        fiterView.fitleType = type
        fiterShowValue(value: sliderV.value)
        
        
    }
    
    private func fiterShowValue(value:Float){
        fiterView.fiterRender(value: value)
    }
    
    private var fiterView : SelfMadeFitleView = {
        let view = SelfMadeFitleView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 50))
        return view
    }()
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let count = touches.first?.tapCount ?? 0
        if count >= 3 {
            self.removeFromSuperview()
        }
    }
    
}
