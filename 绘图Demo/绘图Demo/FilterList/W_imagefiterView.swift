//
//  W_imagefiterView.swift
//  绘图Demo
//
//  Created by xuwenhao on 2018/1/16.
//  Copyrigh t © 2018年 Hiniu. All rights reserved.
//  滤镜分类的视图

import UIKit

//不需要图片的滤镜数组
let NoimagebulArry  = ["CIAttributedTextImageGenerator", "CIAztecCodeGenerator", "CIBarcodeGenerator", "CICheckerboardGenerator", "CICode128BarcodeGenerator", "CIConstantColorGenerator", "CILenticularHaloGenerator", "CIPDF417BarcodeGenerator", "CIQRCodeGenerator", "CIRandomGenerator", "CIStarShineGenerator", "CIStripesGenerator", "CISunbeamsGenerator", "CITextImageGenerator","CIGaussianGradient","CILinearGradient","CIRadialGradient","CISmoothLinearGradient","CIHueSaturationValueGradient"]

//有背景图片的滤镜数组
let BackImageArry  = ["CIAdditionCompositing", "CIColorBlendMode", "CIColorBurnBlendMode", "CIColorDodgeBlendMode", "CIDarkenBlendMode", "CIDifferenceBlendMode", "CIDivideBlendMode", "CIExclusionBlendMode", "CIHardLightBlendMode", "CIHueBlendMode", "CILightenBlendMode", "CILinearBurnBlendMode", "CILinearDodgeBlendMode", "CILuminosityBlendMode", "CIMaximumCompositing", "CIMinimumCompositing", "CIMultiplyBlendMode", "CIMultiplyCompositing", "CIOverlayBlendMode", "CIPinLightBlendMode", "CISaturationBlendMode", "CIScreenBlendMode", "CISoftLightBlendMode", "CISourceAtopCompositing", "CISourceInCompositing", "CISourceOutCompositing", "CISourceOverCompositing", "CISubtractBlendMode"]

//输入信息的滤镜数组
let MessageImageArry = ["CIAztecCodeGenerator","CIQRCodeGenerator","CICode128BarcodeGenerator","CIPDF417BarcodeGenerator"]

//输入单色的
let SigColorImgArry  = ["CIColorMonochrome","CIConstantColorGenerator","CIStarShineGenerator","CISunbeamsGenerator","CISpotLight"]

//输入双色的
let DoubColorImgArry = ["CICheckerboardGenerator","CIFalseColor"]

//shading
let ShadImageArry    = ["CIShadedMaterial","CIRippleTransition"]
let GridImageArry    = ["CIColorMap"]
let InpuDoubtimgArry = ["CILabDeltaE"]
let TagImageArry     = ["CIAccordionFoldTransition", "CIBarsSwipeTransition", "CICopyMachineTransition", "CIDisintegrateWithMaskTransition", "CIDissolveTransition", "CIFlashTransition", "CIModTransition", "CIPageCurlTransition", "CIPageCurlWithShadowTransition", "CIRippleTransition", "CISwipeTransition"]

let MaskimageArry     = ["CIDisintegrateWithMaskTransition","CIBlendWithAlphaMask","CIBlendWithMask","CIBlendWithRedMask","CIBlendWithBlueMask"]

let AttTextImageArry  = ["CIAttributedTextImageGenerator"]

let TextImageArry     = ["CITextImageGenerator"]



class FileModel :NSObject{
    var supName   : String?
    var fileName  : String?
    var image     : UIImage?
    var parmDic   = [String:Any]() //参数啊 哈哈
}

class W_imagefiterView: UIView ,UICollectionViewDelegate,UICollectionViewDataSource{
  
    @IBAction func click(_ sender: Any) {
        remSelf()
        
    }
    
