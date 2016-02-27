//
//  FBPhotoCell.swift
//  xtalk
//
//  Created by Mehmet Sen on 2/18/16.
//  Copyright © 2016 Mehmet Sen. All rights reserved.
//

import Foundation

class FBPhotoCell: UITableViewCell{
    
    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var lblCreatedTime: UILabel!
    @IBOutlet weak var btnImport: UIButton!
    @IBOutlet weak var imgImported: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        //lblCreatedTime.textColor = UIColor(white: 1.0, alpha: 1.0)
        //lblCreatedTime.font = UIFont(name: MegaTheme.boldFontName, size: 1.0)
    }
   
}