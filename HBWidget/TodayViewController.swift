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
    
    static let maxSize = 20
    
//    func setupDataSrc() {
//        print("----- \(NSStringFromClass(self.classForCoder)).\(#function) -----")
//        var tempChannels = [HBChannel]()
//        for eachIndex in 0...TodayViewController.maxSize {
//            let hbc = HBChannel(channelIdentifier: "identifier \(eachIndex)", channelDisplayName: "Channel Display name Channel Display Name Channel Display name Channel Display Name Channel Display Name Channel Display Name \(eachIndex)", channelDescription: "\(eachIndex) : Channel Description. Plastic has become a vital part of our lives of convenience.", enableChannel: true, enableNotification: true)
//            tempChannels.append(hbc)
//        }
//        self.dataSrc = tempChannels
//    }
    
    let estimateTableViewCellHeight:CGFloat = 120.0
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
        
        //self.setupDataSrc()
        
        self.tableView.reloadData()
        self.updatePreferredContentSize()
        
        self.view.backgroundColor = UIColor.green
        
    }
    
    
    override func didReceiveMemoryWarning() {
        print("----- \(NSStringFromClass(self.classForCoder)).\(#function) -----")
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        print("----- \(NSStringFromClass(self.classForCoder)).\(#function) -----")
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        HBApi.getNewsFeed("https://hypebeast.com/") { (request, response, widgetPosts, st, error) in
            
            self.dataSrc = widgetPosts!
            self.tableView.reloadData()
            self.updatePreferredContentSize()
            completionHandler(NCUpdateResult.newData)
        }
    }
    
    
    
    
    func updatePreferredContentSize() {
        print("----- \(NSStringFromClass(self.classForCoder)).\(#function) -----")
        let rHeight:CGFloat = self.estimateTableViewCellHeight
        var newSize = self.preferredContentSize
        //newSize.height = CGFloat(self.tableView.numberOfRows(inSection: 0)) * rHeight //CGFloat(self.tableView.rowHeight)
        //newSize.height = CGFloat(self.tableView.numberOfRows(inSection: 0)) * rHeight
        newSize.height = CGFloat(3.0) * rHeight
        self.preferredContentSize = newSize
    }
    
    //MARK: - UITableViewDelegate & UIDataSrcDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TodayViewController.maxSize //self.dataSrc.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_NewsWidget", for: indexPath as IndexPath) as! HBNewsWidgetCell
        
        let post = self.dataSrc[indexPath.row]
        cell.setupCellWith(post: post)
        
        cell.selectionStyle =  UITableViewCellSelectionStyle.none //if set to default, iOS 9 - after selected, won't diselect
        cell.layoutMargins =  UIEdgeInsets.zero
        
        //----- SUPER IMPORTANT -----
        //Fix the left alignment issue for custom cell to sync with the default UITableCell's behaviour
        //http://stackoverflow.com/questions/27420888/uitableviewcell-with-autolayout-left-margin-different-on-iphone-and-ipad
        cell.preservesSuperviewLayoutMargins = true
        cell.contentView.preservesSuperviewLayoutMargins = true
        //---------------------------
        
        return cell
    }
}
