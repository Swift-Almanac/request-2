//
//  MyViewController + UIPickerDelegate.swift
//  final
//
//  Created by Mark Hoath on 2/11/17.
//  Copyright © 2017 Mark Hoath. All rights reserved.
//

import UIKit



func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
    
    let scale = newWidth / image.size.width
    let newHeight = image.size.height * scale
    UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
    image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage
}

