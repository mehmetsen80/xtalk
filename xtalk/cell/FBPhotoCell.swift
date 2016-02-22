//
//  FBPhotoCell.swift
//  xtalk
//
//  Created by Mehmet Sen on 2/18/16.
//  Copyright © 2016 Mehmet Sen. All rights reserved.
//

import Foundation

class FBPhotoCell: UICollectionViewCell{
    
    @IBOutlet weak var imgPicture: UIImageView!
    @IBOutlet weak var lblCreatedTime: UILabel!
    
    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lblCreatedTime.textColor = UIColor(white: 0.20, alpha: 1.0)
        //lblCreatedTime.font = UIFont(name: MegaTheme.boldFontName, size: 1.0)
    }
   
}