//
//  SelfMadeListView.swift
//  绘图Demo
//
//  Created by xuwenhao on 2018/2/24.
//  Copyright © 2018年 Hiniu. All rights reserved.
//

import UIKit

class SelfMadeListView: UIView ,UITableViewDelegate,UITableViewDataSource{

    @IBAction func backClick(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    private let oriImage  = UIImage.init(named: "IMG_0888.jpg")!
    private let dataArry : [String] = ["混合","沙雕","马赛克","透明圆"]
    @IBOutlet weak var tableV: UITableView!
    override func awakeFromNib() {
        super.awakeFromNib()
        tableV.rowHeight = 50
        tableV.delegate = self
        tableV.dataSource = self
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
        showView.fiterShow(type: Int8(indexPath.row))
        self.addSubview(showView)
        
    }
    
    private lazy var showView : SelfMadeShowView = {
        let v = Bundle.main.loadNibNamed("SelfMadeShowView", owner: self, options: nil)?.first as! SelfMadeShowView
        v.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        return v
        
    }()
    
}
