//
//  ViewController.swift
//  RotateView
//
//  Created by skyline on 16/6/30.
//  Copyright © 2016年 skyline. All rights reserved.
//

import UIKit
import SnapKit

class RotateViewDetail: UIViewController {

    let rotateView = SKRotateView()
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "RotateViewDetail"
        view.backgroundColor = UIColor.white
        let rightBtn = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(self.handleRightBtn))
        self.navigationItem.rightBarButtonItem = rightBtn
        
        rotateView.image = image
        view.addSubview(rotateView)
        rotateView.snp_makeConstraints { (make) in
            make.top.equalTo(64)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        }
    }
    
    func handleRightBtn() {
        let img = rotateView.processedImage
        saveImageToAlbum(img!)
    }
    
    func saveImageToAlbum(_ image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError: NSError?,contextInfo: AnyObject)
    {
        var title: String!
        if didFinishSavingWithError != nil
        {
            title = "图片保存失败"
        } else {
            title = "图片保存成功"
        }
        
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "OK", style: .default) { (_) in
            
        }
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel) { (_) in
        }
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }


}

