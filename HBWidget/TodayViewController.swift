//
//  TodayViewController.swift
//  HBWidget
//
//  Created by EricHo on 9/12/2016.
//  Copyright © 2016 E H. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView:UITableView!
    
    private var dataSrc:[HBWidgetPost] = [HBWidgetPost]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var maxShowInExpandMode:Int {
        if self.view.frame.width > 320 {
            return 4
        } else {
            //4 inch screen -> only show 3 items in the widget
            return 3
        }
    }
    let estimateTableViewCellHeight:CGFloat = 112 - 1 //this value is depending on the high of the cell
    
    override func viewDidLoad() {
        print("----- \(NSStringFromClass(self.classForCoder)).\(#function) -----")
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        
        self.tableView.register(UINib(nibName: "HBNewsWidgetCell", bundle: Bundle.main), forCellReuseIdentifier: "Cell_NewsWidget")
        
        //------------------
        // setup tableView to support dynamic tableview cell height
        self.tableView.estimatedRowHeight = self.estimateTableViewCellHeight
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        //------------------
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.reloadData()
        self.updatePreferredContentSize()
        
        if #available(iOSApplicationExtension 10.0, *) {
            self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        print("----- \(NSStringFromClass(self.classForCoder)).\(#function) -----")
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: Widget
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        print("----- \(NSStringFromClass(self.classForCoder)).\(#function) -----")
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        HBApi.getNewsFeed("https://hypebeast.com/") { (request, response, widgetPosts, st, error) in
            DispatchQueue.main.async(execute: { () -> Void in
                self.dataSrc = widgetPosts!
                self.updatePreferredContentSize()
                completionHandler(NCUpdateResult.newData)
            })
        }
    }
    
    
    func updatePreferredContentSize() {
        print("----- \(NSStringFromClass(self.classForCoder)).\(#function) -----")
        let rHeight:CGFloat = self.estimateTableViewCellHeight
        var newSize = self.preferredContentSize
        //newSize.height = CGFloat(self.tableView.numberOfRows(inSection: 0)) * rHeight //CGFloat(self.tableView.rowHeight)
        //newSize.height = CGFloat(self.tableView.numberOfRows(inSection: 0)) * rHeight
        if let context  = self.extensionContext {
            if #available(iOSApplicationExtension 10.0, *) {
                if context.widgetActiveDisplayMode == .expanded {
                    newSize.height = CGFloat(self.maxShowInExpandMode) * rHeight
                } else {
                    newSize.height = rHeight
                }
            } else {
                // Fallback on earlier versions
                newSize.height = CGFloat(self.maxShowInExpandMode) * rHeight
            }
        }
        
        self.preferredContentSize = newSize
    }
    
    // For iOS 10
    @available(iOS 10.0, *)
    @available(iOSApplicationExtension 10.0, *)
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        
//        var newSize = self.preferredContentSize
//        let rHeight:CGFloat = self.estimateTableViewCellHeight
//        if activeDisplayMode == .expanded {
//            newSize.height = CGFloat(self.maxShowInExpandMode) * rHeight
//        } else {
//            newSize.height = rHeight
//        }
//        self.preferredContentSize = newSize
        
        self.updatePreferredContentSize()
    }
    
    
    //MARK: - UITableViewDelegate & UIDataSrcDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.maxShowInExpandMode //self.dataSrc.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_NewsWidget", for: indexPath as IndexPath) as! HBNewsWidgetCell
        if indexPath.row < self.dataSrc.count {
            let post = self.dataSrc[indexPath.row]
            cell.setupCellWith(post: post)
            
            cell.selectionStyle =  UITableViewCellSelectionStyle.none //if set to default, iOS 9 - after selected, won't diselect
            cell.layoutMargins =  UIEdgeInsets.zero
            
//            //----- SUPER IMPORTANT -----
//            //Fix the left alignment issue for custom cell to sync with the default UITableCell's behaviour
//            //http://stackoverflow.com/questions/27420888/uitableviewcell-with-autolayout-left-margin-different-on-iphone-and-ipad
//            if #available(iOSApplicationExtension 10.0, *) {
//                
//            } else {
//                cell.preservesSuperviewLayoutMargins = true
//                cell.contentView.preservesSuperviewLayoutMargins = true
//            }
//            //---------------------------
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < self.dataSrc.count {
            let post = self.dataSrc[indexPath.row]
            if let url = URL(string: post.linkURLString) {
                self.extensionContext?.open(url, completionHandler: { (state) in
                    
                })
            }
            
        }
    }
}


