//
//  RotateView.swift
//  RotateView
//
//  Created by skyline on 16/6/30.
//  Copyright © 2016年 skyline. All rights reserved.
//

import UIKit

class SKRotateView: UIView {
    
    var image: UIImage!
    /// 背景颜色
    var screenColor = UIColor.blackColor() {
        didSet { imageHoleView.screenColor = screenColor }
    }
    /// 背景透明度
    var screenAlpha: CGFloat = 0.5 {
        didSet { imageHoleView.screenAlpha = screenAlpha }
    }
    private let container = UIView()
    private let imgContentView = UIView()
    private let imageView = UIImageView()
    private let imageHoleView = RotateHoleView()
    
    private var startingVector = CGVector()
    private var actualVector = CGVector()
    private var startingTransform = CGAffineTransformIdentity
    private var initialFrame = CGRectZero
    // 每次触发旋转的弧度
    private var rotateTheta: CGFloat = 0.0
    private var scale: CGFloat = 1
    // 旋转裁剪后的图片
    var processedImage: UIImage! {
        get {
            let imgSize = CGSize(width: image.size.width*image.scale, height: image.size.height*image.scale)
            let outputSize = imgSize
            UIGraphicsBeginImageContext(outputSize)
            let ctn = UIGraphicsGetCurrentContext()!
            
            CGContextTranslateCTM(ctn, outputSize.width/2, outputSize.height/2)
            CGContextRotateCTM(ctn, rotateRadians)
            CGContextTranslateCTM(ctn, -outputSize.width/2, -outputSize.height/2)
            CGContextScaleCTM(ctn, 1/scale, 1/scale)
            CGContextTranslateCTM(ctn, (scale-1)/2*outputSize.width, (scale-1)/2*outputSize.height)
            
            let rect = CGRect(x: 0, y: 0, width: imgSize.width, height: imgSize.height)
            image.drawInRect(rect)
            
            let  processedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return processedImage
        }
    }
    // 跟初始相比的旋转弧度
    var rotateRadians: CGFloat {
        get {
            /**
             * | a: cos(angle)  b: sin(angle)   0 |
             * | c: -sin(angle) d: cos(angle)   0 |
             * | tx: 0          ty:0            1 |
            */
            
            var radians = acos(imageView.transform.a)
            
            if imageView.transform.b < 0 {
                radians = 2*CGFloat(M_PI) - radians
            }
            return radians
        }
    }
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(_:)))
        self.addGestureRecognizer(pan)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let img = image where img.size.width>0 && img.size.height>0 else {
            return
        }
        self.addSubview(container)
        // container full width
        var size: CGSize!
        if image.size.width/image.size.height >= self.bounds.width/self.bounds.height {
            size = CGSize(width: self.bounds.width, height: self.bounds.width*image.size.height/image.size.width)
        }
        // container full height
        else {
            size = CGSize(width: self.bounds.height*image.size.width/image.size.height, height: self.bounds.height)
        }
        container.frame = CGRect(origin: CGPointZero, size: size)
        container.center = CGPoint(x: CGRectGetMidX(self.bounds), y: CGRectGetMidY(self.bounds))
        container.clipsToBounds = true
        container.backgroundColor = UIColor.blackColor()
        
        container.addSubview(imgContentView)
        imgContentView.frame = container.bounds
        
        imgContentView.addSubview(imageView)
        imageView.frame = container.bounds
        imageView.image = image
        // 去锯齿
        imageView.layer.shouldRasterize = true
        
        imgContentView.addSubview(imageHoleView)
        imageHoleView.frame = imageView.frame
        imageHoleView.holeFrame = imageView.frame
        
        initialFrame = imageHoleView.holeFrame
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 通过平移计算旋转角度
    func handlePan(sender: UIPanGestureRecognizer) {
        let locationView = sender.view!
        let center = CGPoint(x: CGRectGetMidX(locationView.bounds), y: CGRectGetMidY(locationView.bounds))
        
        switch sender.state {
        case .Began:
            let actualPoint = sender.locationOfTouch(0, inView: locationView)
            startingVector.dx = actualPoint.x - center.x
            startingVector.dy = actualPoint.y - center.y
            startingTransform = imageView.transform
            
        case .Changed:
            let actualPoint = sender.locationOfTouch(0, inView: locationView)
            actualVector.dx = actualPoint.x - center.x
            actualVector.dy = actualPoint.y - center.y
            
            // 计算旋转弧度
            let cosTheta = (startingVector.dx*actualVector.dx + startingVector.dy*actualVector.dy)/(sqrt(startingVector.dx*startingVector.dx+startingVector.dy*startingVector.dy) * sqrt(actualVector.dx*actualVector.dx+actualVector.dy*actualVector.dy))
            rotateTheta = acos(cosTheta)
            
            // 叉积
            let crossProduct = startingVector.dx*actualVector.dy - startingVector.dy*actualVector.dx
            if crossProduct < 0 {
                rotateTheta = CGFloat(2*M_PI) - rotateTheta
            }
            imageView.transform = CGAffineTransformRotate(startingTransform, rotateTheta)
            
            let sinA = min(image.size.width, image.size.height)/sqrt(image.size.width*image.size.width + image.size.height*image.size.height)
            let angleA = asin(sinA)
            let angleB = CGFloat(M_PI) - angleA - acos(abs(imageView.transform.a))
            let sinB = sin(angleB)
            scale = sinA/sinB
            
            var rect = CGRect(x: 0, y: 0, width: initialFrame.width*scale, height: initialFrame.height*scale)
            rect.origin.x = initialFrame.midX - rect.size.width/2
            rect.origin.y = initialFrame.midY - rect.size.height/2
            imageHoleView.holeFrame = rect
            
        case .Ended:
            UIView.animateWithDuration(0.3, animations: {
                self.imgContentView.transform = CGAffineTransformMakeScale(1/self.scale, 1/self.scale)
                }, completion: { (_) in
            })
            
        default:
            break
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        UIView.animateWithDuration(
            0.3,
            animations: {
                self.imgContentView.transform = CGAffineTransformMakeScale(1, 1)
            },
            completion: { (_) in
            })
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        UIView.animateWithDuration(
            0.3,
            animations: {
                self.imgContentView.transform = CGAffineTransformMakeScale(1/self.scale, 1/self.scale)
            },
            completion: { (_) in
            })
    }
    

}


class SKRotateHoleView: UIView {
    
    /// 背景颜色
    var screenColor = UIColor.blackColor() {
        didSet { setNeedsDisplay() }
    }
    /// 背景透明度
    var screenAlpha: CGFloat = 0.5 {
        didSet { setNeedsDisplay() }
    }
    
    var holeFrame = CGRectZero {
        didSet { self.setNeedsDisplay() }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        let ctx = UIGraphicsGetCurrentContext()!
        addFillScreen(ctx, rect: self.bounds)
        clearRect(ctx, rect: holeFrame)
    }
    
    func addFillScreen(ctx: CGContextRef, rect: CGRect) {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        
        if screenColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha) == true {
            CGContextSetRGBFillColor(ctx, red, green, blue, alpha*screenAlpha)
        } else {
            CGContextSetRGBFillColor(ctx, 0.2, 0.2, 0.2, 0.7)
        }
        CGContextFillRect(ctx, rect)
    }
    
    func clearRect(ctx: CGContextRef, rect: CGRect) {
        CGContextClearRect(ctx, rect)
    }
    
}
