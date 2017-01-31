//
//  HBNewsWidgetCell.swift
//  EHWidget
//
//  Created by EricHo on 27/1/2017.
//  Copyright © 2017 E H. All rights reserved.
//

import UIKit

class HBNewsWidgetCell: UITableViewCell {

    @IBOutlet weak var displayTitle: UILabel!
    @IBOutlet weak var displayInfo: UILabel!
    @IBOutlet weak var displayImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCellWith(post:HBWidgetPost) {
        
        self.displayImageView?.layer.cornerRadius = 4.0
        self.displayImageView?.clipsToBounds = true
        
        self.displayTitle?.text = post.title
        self.displayInfo?.text = post.date.description
        
//        self.displayTitle?.textColor = UIColor.lightText
//        self.displayInfo?.textColor = UIColor.lightText
        
    }
    
}
