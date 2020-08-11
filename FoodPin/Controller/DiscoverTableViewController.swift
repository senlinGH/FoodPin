//
//  DiscoverTableViewController.swift
//  FoodPin
//
//  Created by Lin Yi Sen on 2020/7/16.
//  Copyright © 2020 AppCoda. All rights reserved.
//

import UIKit
import CloudKit

class DiscoverTableViewController: UITableViewController {
    
    var restaurants: [CKRecord] = []    // restaurants變數來儲存CKRecord物件的陣列，並設定空陣列
    var spinner = UIActivityIndicatorView()
    
    private var imageCache = NSCache<CKRecord.ID, NSURL>()  // 使用CKRecord.ID作為鍵來快取NSURL物件
    
    

    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true   // 導覽列使用大標題
        
        // 設定導覽外觀
        if let customFont = UIFont(name: "Rubik-Medium", size: 40.0) {
            navigationController?.navigationBar.largeTitleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor(red: 231, green: 76, blue: 60),
                NSAttributedString.Key.font: customFont]
        }
        
        fetchRecordsFromCloud()
        
        spinner.style = .medium
        spinner.hidesWhenStopped = true     // 當動畫結束後是否隱藏指示器
        view.addSubview(spinner)
        
        // 定義旋轉指示器的佈局約束條件
        spinner.translatesAutoresizingMaskIntoConstraints = false   //告知iOS不要建立旋轉指示器視圖的自動佈局約束條件
        NSLayoutConstraint.activate([ spinner.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150.0), spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
        
        // 啟動旋轉指示器
        spinner.startAnimating()
        
        // 下拉更新控制元件
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = UIColor.white
        refreshControl?.tintColor = UIColor.gray
        refreshControl?.addTarget(self, action: #selector(fetchRecordsFromCloud), for: UIControl.Event.valueChanged)
        
        
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiscoverCell", for: indexPath) as! DiscoverTableViewCell
        
        // 設定cell...
        let restaurant = restaurants[indexPath.row]
        cell.nameLabel.text = restaurant.object(forKey: "name") as? String
        cell.typeLabel.text = restaurant.object(forKey: "type") as? String
        cell.phoneLabel.text = restaurant.object(forKey: "phone") as? String
        cell.locationLabel.text = restaurant.object(forKey: "location") as? String
        cell.descriptionLabel.text = restaurant.object(forKey: "description") as? String
        cell.selectionStyle = .none     // 取消table被選取的狀態
        
        // 設定預設圖片
        cell.featuredImageView.image = UIImage(named: "photo")
        
        // 檢查圖片是否已儲存在快取中
        if let imageFileURL = imageCache.object(forKey: restaurant.recordID) {
            // 從快取中取得圖片
            print("Get image from cache")
            if let imageData = try? Data.init(contentsOf: imageFileURL as URL){
                cell.featuredImageView.image = UIImage(data: imageData)
            }
        } else {
            // 在背景中從雲端取得圖片
            let publicDatabase = CKContainer.init(identifier: "iCloud.com.FoodPinByEthan").publicCloudDatabase
            let fetchRecordsImageOperation = CKFetchRecordsOperation(recordIDs: [restaurant.recordID])
            fetchRecordsImageOperation.desiredKeys = ["image"]
            fetchRecordsImageOperation.queuePriority = .veryHigh
            
            fetchRecordsImageOperation.perRecordCompletionBlock = { (record, recordID, error) -> Void in
                
                if let error = error {
                    print("Failed to get restaurant image: \(error.localizedDescription)")
                    return
                }
                
                if let restaurantRecord = record,
                    let image = restaurantRecord.object(forKey: "image"),
                    let imageAsset = image as? CKAsset {
                    
                    if let imageData = try? Data.init(contentsOf: imageAsset.fileURL!) {
                        
                        // 將佔位符圖片以餐廳圖片來取代
                        DispatchQueue.main.async {
                            cell.featuredImageView.image = UIImage(data: imageData)
                            cell.setNeedsLayout()
                        }
                        
                        // 加入圖片URL至快取
                        self.imageCache.setObject(imageAsset.fileURL! as NSURL, forKey: restaurant.recordID)
                    }
                }
            }
            
            publicDatabase.add(fetchRecordsImageOperation)
        }
        
        return cell
    }

    // MARK: - method
    
    @objc func fetchRecordsFromCloud() {
        
        // 在更新之前移除目前的資料紀錄
        restaurants.removeAll()
        tableView.reloadData()
        
        // 使用便利型API取得資料
        let cloudContainer = CKContainer(identifier: "iCloud.com.FoodPinByEthan") //取得App設定的CloudKit容器
        let publicDatabase = cloudContainer.publicCloudDatabase //
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Restaurant", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        // 以query建立查詢操作
        let queryOperation = CKQueryOperation(query: query) // 建立用於對資料庫做查詢的物件
        queryOperation.desiredKeys = ["name", "type", "phone", "location", "description"]  // .desiredKeys屬性可指定要取得的欄位
        queryOperation.queuePriority = .veryHigh    // .queuePriority屬性指定操作的執行順序
        queryOperation.resultsLimit = 50    // .resultsLimit屬性設定在任何時間的紀錄最大數
        queryOperation.recordFetchedBlock = { (record) -> Void in
            self.restaurants.append(record)
        }
        
        queryOperation.queryCompletionBlock = { [unowned self](cursor, error) -> Void in
            if let error = error {
                print("Faild to get data from iCloud - \(error.localizedDescription)")
                return
            }
            
            
            print("Successfully retrive the data from iCloud")
            
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
                self.tableView.reloadData()
                
                // 檢查更新控制元件是否還在更新狀態，如果是的話，呼叫endRefreshing()來結束動畫
                if let refreshControl = self.refreshControl {
                    if refreshControl.isRefreshing {
                        refreshControl.endRefreshing()
                    }
                }
            }
        }
        
        // 執行查詢
        publicDatabase.add(queryOperation)
        
        
        
        
    }

}
