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
    
    @IBOutlet weak var displayCategory: UILabel!
    @IBOutlet weak var displayTitle: UILabel!
    @IBOutlet weak var displayInfo: UILabel!
    @IBOutlet weak var displayImageView: UIImageView!
    
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.defaultSetup()
    }
    
    private func defaultSetup() {
        
        let textColor = UIColor.clear
        self.displayCategory?.textColor = textColor
        self.displayTitle?.textColor = textColor
        self.displayInfo?.textColor = textColor
        self.imageView?.image = nil

        //############################
        //set the display text color for Today extension (with iOS version dependency)
        
        var leadingPadding:CGFloat = 16.0
        var trailingPadding:CGFloat = 16.0
        if #available(iOSApplicationExtension 10.0, *) {
            
        } else {
            //for iOS 9, iPhone / iPad
            leadingPadding = 0.0
            trailingPadding = 16.0
        }
        
        self.leadingConstraint?.constant = leadingPadding
        self.trailingConstraint?.constant = trailingPadding
        //############################
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.defaultSetup()
    }
    
    func setupCellWith(post:HBWidgetPost) {
        
        var categoryTextColor = UIColor(colorLiteralRed: 9/255.0, green: 89/255.0, blue: 173/255.0, alpha: 1.0)
        
        
        //############################
        //set the display text color for Today extension (with iOS version dependency)
        var titleTextColor = UIColor.darkText
        var infoTextColor = UIColor.darkText

        if #available(iOSApplicationExtension 10.0, *) {
            
        } else {
            titleTextColor = UIColor.white
            infoTextColor = UIColor.lightText
            categoryTextColor = UIColor.lightText
        }
    
        self.displayTitle?.textColor = titleTextColor
        self.displayInfo?.textColor = infoTextColor
        self.displayCategory?.textColor = categoryTextColor
        //############################
        
        self.displayImageView?.layer.cornerRadius = 4.0
        self.displayImageView?.clipsToBounds = true
        
        self.displayCategory?.text = post.category
        self.displayTitle?.text = post.title
        //self.displayInfo?.text = "\(timeAgoSinceDate(post.date, numericDates: true))"
        self.displayInfo?.text = timeAgoSinceDate(post.date, numericDates: true, showfullDateAfter24Hrs: true, showShortFormTime: false)
        
        if let url = URL(string: post.thumbnailURLString) {
            var sdOptions:SDWebImageOptions = SDWebImageOptions.retryFailed
            if url.path.hasSuffix(".gif") {
                self.displayImageView.image = UIImage(named: "default_placeholder")
                self.displayImageView.alpha = 1
                return
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
