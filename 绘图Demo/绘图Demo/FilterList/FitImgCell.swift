//
//  FitImgCell.swift
//  绘图Demo
//
//  Created by xuwenhao on 2018/1/16.
//  Copyright © 2018年 Hiniu. All rights reserved.
//

import UIKit

class FitImgCell: UICollectionViewCell {


    @IBOutlet weak var cellimageV: UIImageView!
    @IBOutlet weak var lb: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lb.font = UIFont.systemFont(ofSize: 11)
    }
    

    func refshUI(model:FileModel)  {
        lb.text = model.fileName
        if model.image == nil {
            DispatchQueue.global().async {
                let image = UIImage.fiterImageWithModel(model: model)
                DispatchQueue.main.async {
                    model.image = image
                    self.cellimageV.image = model.image
                }
            }
        }else{
            cellimageV.image = model.image
        }
    }
 
}
