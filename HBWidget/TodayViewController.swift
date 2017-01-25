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
    private var dataSrc:[HBChannel] = [HBChannel]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    //private let rowHeight:CGFloat = 100.0
        
    override func viewDidLoad() {
        print("----- \(NSStringFromClass(self.classForCoder)).\(#function) -----")
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.setupDataSrc()
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        print("----- \(NSStringFromClass(self.classForCoder)).\(#function) -----")
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        self.updatePreferredContentSize()
    }
    
    static let maxSize = 10
    
    func setupDataSrc() {
        print("----- \(NSStringFromClass(self.classForCoder)).\(#function) -----")
        var tempChannels = [HBChannel]()
        for eachIndex in 0...TodayViewController.maxSize {
            let hbc = HBChannel(channelIdentifier: "identifier \(eachIndex)", channelDisplayName: "Channel Display name \(eachIndex)", channelDescription: "\(eachIndex) : Channel Description. Plastic has become a vital part of our lives of convenience.", enableChannel: true, enableNotification: true)
            tempChannels.append(hbc)
        }
        self.dataSrc = tempChannels
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
        
        self.tableView.reloadData()
        self.updatePreferredContentSize()
        completionHandler(NCUpdateResult.newData)
    }
    
    
    
    
    func updatePreferredContentSize() {
        print("----- \(NSStringFromClass(self.classForCoder)).\(#function) -----")
        let rHeight:CGFloat = 20.0
        var newSize = self.preferredContentSize
        //newSize.height = CGFloat(self.tableView.numberOfRows(inSection: 0)) * rHeight //CGFloat(self.tableView.rowHeight)
        newSize.height = CGFloat(self.tableView.numberOfRows(inSection: 0)) * rHeight
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_Identifier", for: indexPath as IndexPath)
        let hbc = self.dataSrc[indexPath.row]
            
        cell.selectionStyle =  UITableViewCellSelectionStyle.default //UITableViewCellSelectionStyle.None
        cell.layoutMargins =  UIEdgeInsets.zero
        cell.textLabel?.text = hbc.channelDisplayName
        cell.textLabel?.textColor = UIColor.lightText
        cell.detailTextLabel?.text = hbc.channelDescription
        cell.detailTextLabel?.textColor = UIColor.lightText
        
        
        //----- SUPER IMPORTANT -----
        //Fix the left alignment issue for custom cell to sync with the default UITableCell's behaviour
        //http://stackoverflow.com/questions/27420888/uitableviewcell-with-autolayout-left-margin-different-on-iphone-and-ipad
        cell.preservesSuperviewLayoutMargins = true
        cell.contentView.preservesSuperviewLayoutMargins = true
        //---------------------------
        
        return cell
    }
}
