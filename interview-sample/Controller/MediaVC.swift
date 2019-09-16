//
//  MediaVC.swift
//  interview-sample
//
//  Created by Alireza Khakpour on 9/16/19.
//  Copyright © 2019 Alireza Khakpour. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class MediaVC: BaseVC {
    
    // MARK: Properties
    var listData: [MediaStruct] = [MediaStruct]()
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureTable()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getListData()
        tableView.rowHeight = view.frame.width * 0.90
        
    }
    
    func getListData(){
        
        self.showSpinner()
        TheClient.sharedInstance().getMediaInfo { (results, error) in
            if let error = error {
                performUIUpdatesOnMain {
                    self.removeSpinner()
                }
                self.showConnectionResponseError(errorMessage: error)
            } else {
                if let results = results {
                    self.listData = results
                    performUIUpdatesOnMain {
                        self.removeSpinner()
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
}

extension MediaVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellReuseIdentifier = "mediaCell"
        let item = listData[(indexPath as NSIndexPath).row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! MediaTableCell
        if let url = URL(string: item.imgUrl){
            cell.imgView.kf.setImage(with: url)
        }
        
        cell.descLbl.text = item.desc
        cell.playBtn.isHidden = true
        
        return cell
    }
    
    func configureTable() {
        // This view controller itself will provide the delegate methods and row data for the table view.
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}