    @IBOutlet weak var collV: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        let fl = UICollectionViewFlowLayout.init()
        let w = (SCREEN_WIDTH - 10)/2
        let wh = oriImage.size.width/oriImage.size.height
        fl.itemSize = CGSize.init(width:w , height: w/wh + 25)
        fl.minimumLineSpacing = 5
        fl.minimumInteritemSpacing = 5
        fl.headerReferenceSize = CGSize.init(width: SCREEN_WIDTH, height: 40)
        collV.collectionViewLayout = fl
        collV.register(UINib.init(nibName: "FitImgCell", bundle: nil), forCellWithReuseIdentifier: "FitImgCell")
        collV.delegate  = self
        collV.dataSource = self
        collV.backgroundColor = UIColor.white
        collV.reloadData()

    }
    
    @objc func remSelf(){
        UIView.animate(withDuration: 0.25, animations: {
            self.frame = CGRect.init(origin: CGPoint.init(x: SCREEN_WIDTH, y: self.frame.origin.y), size: self.frame.size)
        }) { (flg) in
            self.removeFromSuperview()
        }
    }
    
    //获取资源
    private let oriImage  = UIImage.init(named: "IMG_0888.jpg")!
    private let backImage = UIImage.init(named: "999.jpg")!
    private let maskImage = UIImage.init(named: "22222.jpg")!
    private var cageName :[String] = [kCICategoryDistortionEffect,kCICategoryGeometryAdjustment,kCICategoryCompositeOperation,kCICategoryHalftoneEffect,kCICategoryColorAdjustment,kCICategoryColorEffect,kCICategoryTransition]
    
    private var dataArry = [FileModel]()
    func getData(type:String)  {
        var cagArry = CIFilter.filterNames(inCategory: type)
        if type == kCICategoryColorAdjustment {
            cagArry = cagArry.filter({
                return ($0 != "CIDepthToDisparity") && ($0 != "CIDisparityToDepth")
            })
        }
        if type == kCICategoryColorEffect {
            cagArry = cagArry.filter({
                return ($0 != "CIColorCubesMixedWithMask")
            })
        }
        
        dataArry = cagArry.map({ (subStr) -> FileModel in
            let model = FileModel()
            model.supName = type
            model.fileName = subStr
            //这里需要对参数进行改造
            model.parmDic = self.getOrignParm(fileName: subStr, supnAME: type)
            return model
        })
        collV.contentOffset = CGPoint.zero
        collV.reloadData()
    }
    
    private func getOrignParm(fileName:String,supnAME:String) ->[String:Any]{
        var pardic = [String:Any]()
        
        if !NoimagebulArry.contains(fileName) {
            pardic[kCIInputImageKey] = CIImage.init(image: oriImage)
        }
        if BackImageArry.contains(fileName){
            pardic[kCIInputBackgroundImageKey] = CIImage.init(image: backImage)
        }
       
        if MessageImageArry.contains(fileName) {
            pardic["inputMessage"] = "KKKKKKKKK".data(using: .utf8)
        }
        if DoubColorImgArry.contains(fileName){
            pardic["inputColor0"] = CIColor.init(color: UIColor.red)
            pardic["inputColor1"] = CIColor.init(color: UIColor.yellow)
        }
        if SigColorImgArry.contains(fileName){
            pardic["inputColor"] = CIColor.init(color: UIColor.yellow)
        }
        
        if ShadImageArry.contains(fileName) {
            pardic[kCIInputShadingImageKey] = CIImage.init(image: backImage)
        }
        if GridImageArry.contains(fileName) {
            pardic[kCIInputGradientImageKey] = CIImage.init(image: backImage)
        }
        if InpuDoubtimgArry.contains(fileName) {
            pardic["inputImage2"] = CIImage.init(image: backImage)
        }
        
        if TagImageArry.contains(fileName) {
            pardic[kCIInputTargetImageKey] = CIImage.init(image: backImage)
        }
        if MaskimageArry.contains(fileName) {
            pardic[kCIInputMaskImageKey] = CIImage.init(image: maskImage)
        }
        
        if AttTextImageArry.contains(fileName) {
            pardic["inputText"] = NSAttributedString.init(string: "看前面黑洞洞", attributes: [.foregroundColor:UIColor.red])
        }
        
        if TextImageArry.contains(fileName) {
            pardic["inputText"] = "看前面黑洞洞"
        }
        
        if fileName == "CIBarcodeGenerator" {
            let data = "kkk".data(using: .utf8)
            let des =  CIAztecCodeDescriptor.init(payload: data!, isCompact: true, layerCount: 3, dataCodewordCount: 3)
            pardic["inputBarcodeDescriptor"] = des!
        }        
        return pardic
    }
    
    //代理
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArry.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "FitImgCell", for: indexPath) as! FitImgCell
        let model = dataArry[indexPath.row]
        item.refshUI(model: model)
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = dataArry[indexPath.row]
        model.parmDic = getOrignParm(fileName: model.fileName!, supnAME: model.supName!)
        signV.refshUI(model: model)
        signV.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        self.addSubview(signV)
    }
    
    private lazy var signV : SignFiterView = {
        let v = Bundle.main.loadNibNamed("SignFiterView", owner: self, options: nil)?.first as! SignFiterView
        v.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        return v    }()
}


