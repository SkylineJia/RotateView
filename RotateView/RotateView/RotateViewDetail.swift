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
        rotateView.snp.makeConstraints { (make) in
            make.top.equalTo(64)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        }
        rotateView.screenColor = UIColor.black
    }
    
    func handleRightBtn() {
        let img = rotateView.processedImage
        saveImageToAlbum(img!)
    }
    
    let indicattor = UIActivityIndicatorView(activityIndicatorStyle: .white)
    func saveImageToAlbum(_ image: UIImage) {
        
        
        self.view.addSubview(indicattor)
        indicattor.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview().offset((UIApplication.shared.statusBarFrame.height+self.navigationController!.navigationBar.frame.height)/2)
            
        }
        indicattor.startAnimating()
        
        self.navigationController?.view.isUserInteractionEnabled = false
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
        
        
        
        
        
        
        
        
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError: NSError?,contextInfo: AnyObject)
    {
        self.navigationController?.view.isUserInteractionEnabled = true
        indicattor.stopAnimating()
        indicattor.removeFromSuperview()
        var title: String!
        if didFinishSavingWithError != nil
        {
            title = "图片保存失败"
        } else {
            title = "图片保存成功"
        }
        
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }


}

