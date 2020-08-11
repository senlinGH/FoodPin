//
//  RestaurantTableViewController.swift
//  Food Pin
//
//  Created by Lin Yi Sen on 2020/6/8.
//  Copyright © 2020 AppCoda. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class RestaurantTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchResultsUpdating {
    
    var restaurants: [RestaurantMO] = []
    var searchController: UISearchController!
    var searchResults: [RestaurantMO] = []  // 宣告searchResults來儲存搜尋結果
    
    // 對於這個讀取結果控制器建立一個實例變數
    var fetchResultController: NSFetchedResultsController<RestaurantMO>!
    
    @IBOutlet var emptyRestaurantView: UIView!
    
    
    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true   // 導覽列使用大標題
        
        // 自訂導覽列大標題的字型大小和顏色
        if let customFont = UIFont(name: "Rubik-Medium", size: 40.0) {
            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 231, green: 76, blue: 60), NSAttributedString.Key.font: customFont]
        }
        
        // 自訂導覽列小標題的字型大小和顏色
        if let titleCustomFont = UIFont(name: "Rubik-Medium", size: 20.0) {
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 231, green: 76, blue: 60), NSAttributedString.Key.font: titleCustomFont]
        }
        
        // 準備空視圖
        tableView.backgroundView = emptyRestaurantView
        tableView.backgroundView?.isHidden = true
        
        // 從資料儲存區中讀取資料
        let fetchRequest: NSFetchRequest<RestaurantMO> = RestaurantMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do {
                try fetchResultController.performFetch()
                if let fetchedObjects = fetchResultController.fetchedObjects {
                    restaurants = fetchedObjects
                }
            } catch  {
                print(error)
            }
        }
        
        // 建立UISearchController的實例，如果傳遞nil值，表示搜尋結果會顯示於你正在搜尋的相同視圖中
        searchController = UISearchController(searchResultsController: nil)
        
        self.navigationItem.searchController = searchController // 導覽列加上搜尋列
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        
        // 自訂搜尋列的外觀
        searchController.searchBar.placeholder = NSLocalizedString("Search restaurant...", comment: "Search restaurant...")
        searchController.searchBar.barTintColor = .white
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.tintColor = UIColor(red: 231, green: 76, blue: 60)
        
        prepareNotification()   // 呼叫通知func
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 自訂導覽列的背景圖片為白色圖片
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "white"), for: .default)
        navigationController?.hidesBarsOnSwipe = true     // 設定滑動方式隱藏導覽列
    }
    
    
    // MARK: - Table view 資料來源
    
    // 這個方法是回傳表格區塊數與區塊內的列數
    override func numberOfSections(in tableView: UITableView) -> Int {
        if restaurants.count > 0 {
            tableView.backgroundView?.isHidden = true
            tableView.separatorStyle = .singleLine
        } else {
            tableView.backgroundView?.isHidden = false
            tableView.separatorStyle = .none
        }
        
        return 1
    }
    
    // 這個方法是用來通知tableView的一個區塊中的總列數
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return searchResults.count
        } else {
            return restaurants.count
        }
        
    }

    // 這個方法是在每次表格列要顯示時會被呼叫
    // 從indexPath物件，我們可以取得目前正在顯示的列(indexPath.row)，因此作法是從restaurantName陣列中取得索引項目， 然後指定文字標籤(cell.textLable?.text)要顯示的文字
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "datacell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RestaurantTableViewCell
        
        // 判斷是從搜尋結果或是原來的陣列來取得餐廳
        let restaurant = (searchController.isActive) ? searchResults[indexPath.row] : restaurants[indexPath.row]
        

        // 設定cell...
        cell.nameLabel.text = restaurant.name
        if let restaurantImage = restaurant.image {
            cell.thumbnialImageView.image = UIImage(data: restaurantImage as Data)
        }
        cell.locationLabel.text = restaurant.location
        cell.tyoeLabel.text = restaurant.type
        cell.heartImageView.isHidden = restaurant.isVisited ? false : true // 更新輔助視圖 (輔助視圖就是表單裡每列的最右邊顯示的圖片)
        cell.selectionStyle = .none     // 取消table被選取的狀態

        return cell
    }
    
    
    
    
    // MARK:  - Table view delegate 表格視圖的委派
    
    // 處理向左滑動動作
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // 建立刪除動作
        let deleteAction = UIContextualAction(style: .destructive, title: NSLocalizedString("Delete", comment: "Delete")) {   // .destructive指示按鈕紅色
            (action, sourceView, completionHandler) in
            
            // 從資料儲存區刪除一列
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                let context = appDelegate.persistentContainer.viewContext
                let restaurantToDelete = self.fetchResultController.object(at: indexPath)
                context.delete(restaurantToDelete)
                
                
                appDelegate.saveContext()
            }
            
            completionHandler(true) // 呼叫完成處理器來取消動作按鈕
        }
        
        // 建立分享動作
        let shareAction = UIContextualAction(style: .normal, title: NSLocalizedString("Share", comment: "Share")) {  // .normal指示按鈕灰色
            (action, sourceAction, completionHandler) in
            let defaultText = NSLocalizedString("Just checking in at ", comment: "Just checking in at ") + self.restaurants[indexPath.row].name!
            
            
            /*
            UIActivityViewController類別是一個提供數種標準服務的標準視圖控制器，如複製至剪貼簿、
            分享內容至社群網站、透過Message傳送項目等。
            */
            let activityController: UIActivityViewController
            
            if let restaurantImage = self.restaurants[indexPath.row].image,
                let imageToShare = UIImage(data: restaurantImage as Data) {
                activityController = UIActivityViewController(activityItems: [defaultText, imageToShare], applicationActivities: nil)
            } else {
                activityController = UIActivityViewController(activityItems: [defaultText], applicationActivities: nil)
            }
            
            
            // 針對iPad
            if let popoverController = activityController.popoverPresentationController {
                if let cell = tableView.cellForRow(at: indexPath) {
                    popoverController.sourceView = cell
                    popoverController.sourceRect = cell.bounds
                }
            }
            
            self.present(activityController, animated: true, completion: nil)
            completionHandler(true) // 呼叫完成處理器來取消動作按鈕
        }
        
        // 自訂動作按鈕的背景顏色和圖示
        deleteAction.backgroundColor = UIColor(red: 231, green: 76, blue: 60)
        deleteAction.image = UIImage(systemName: "trash")
        
        shareAction.backgroundColor = UIColor(red: 254, green: 149, blue: 38)
        shareAction.image = UIImage(systemName: "square.and.arrow.up")
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
        
        return swipeConfiguration
    }
    
    // 處理向右滑動動作
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let checkInAction = UIContextualAction(style: .normal, title: NSLocalizedString("Check-in", comment: "Check-in")) {
            (action, sourceView, completionhandler) in
            
            let cell = tableView.cellForRow(at: indexPath) as! RestaurantTableViewCell
            
            cell.heartImageView.isHidden = self.restaurants[indexPath.row].isVisited ? true : false
            self.restaurants[indexPath.row].isVisited = self.restaurants[indexPath.row].isVisited ? false : true
            
            completionhandler(true)
        }
        
        let checkInIcon = self.restaurants[indexPath.row].isVisited ? "heart.slash.fill" : "heart.fill"
        
        checkInAction.image = UIImage(systemName: checkInIcon)
        checkInAction.backgroundColor = UIColor.systemPink
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [checkInAction])
        
        return swipeConfiguration
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if searchController.isActive {
            return false
        } else {
            return true
        }
    }
    
    
    // MARK: - 地圖導航
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRestaurantDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! RestaurantDetailViewController
                
                destinationController.restaurant = (searchController.isActive) ? searchResults[indexPath.row] : restaurants[indexPath.row]
            }
        }
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - NSFetchedResultsControllerDelegate methods
    
    // 當NSFetchedResultsController準備開始處理內容變更時會被呼叫
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
        default:
            tableView.reloadData()
        }
        
        if let fetchedObjects = controller.fetchedObjects {
            restaurants = fetchedObjects as! [RestaurantMO]
        }
    }
    
    // 在NSFetchedResultsController完成變更後, 它會呼叫controllerDidChangeContent方法
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()  // 告訴表格視圖我們已經完成更新, 便會以相對應的動畫效果來呈現這個變更
    }
    
    
    
    // MARK: - Search bar 搜尋欄
    
    // 過濾內容
    func filterContent(for searchText: String) {
        searchResults = restaurants.filter({ (restaurant) -> Bool in
            if let name = restaurant.name, let location = restaurant.location {
                let isMatch = name.localizedCaseInsensitiveContains(searchText) || location.localizedCaseInsensitiveContains(searchText)
                return isMatch
            }
            return false
        })
    }
    
    
    // 更新搜尋結果
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContent(for: searchText)
            tableView.reloadData()
        }
    }
    
    // MARK: - 顯示導覽畫面
    
    override func viewDidAppear(_ animated: Bool) {
        
        // 判斷是否需要呈現導覽視圖控制器
        if UserDefaults.standard.bool(forKey: "hasViewedWalkthrough") {
            return
        }
        
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        if let walkthroughViewController = storyboard.instantiateViewController(withIdentifier: "WalkthroughViewController") as? WalkthroughViewController {
            
            present(walkthroughViewController, animated: true, completion: nil)
        }
        
    }

    // MARK: - TableView建立內容選單
    
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        // 建立一個UIContextMenuConfiguration物件，這個物件包含了"選單項目"與"預覽提供者"。
        let configuration = UIContextMenuConfiguration(identifier: indexPath.row as NSCopying, previewProvider: {
            
            guard let restaurantDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "RestaurantDetailViewController") as? RestaurantDetailViewController else {
                return nil
            }
            
            let selectedRestaurant = self.restaurants[indexPath.row]
            restaurantDetailViewController.restaurant = selectedRestaurant
            
            return restaurantDetailViewController
            
        }) { actions in
            
            let checkInAction = UIAction(title: "我的最愛", image: UIImage(systemName: "heart.fill")) {
        action in
                
                let cell = tableView.cellForRow(at: indexPath) as! RestaurantTableViewCell
                self.restaurants[indexPath.row].isVisited = self.restaurants[indexPath.row].isVisited ? false : true
                cell.heartImageView.isHidden = self.restaurants[indexPath.row].isVisited ? false : true
                }
            
            let shareAction = UIAction(title: "分享", image: UIImage(systemName: "square.and.arrow.up")) { action in
                
                let defaultText = self.restaurants[indexPath.row].name!
                
                let activityController: UIActivityViewController
                
                if let restaurantImage = self.restaurants[indexPath.row].image, let imageToShare = UIImage(data: restaurantImage as Data) {
                    activityController = UIActivityViewController(activityItems: [defaultText, imageToShare], applicationActivities: nil)
                } else {
                    activityController = UIActivityViewController(activityItems: [defaultText], applicationActivities: nil)
                }
                
                self.present(activityController, animated: true, completion: nil)
            }
            
            let deleteAction = UIAction(title: "刪除", image: UIImage(systemName: "trash"),  attributes: .destructive) { action in
                
                // 從儲存資料中刪除一列
                if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                    let context = appDelegate.persistentContainer.viewContext
                    let restaurantToDelete = self.fetchResultController.object(at: indexPath)
                    context.delete(restaurantToDelete)
                    
                    appDelegate.saveContext()
                }
            }
            
            // 以分享動作建立並回傳一個UIMenu
            return UIMenu(title: "", children: [checkInAction, shareAction, deleteAction])
        }
        
        return configuration
    }
            
    // MARK: - 預覽呈現完整內容
    
    override func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        
        guard let selectedRow = configuration.identifier as? Int else {
            print("Failed to retrieve the row number")
            return
        }
        
        guard let restaurantDetailViewController = self.storyboard?.instantiateViewController(identifier: "RestaurantDetailViewController") as? RestaurantDetailViewController else {
            return }
        
        let selectedRestaurant = self.restaurants[selectedRow]
        restaurantDetailViewController.restaurant = selectedRestaurant
        
        animator.preferredCommitStyle = .pop
        animator.addCompletion {
            self.show(restaurantDetailViewController, sender: self)
        }
        
    }

    // MARK: - 推薦通知
    
    func prepareNotification() {
        // 確認餐廳陣列不為空值
        if restaurants.count <= 0 {
            return
        }
        
        // 隨機選擇一間餐廳
        let randomNum = Int.random(in: 0..<restaurants.count)
        let suggestedRestaurant = restaurants[randomNum]
        
        // 建立使用者通知
        let content = UNMutableNotificationContent()    //content為可編輯內容通知的物件
        content.title = "餐廳推薦‼️"
        content.subtitle = "今天要吃美食嗎？"
        content.body = "我推薦你去 『\(suggestedRestaurant.name!)』。 這間餐廳是你的最愛之一。 它位於\(suggestedRestaurant.location!)。 你想去吃嗎？😋"
        content.sound = UNNotificationSound.default
        
        // 在通知中儲存電話號碼
        content.userInfo = ["phone": suggestedRestaurant.phone!]
        
        // 在通知中加入圖片
        let tempDirURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        let tempFileURL = tempDirURL.appendingPathComponent("suggested-restaurant.jpg")
        
        if let image = UIImage(data: suggestedRestaurant.image! as Data) {
            
            try? image.jpegData(compressionQuality: 1.0)?.write(to: tempFileURL)
            if let restaurantImage = try? UNNotificationAttachment(identifier: "restaurantImage", url: tempFileURL, options: nil) {
                content.attachments = [restaurantImage]
            }
        }
        
        // 與使用者通知互動 - 建立與註冊自訂動作
        let categoryIdentifer = "foodpin.restaurantaction"
        let makeReservationAction = UNNotificationAction(identifier: "foodpin.makeReservation", title: "訂位", options: [.foreground])
        let cancelAction = UNNotificationAction(identifier: "foodpin.cancel", title: "稍後通知", options: [])
        let category = UNNotificationCategory(identifier: categoryIdentifer, actions: [makeReservationAction, cancelAction], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
        content.categoryIdentifier = categoryIdentifer
        
        
        
        
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let request = UNNotificationRequest(identifier: "foodpin.restaurantSuggestion", content: content, trigger: trigger)
        
        // 排程通知
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
  

    
}
