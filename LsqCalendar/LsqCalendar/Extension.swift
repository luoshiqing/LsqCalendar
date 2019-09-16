//
//  Extension.swift
//  LsqCalendar
//
//  Created by 罗石清 on 2019/9/16.
//  Copyright © 2019 HunanChangxingTrafficWisdom. All rights reserved.
//

import UIKit

//MARK:UIColor扩展
extension UIColor {
    //16进制颜色
    @objc public class func hexColor(with string:String)->UIColor? {
        var cString = string.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.count < 6 {
            return nil
        }
        if cString.hasPrefix("0X") {
            let index = cString.index(cString.startIndex, offsetBy: 2)
            cString = String(cString[index...])
        }
        if cString .hasPrefix("#") {
            let index = cString.index(cString.startIndex, offsetBy: 1)
            cString = String(cString[index...])
        }
        if cString.count != 6 {
            return nil
        }
        
        let rrange = cString.startIndex..<cString.index(cString.startIndex, offsetBy: 2)
        let rString = String(cString[rrange])
        let grange = cString.index(cString.startIndex, offsetBy: 2)..<cString.index(cString.startIndex, offsetBy: 4)
        let gString = String(cString[grange])
        let brange = cString.index(cString.startIndex, offsetBy: 4)..<cString.index(cString.startIndex, offsetBy: 6)
        let bString = String(cString[brange])
        var r:CUnsignedInt = 0 ,g:CUnsignedInt = 0 ,b:CUnsignedInt = 0
        
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1)
    }
}


extension UIView {
    
    //位置
    public var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: newValue)
        }
    }
    public var width: CGFloat{
        get {
            return self.frame.size.width
        }
        set {
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: newValue, height: self.frame.height)
        }
    }
    
    public var top: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            self.frame = CGRect(x: self.frame.origin.x, y: newValue, width: self.frame.width, height: self.frame.height)
        }
        
    }
    public var bottom: CGFloat {
        get {
            return self.frame.origin.y + self.frame.height
        }
        set {
            let y = newValue - self.frame.height
            self.frame = CGRect(x: self.frame.origin.x, y: y, width: self.frame.width, height: self.frame.height)
        }
        
    }
    public var left: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            self.frame = CGRect(x: newValue, y: self.frame.origin.y, width: self.frame.width, height: self.frame.height)
        }
        
    }
    public var right: CGFloat {
        get {
            return self.frame.origin.x + self.frame.width
        }
        set {
            let x = newValue - self.frame.width
            self.frame = CGRect(x: x, y: self.frame.origin.y, width: self.frame.width, height: self.frame.height)
        }
    }
}
