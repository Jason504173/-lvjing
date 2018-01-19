//
//  SeleAlerView.swift
//  绘图Demo
//
//  Created by xuwenhao on 2018/1/16.
//  Copyright © 2018年 Hiniu. All rights reserved.
//  这个是选择控件

import UIKit

typealias W_SwiftBlock = (Any) -> ()

class SeleAlerView: UIView ,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var slide_Y: UISlider!
    @IBOutlet weak var infoLb: UILabel!
    @IBOutlet weak var tabV: UITableView!
    @IBOutlet weak var slider_X: UISlider!
    
    private var seleKey = String()
    private var seleIndex = 0
    private var parmDic = [String:Any]()//这个是传过来的参数
    private var valueDic = [String:Any]()//这个是值
    
    //中心点坐标
    private let pointKeys = [kCIInputCenterKey,"inputInsetPoint1","inputInsetPoint0","inputBreakpoint0","inputBreakpoint1","inputGrowAmount","inputPoint0","inputPoint1"]
    
 
    //这个是颜色的  单个四维
    private let colorKeys = ["inputRVector","inputGVector","inputBVector","inputAVector","inputRedCoefficients","inputGreenCoefficients","inputBlueCoefficients","inputAlphaCoefficients"]
    
    
    //这个是数值key 最简单
    private let numKeys = [kCIInputScaleKey ,kCIInputRadiusKey,kCIInputAngleKey,"inputZoom","inputRotation","inputStrands","inputPeriodicity",kCIInputWidthKey,kCIInputSharpnessKey,"inputUCR","inputGCR",kCIInputSaturationKey,kCIInputBrightnessKey,kCIInputContrastKey,kCIInputEVKey,"inputPower","inputAmount","inputFalloff",kCIInputIntensityKey,"inputCubeDimension","inputLevels","inputStriationStrength","inputFadeThreshold","inputMaxStriationRadius","inputTime","inputStriationContrast","inputFoldShadowAmount","inputNumberOfFolds","inputBottomHeight","inputBarOffset","inputShadowDensity","inputShadowRadius","inputShadowOffset","inputShadowDensity","inputOpacity","inputRingSize","inputSoftness","inputRingAmount","inputLayers","inputCompactStyle","inputQuietSpace","inputCrossScale","inputCrossAngle","inputCrossOpacity","inputCrossWidth","inputEpsilon","inputSunRadius","inputHaloRadius","inputHaloWidth","inputHaloOverlap","inputStriationStrength","inputStriationContrast","inputHeight","inputHighLimit","inputLowLimit","inputBias","inputRadius0","inputRadius1","inputDither","inputValue","inputSoftness","inputDither","inputSaturation","inputUnsharpMaskRadius","inputUnsharpMaskIntensity","inputHighlightAmount","inputShadowAmount","inputNRNoiseLevel","inputNRSharpness","inputEdgeIntensity","inputThreshold","inputContrast","inputCloseness1","inputContrast1","inputCloseness2","inputContrast2","inputCloseness3","inputContrast3","inputBrightness","inputConcentration",kCIInputSharpnessKey,kCIInputScaleFactorKey,"inputBarcodeHeight","inputMinWidth","inputMaxWidth","inputMinHeight","inputDataColumns","inputRows","inputPreferredAspectRatio","inputCompactionMode","inputCompactStyle","inputAlwaysSpecifyCompaction"]
    //信息keys
    private let infoKeys = [kCIAttributeFilterAvailable_iOS,kCIAttributeFilterDisplayName,kCIAttributeFilterAvailable_Mac,kCIAttributeFilterName,kCIAttributeReferenceDocumentation]
    
    //这个是最大颜色最小颜色融合的
    private let maxminComkeys = ["inputMaxComponents","inputMinComponents"]
    
    private let naturKeys = ["inputNeutral","inputTargetNeutral"]
    
    override func awakeFromNib() {
        infoLb.font = UIFont.systemFont(ofSize: 11)
        tabV.delegate = self
        tabV.dataSource  = self
        slider_X.addTarget(self, action: #selector(valueChange(slide:)), for: .valueChanged)
        slide_Y.addTarget(self, action: #selector(valueChange(slide:)), for: .valueChanged)
    }
    
    var valueClick : W_SwiftBlock?
    @objc func valueChange(slide:UISlider){
        guard !seleKey.isEmpty && valueClick != nil else {
            return
        }
        let value = slide.value
        
        if pointKeys.contains(seleKey) {
            let x = slider_X.value
            let y = slide_Y.value
            let civ = CIVector.init(x: CGFloat(x), y: CGFloat(y))
            valueDic[seleKey] = civ
            valueClick!([seleKey:civ])
        }else if maxminComkeys.contains(seleKey){
            let x :CGFloat = CGFloat(slider_X.value)
            let y :CGFloat = CGFloat(slide_Y.value)
            let civ = CIVector.init(x: x, y: x, z: y, w: y)
            valueDic[seleKey] = civ
            valueClick!([seleKey:civ])
        }else if colorKeys.contains(seleKey){
             valueDic[seleKey] = value
             let civarry = colorKeys.map({
                return CGFloat($0 == seleKey ? value : 0)
             })
             let civ = CIVector.init(x: civarry[0], y: civarry[1], z: civarry[2], w: civarry[3])
             valueClick!([seleKey:civ])
            
        }else if naturKeys.contains(seleKey) {
            let x = slider_X.value
            let y = slide_Y.value
            let civ = CIVector.init(x: CGFloat(x), y: CGFloat(y))
            valueDic[seleKey] = civ
            valueClick!([seleKey:civ])
            
        } else if numKeys.contains(seleKey){
            valueDic[seleKey] = value
            valueClick!([seleKey:value])
        }
    }
    
    func refshUI(dic:[String:Any],par:[String:Any])  {
        valueDic = par
        parmDic = dic
        seleIndex = 0
        infoLb.text = ""
        refshSlide(index: seleIndex)
        tabV.contentOffset = CGPoint.zero
        tabV.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let arry = [String](parmDic.keys)
        return arry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        }
        cell?.selectionStyle = .none
        let arry = [String](parmDic.keys)
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 10)
        cell?.textLabel?.text = arry[indexPath.row]
        cell?.textLabel?.textColor = indexPath.row == seleIndex ? UIColor.red : UIColor.gray
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        seleIndex = indexPath.row
        refshSlide(index: seleIndex)
        tableView.reloadData()
    }
    
    func refshSlide(index:Int)  {
        let count = parmDic.count
        guard count > 0 else {
            return
        }
        let arry = [String](parmDic.keys)
        let key = arry[index]
        let value = parmDic[key]
        slide_Y.isHidden = true
        slider_X.isHidden = false
        seleKey = ""
     
        
        if infoKeys.contains(key) {
            infoLb.text = "\(key) = \(value ?? "**")"
            slider_X.isHidden = true
        }else if numKeys.contains(key){
            let value = value as! [String:Any]
            infoLb.text = value[kCIAttributeDescription] as? String
            let max = value[kCIAttributeSliderMax] as? Float
            let min = value[kCIAttributeSliderMin] as? Float
            slider_X.maximumValue = max ?? 0
            slider_X.minimumValue = min ?? 0
            let curn = valueDic[key] as? Float
            let cureNum = value[kCIAttributeDefault] as? Float
            if curn != nil{
                slider_X.value = curn!
            }else{
                slider_X.value = cureNum ?? 0
            }
            seleKey = key
        }else if pointKeys.contains(key){ //这个需要改进
            slide_Y.isHidden = false
            let value = value as! [String:Any]
            infoLb.text = value[kCIAttributeDescription] as? String
            let centPoint = (value[kCIAttributeDefault] as? CIVector) ?? CIVector.init(x: 0, y: 0)
            let ciimage = valueDic[kCIInputImageKey] as? CIImage
           
            let size = ciimage?.extent.size ?? CGSize.init(width: SCREEN_WIDTH, height: SCREEN_WIDTH)
            slider_X.minimumValue = 0
            slider_X.maximumValue = Float(size.width)
            slide_Y.minimumValue = 0
            slide_Y.maximumValue = Float(size.height)
            let curn = valueDic[key] as? CIVector
            if curn != nil{
                slider_X.value = Float(curn!.x)
                slide_Y.value  = Float(curn!.y)
            }else{
                slider_X.value = Float(centPoint.x)
                slide_Y.value  = Float(centPoint.y)
            }
            seleKey = key
        }else if colorKeys.contains(key){
            slider_X.minimumValue = 0
            slider_X.maximumValue = 1
            let curn = valueDic[key] as? Float
            slider_X.value = curn ?? 1
            seleKey = key
        }else if key == kCIAttributeFilterCategories{
            let value = value as! [String]
            var info = ""
            for str in value{
                info += (str + "\n")
            }
            infoLb.text = """
            所属类型:
            \(info)
            """
            slider_X.isHidden = true
        }else if maxminComkeys.contains(key){
            let value = value as! [String:Any]
            slide_Y.isHidden = false
            infoLb.text = value[kCIAttributeDescription] as? String
            slider_X.minimumValue = 0
            slider_X.maximumValue = 1
            slide_Y.minimumValue = 0
            slide_Y.maximumValue = 1
            let curn = (valueDic[key] as? CIVector) ?? CIVector.init()
            slider_X.value = Float(curn.x)
            slide_Y.value = Float(curn.z)
            seleKey = key
        }else if naturKeys.contains(key){
            let value = value as! [String:Any]
            slide_Y.isHidden = false
            infoLb.text = value[kCIAttributeDescription] as? String
            slider_X.minimumValue = 0
            slider_X.maximumValue = 6500*2
            slide_Y.minimumValue = 0
            slide_Y.maximumValue = 1
            let curn = (valueDic[key] as? CIVector) ?? CIVector.init()
            slider_X.value = Float(curn.x)
            slide_Y.value = Float(curn.y)
            seleKey = key
        }else{
            let value = value as? [String:Any]
            slider_X.isHidden = true
            infoLb.text = value?[kCIAttributeDescription] as? String
        }
  
    }

}

