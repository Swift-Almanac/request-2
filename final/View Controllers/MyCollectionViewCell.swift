//
//  MyCollectionViewCell.swift
//  final
//
//  Created by Mark Hoath on 16/10/17.
//  Copyright © 2017 Mark Hoath. All rights reserved.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell {
    
    let nameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpView()
        setUpContraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView() {
        addSubview(nameLabel)
        addSubview(imageView)
        nameLabel.textAlignment = .center
    }
    
    func setUpContraints() {
        
        // Image View
        
        //     Constrain to the Cell Margins
        
        let ivLeft = NSLayoutConstraint(item: imageView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 8)
        let ivTop = NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 8)
        let ivHeight = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil , attribute: .height, multiplier: 1.0, constant: 45)
        let ivWidth = NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 45)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints([ivLeft, ivTop, ivHeight, ivWidth])

        
        //   Label
        
        //     Constrain to the Cell Margins
        
        let labelLeft = NSLayoutConstraint(item: nameLabel, attribute: .left, relatedBy: .equal, toItem: imageView, attribute: .right, multiplier: 1.0, constant: 8)
        let labelTop = NSLayoutConstraint(item: nameLabel, attribute: .top, relatedBy: .equal, toItem: imageView, attribute: .top, multiplier: 1.0, constant: 8)
        let labelHeight = NSLayoutConstraint(item: nameLabel, attribute: .height, relatedBy: .equal, toItem: nil , attribute: .height, multiplier: 1.0, constant: 30)
        let labelWidth = NSLayoutConstraint(item: nameLabel, attribute: .width, relatedBy: .equal, toItem: nil , attribute: .width, multiplier: 1.0, constant: UIScreen.main.bounds.width - 61)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints([labelTop, labelLeft, labelHeight, labelWidth])
    }
}
