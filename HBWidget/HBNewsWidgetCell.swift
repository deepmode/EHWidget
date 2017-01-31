//
//  HBNewsWidgetCell.swift
//  EHWidget
//
//  Created by EricHo on 27/1/2017.
//  Copyright © 2017 E H. All rights reserved.
//

import UIKit
import SDWebImage

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
        self.displayInfo?.text = "\(timeAgoSinceDate(post.date, numericDates: true))"
        
        if let url = URL(string: post.thumbnailURLString) {
            var sdOptions:SDWebImageOptions = SDWebImageOptions.retryFailed
            if url.path.hasSuffix(".gif") {
                sdOptions = [SDWebImageOptions.retryFailed, SDWebImageOptions.lowPriority]
            }
            self.displayImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "default_placeholder"), options: sdOptions, completed: { (image, error, cacheType, url) -> Void in
                DispatchQueue.main.async(execute: { () -> Void in
                    //self.activityView.stopAnimating()
                    if (cacheType == SDImageCacheType.memory) {
                        self.displayImageView.alpha = 1
                        return
                    } else {
                        // If the cache is none or disk, it's just been loaded
                        self.displayImageView.alpha = 0.0
                        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: { () -> Void in
                            self.displayImageView.alpha = 1
                        }, completion: { (finished) -> Void in
                        })
                    }
                    
                })
            })
        }
    }
    
}