/*
 @available(iOS 5.0, *)
 public let kCIOutputImageKey: String
 @available(iOS 5.0, *)
 public let kCIInputBackgroundImageKey: String
 @available(iOS 5.0, *)
 public let kCIInputImageKey: String  /图片  但并不是数据只是描述
 @available(iOS 11.0, *)
 public let kCIInputDepthImageKey: String
 @available(iOS 11.0, *)
 public let kCIInputDisparityImageKey: String
 @available(iOS 7.0, *)
 public let kCIInputTimeKey: String
 @available(iOS 7.0, *)
 public let kCIInputTransformKey: String
 @available(iOS 7.0, *)
 public let kCIInputScaleKey: String  //一种变换 -1 到 1 默认0
 @available(iOS 7.0, *)
 public let kCIInputAspectRatioKey: String
 @available(iOS 7.0, *)
 public let kCIInputCenterKey: String  //中心位置
 @available(iOS 7.0, *)
 public let kCIInputRadiusKey: String  //斜着一条波峰滑过
 @available(iOS 7.0, *)
 public let kCIInputAngleKey: String   //角度 0 - 2pi  默认是哦 很像一个图片下有什么东西顶着
 @available(iOS 9.0, *)
 public let kCIInputRefractionKey: String
 @available(iOS 7.0, *)
 public let kCIInputWidthKey: String
 @available(iOS 7.0, *)
 public let kCIInputSharpnessKey: String
 @available(iOS 7.0, *)
 public let kCIInputIntensityKey: String
 @available(iOS 7.0, *)
 public let kCIInputEVKey: String
 @available(iOS 7.0, *)
 public let kCIInputSaturationKey: String
 @available(iOS 7.0, *)
 public let kCIInputColorKey: String
 @available(iOS 7.0, *)
 public let kCIInputBrightnessKey: String
 @available(iOS 7.0, *)
 public let kCIInputContrastKey: String
 @available(iOS 9.0, *)
 public let kCIInputBiasKey: String
 @available(iOS 9.0, *)
 public let kCIInputWeightsKey: String
 @available(iOS 9.0, *)
 public let kCIInputGradientImageKey: String
 @available(iOS 7.0, *)
 public let kCIInputMaskImageKey: String
 @available(iOS 9.0, *)
 public let kCIInputShadingImageKey: String
 @available(iOS 7.0, *)
 public let kCIInputTargetImageKey: String
 @available(iOS 7.0, *)
 public let kCIInputExtentKey: String
 @available(iOS 6.0, *)
 public let kCIInputVersionKey: String
 */
