//
//  FilerCatListView.swift
//  绘图Demo
//
//  Created by xuwenhao on 2018/1/16.
//  Copyright © 2018年 Hiniu. All rights reserved.
//

import UIKit

class FilerCatListView: UIView ,UITableViewDelegate,UITableViewDataSource{
//kCICategoryGeometryAdjustment  这个效果不好 暂时不要了
    private var dataArry : [String] = [kCICategoryDistortionEffect,
                                       kCICategoryCompositeOperation,
                                       kCICategoryHalftoneEffect,
                                       kCICategoryColorAdjustment,
                                       kCICategoryColorEffect,
                                       kCICategoryTransition,
                                       kCICategoryTileEffect,
                                       kCICategoryGenerator,
                                       kCICategoryReduction,
                                       kCICategoryGradient,
                                       kCICategoryStylize,
                                       kCICategorySharpen,
                                       kCICategoryBlur,
                                       kCICategoryVideo,
                                       kCICategoryStillImage,
                                       kCICategoryInterlaced,
                                       kCICategoryNonSquarePixels,
                                       kCICategoryHighDynamicRange,
                                       kCICategoryBuiltIn,
                                       kCICategoryFilterGenerator]
    
    @IBOutlet weak var tableView: UITableView!
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.rowHeight = 50
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = dataArry[indexPath.row]
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = dataArry[indexPath.row]
        filtView.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        filtView.getData(type: type)
        self.addSubview(filtView)
    }
    
    //懒加载
    private lazy var filtView : W_imagefiterView = {
        let v = Bundle.main.loadNibNamed("W_imagefiterView", owner: self, options: nil)?.first as! W_imagefiterView
        v.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        return v
    }()
}

/*
 public let kCICategoryDistortionEffect: String
 public let kCICategoryGeometryAdjustment: String
 public let kCICategoryCompositeOperation: String
 public let kCICategoryHalftoneEffect: String
 public let kCICategoryColorAdjustment: String
 public let kCICategoryColorEffect: String
 public let kCICategoryTransition: String
 public let kCICategoryTileEffect: String
 public let kCICategoryGenerator: String
 @available(iOS 5.0, *)
 public let kCICategoryReduction: String
 public let kCICategoryGradient: String
 public let kCICategoryStylize: String
 public let kCICategorySharpen: String
 public let kCICategoryBlur: String
 
 public let kCICategoryVideo: String
 public let kCICategoryStillImage: String
 public let kCICategoryInterlaced: String
 
 public let kCICategoryNonSquarePixels: String
 public let kCICategoryHighDynamicRange: String
 public let kCICategoryBuiltIn: String
 @available(iOS 9.0, *)
 public let kCICategoryFilterGenerator: String
 */

