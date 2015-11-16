//
//  UIImageViewExtension.swift
//  xtalk
//
//  Created by Mehmet Sen on 11/16/15.
//  Copyright © 2015 Mehmet Sen. All rights reserved.
//


import UIKit

extension UIImageView{

    func defaultCorner(imageView: UIImageView) -> UIImageView {
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.layer.borderWidth=2.0
        imageView.layer.borderColor = UIColor.whiteColor().CGColor
        return imageView
    }

}
