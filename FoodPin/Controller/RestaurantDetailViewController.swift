//
//  RestaurantDetailViewController.swift
//  Food Pin
//
//  Created by Lin Yi Sen on 2020/6/16.
//  Copyright © 2020 AppCoda. All rights reserved.
//

import UIKit

class RestaurantDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var headerView: RestaurantDetailHeaderView!
    
    var restaurant: RestaurantMO!
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 設定頭部視圖HeaderView
        headerView.nameLabel.text = restaurant.name
        headerView.typeLabel.text = restaurant.type
        if let restaurantImage = restaurant.image {
            headerView.headerImageView.image = UIImage(data: restaurantImage as Data)
        }
        headerView.heartImageView.isHidden = (restaurant.isVisited) ? false : true
        
        navigationItem.largeTitleDisplayMode = .never // 停用大標題
        
        // 連結DataSource與Delegate，必須告訴UITableView物件，ViewController是資料來源的委派物件
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none    // 移除TableView的分隔符號
        tableView.contentInsetAdjustmentBehavior = .never
        
        // 顯示評價
        if let rating = restaurant.rating {
            headerView.ratingImageView.image = UIImage(named: rating)
        }
    }
    
    // 這個方法是在每次視圖準備被顯示時呼叫
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
        // 自訂導覽列返回鍵的顏色
        navigationController?.navigationBar.tintColor = UIColor.white
        
        // 設定導覽列變透明
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    
    
    
    // MARK: - Table view 資料來源
    
    // 這個方法是回傳表格區塊數與區塊內的列數
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // 這個方法是用來通知tableView的一個區塊中的總列數
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 使用switch來控制程式流程，依照indexPath.row的值來執行不同的程式
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailIconTextCell.self), for: indexPath) as! RestaurantDetailIconTextCell
            // 用cell填入電話圖示並呼叫.withTintColor輸入你想要的顏色
            cell.iconImageView.image = UIImage(systemName: "phone")?.withTintColor(.label, renderingMode: .alwaysOriginal)
            // 用cell填入電話號碼
            cell.shortTextLabel.text = restaurant.phone
            cell.selectionStyle = .none     // 取消table被選取的狀態
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailIconTextCell.self), for: indexPath) as! RestaurantDetailIconTextCell
            // 用cell填入地圖圖示並呼叫.withTintColor輸入你想要的顏色
            cell.iconImageView.image = UIImage(systemName: "map")?.withTintColor(.label, renderingMode: .alwaysOriginal)
            // 用cell填入地址
            cell.shortTextLabel.text = restaurant.location
            cell.selectionStyle = .none     // 取消table被選取的狀態
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailTextCell.self), for: indexPath) as! RestaurantDetailTextCell
            // 用cell填入評論
            cell.descriptionLabel.text = restaurant.summary
            cell.selectionStyle = .none     // 取消table被選取的狀態
            
            return cell
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailSeparatorCell.self), for: indexPath) as! RestaurantDetailSeparatorCell
            cell.titleLabel.text = "Map"
            cell.selectionStyle = .none     // 取消table被選取的狀態
            
            return cell
            
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailMapCell.self), for: indexPath) as! RestaurantDetailMapCell
            if let restaurantLocation = restaurant.location {
                cell.configure(location: restaurantLocation)
            }
            
            return cell
        default:
            fatalError("Failed to instantiate the table view cell for detail view controller")
        }
    }
    
    // MARK: - Status bar 設定
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent    // 變更狀態列的樣式為亮色系
    }
    
    // MARK: - 地圖導航
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMap" {
            let destinationController = segue.destination as! MapViewController
            destinationController.restaurant = restaurant
        } else if segue.identifier == "showReview" {
            let destinationController = segue.destination as! ReviewViewController
            destinationController.restaurant = restaurant
        }
    }
    
    // 定義一個回退動作，這裡只是呼叫dismiss方法來取消評價視圖控制器
    @IBAction func close(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func rateRestaurant(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: {
            if let rating = segue.identifier {
                self.restaurant.rating = rating
                self.headerView.ratingImageView.image = UIImage(named: rating)
                
                if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                    appDelegate.saveContext()
                }
                
                let scaleTransform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
                self.headerView.ratingImageView.transform = scaleTransform
                self.headerView.ratingImageView.alpha = 0
                
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.3,initialSpringVelocity: 0.7, options: [], animations: {
                    self.headerView.ratingImageView.transform = .identity
                    self.headerView.ratingImageView.alpha = 1
                }, completion: nil)
                
            }
        })
    }
}
