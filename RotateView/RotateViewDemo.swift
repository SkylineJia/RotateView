//
//  ViewController.swift
//  RotateView
//
//  Created by skyline on 16/6/30.
//  Copyright © 2016年 skyline. All rights reserved.
//

import UIKit

class RotateViewDemo: UIViewController {
    
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.snp_makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(DemoCell.self, forCellReuseIdentifier: "cellId")
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "RotateViewDemo"
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.title = ""
    }

    
}

extension RotateViewDemo: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellId", forIndexPath: indexPath) as! DemoCell
        
        if indexPath.row == 0 {
            cell.imgView.image = UIImage(named: "IMG_2527")
            cell.label.text = "width > height"
        } else {
            cell.imgView.image = UIImage(named: "IMG_2522")
            cell.label.text = "height > width"
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let rotate = RotateViewDetail()
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! DemoCell
        if indexPath.row == 0 {
            rotate.image = cell.imgView.image
        } else if indexPath.row == 1 {
            rotate.image = cell.imgView.image
        }
        navigationController?.pushViewController(rotate, animated: true)
    }

    
}


class DemoCell: UITableViewCell {
    
    let imgView = UIImageView()
    let label = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(imgView)
        contentView.addSubview(label)
        
        imgView.snp_makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
            make.width.equalTo(imgView.snp_height)
        }
        imgView.contentMode = .ScaleAspectFit
        imgView.backgroundColor = UIColor.lightGrayColor()
        
        label.snp_makeConstraints { (make) in
            make.centerY.equalTo(imgView)
            make.left.equalTo(imgView.snp_right).offset(30)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
