//
//  ViewController.swift
//  EHWidget
//
//  Created by EricHo on 9/12/2016.
//  Copyright © 2016 E H. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //##################
    enum AppConfigLanguageCode:String {
        case EN = "en"
        case CNT = "cnt" //HK
        case CNS = "cns" //CN
        case JA = "ja"
        case TW = "tw" //TW
        case KR = "kr" //KR
    }
    
    let shareAppGroupName = "group.com.101medialab.EHWidget"
    
    private let kLanguageKey = "kLanguageCode"
    
    private var userDefault:UserDefaults? {
        let d = UserDefaults.init(suiteName: self.shareAppGroupName)
        return d
    }
    //##################
    
    
    
    
    @IBOutlet weak var segmentControl:UISegmentedControl!
    
    @IBOutlet weak var tableView:UITableView!
    
    private var dataSrc:[HBWidgetPost] = [HBWidgetPost]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    static let maxSize = 20
    
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
        
        self.fetchData()
        
        self.view.backgroundColor = UIColor.green
        
        self.updateUI()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        print("----- \(NSStringFromClass(self.classForCoder)).\(#function) -----")
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Data Fetching
    func fetchData() {
        HBApi.getNewsFeed(self.getCurrentLink) { (request, response, widgetPosts, st, error) in

            self.dataSrc = widgetPosts!
            self.tableView.reloadData()
        }
    }
    
    //MARK: - IBAction
    
    @IBAction func languageChangeHandler(_ sender: UISegmentedControl) {

        let userDefault = self.userDefault
        var value = AppConfigLanguageCode.EN.rawValue
        
        switch sender.selectedSegmentIndex {
        case 0:
            value = AppConfigLanguageCode.EN.rawValue
        case 1:
            value = AppConfigLanguageCode.CNT.rawValue
        case 2:
            value = AppConfigLanguageCode.CNS.rawValue
        case 3:
            value = AppConfigLanguageCode.JA.rawValue
        case 4:
            value = AppConfigLanguageCode.KR.rawValue
        default:
            value = AppConfigLanguageCode.EN.rawValue
        }
        userDefault?.set(value, forKey: self.kLanguageKey)
        userDefault?.synchronize()
        
        self.fetchData()
    }
    
    var getCurrentLink:String {
        let userDefault = self.userDefault
        if let languageCodeValue =  userDefault?.object(forKey: self.kLanguageKey) as? String {
            switch languageCodeValue {
            case AppConfigLanguageCode.EN.rawValue:
                return "https://hypebeast.com/"
            case AppConfigLanguageCode.CNT.rawValue:
                return "https://hypebeast.com/zh"
            case AppConfigLanguageCode.CNS.rawValue:
                return "https://hypebeast.cn"
            case AppConfigLanguageCode.JA.rawValue:
                return "https://hypebeast.com/jp"
            case AppConfigLanguageCode.KR.rawValue:
                return "https://hypebeast.com/kr"
            default:
                return "https://hypebeast.com/"
            }
        }
        return "https://hypebeast.com/"
    }
    
    private func codeToIndex(code:AppConfigLanguageCode) -> Int {
            switch code {
            case AppConfigLanguageCode.EN:
                return 0
            case AppConfigLanguageCode.CNT:
                return 1
            case AppConfigLanguageCode.CNS:
                return 2
            case AppConfigLanguageCode.JA:
                return 3
            case AppConfigLanguageCode.KR:
                return 4
            default:
                return 0
            }
    }
    
    private func updateUI() {
        
        //Update Segmenet Control based on last saved value
        let userDefault = self.userDefault
        var code = AppConfigLanguageCode.EN
        
        if let languageCodeValue =  userDefault?.object(forKey: self.kLanguageKey) as? String {
            switch languageCodeValue {
            case AppConfigLanguageCode.EN.rawValue:
                code = AppConfigLanguageCode.EN
            case AppConfigLanguageCode.CNT.rawValue:
                code = AppConfigLanguageCode.CNT
            case AppConfigLanguageCode.CNS.rawValue:
                code = AppConfigLanguageCode.CNS
            case AppConfigLanguageCode.JA.rawValue:
                code = AppConfigLanguageCode.JA
            case AppConfigLanguageCode.KR.rawValue:
                code = AppConfigLanguageCode.KR
            default:
                code = AppConfigLanguageCode.EN
            }
        }
        let selectedIndex = self.codeToIndex(code: code)
        self.segmentControl.selectedSegmentIndex = selectedIndex
    }
    
    //MARK: - UITableViewDelegate & UIDataSrcDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ViewController.maxSize //self.dataSrc.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell_NewsWidget", for: indexPath as IndexPath) as! HBNewsWidgetCell
        if indexPath.row < self.dataSrc.count {
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
        }
        return cell
    }
}

