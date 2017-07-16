//
//  TimelineTableViewCell.swift
//  SNSTM
//
//  Created by tarosekine on 2017/03/20.
//  Copyright © 2017年 tarosekine. All rights reserved.
//

import UIKit

class TimelineTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var kyunTextView: UITextView!
    @IBOutlet weak var unTextLabel: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        contentLabel.layer.borderWidth = 1.0
//        contentLabel.layer.borderColor =  UIColor.black.cgColor
//        placeLabel.layer.borderWidth = 1.0
//        placeLabel.layer.borderColor =  UIColor.black.cgColor
//        kyunTextView.layer.borderWidth = 1.0
//        kyunTextView.layer.borderColor =  UIColor.black.cgColor
//        unTextLabel.layer.borderWidth = 1.0
//        unTextLabel.layer.borderColor =  UIColor.black.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
//    @IBAction func favoriteBtn(_ sender: Any) {
//        
//        let numberInt =
//        let number = NCMBFile.file(with: numberInt as Int!) as! NCMBFile
//    
//    
//    
//    }
    
}
