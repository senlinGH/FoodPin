//
//  WalkthroughPageViewController.swift
//  FoodPin
//
//  Created by Lin Yi Sen on 2020/7/10.
//  Copyright © 2020 AppCoda. All rights reserved.
//

import UIKit

protocol WalkthroughPageViewControllerDeletage: class {
    func didUpdatePageIndex(currentIndex: Int)
}

class WalkthroughPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var pageHeadings = [NSLocalizedString("CREATE YOUR OWN FOOD GUIDE", comment: "CREATE YOUR OWN FOOD GUIDE"), NSLocalizedString("SHOW YOU THE LOCATION", comment: "SHOW YOU THE LOCATION"), NSLocalizedString("DISCOVER GREAT RESTAURANTS", comment: "DISCOVER GREAT RESTAURANTS")]
    var pageImages = ["onboarding-1", "onboarding-2", "onboarding-3"]
    var pageSubHeadings = [NSLocalizedString("Pin your favorite restaurants and create your own food guide", comment: "Pin your favorite restaurants and create your own food guide"),
                           NSLocalizedString("Search and locate your favourite restaurant on Maps", comment: "Search and locate your favourite restaurant on Maps"),
                           NSLocalizedString("Find restaurants shared by your friends and other foodies", comment: "Find restaurants shared by your friends and other foodies")]
    var currentIndex = 0    // 用來儲存目前頁面視圖的索引
    
    var walkthroughDelegate: WalkthroughPageViewControllerDeletage?
    
    // MARK: - Method 方法
    
    // 實作UIPageViewControllerDataSource協定中兩個所需的方法
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! WalkthroughContentViewController).index //取得既定視圖控制器的目前索引值
        index -= 1
        
        return contentViewController(at: index) // 回傳給視圖控制器來顯示
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! WalkthroughContentViewController).index //取得既定視圖控制器的目前索引值
        index += 1
        
        return contentViewController(at: index) // 回傳給視圖控制器來顯示
    }
    
    // 此方法是按照需求建立頁面內容視圖控制器，按照這些索引來建立相對應的頁面內容視圖控制器
    func contentViewController(at index: Int) -> WalkthroughContentViewController? {
        if index < 0 || index >= pageHeadings.count {
            return nil
        }
        
        // 建立新的視圖控制器並傳遞適合的資料
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        if let pageContentViewController = storyboard.instantiateViewController(withIdentifier: "WalkthroughContentViewController") as? WalkthroughContentViewController {
            
            pageContentViewController.imageFile = pageImages[index]
            pageContentViewController.heading = pageHeadings[index]
            pageContentViewController.subHeading = pageSubHeadings[index]
            pageContentViewController.index = index
            
            return pageContentViewController
        }
        
        return nil
    }
    
    // 這個方法被呼叫時，會自動建立下一個內容視圖控制器，如果這個控制器可以被建立，呼叫內建的setViewControllers方法，並導覽至下一個視圖控制器
    func forwardPage() {
        currentIndex += 1
        if let nextViewController = contentViewController(at: currentIndex) {
            setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        // 先檢查轉場是否已經完成，並找出目前的頁面索引值，然後呼叫didUpdatePageIndex來通知這個委派
        if completed {
            if let contentViewController = pageViewController.viewControllers?.first as? WalkthroughContentViewController {
                
                currentIndex = contentViewController.index
                
                walkthroughDelegate?.didUpdatePageIndex(currentIndex: contentViewController.index)
            }
        }
    }
   
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 將資料源設定為自己
        dataSource = self
        
        // 建立第一個導覽畫面
        if let startingViewController = contentViewController(at: 0) {
            setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)
        }
        
        delegate = self // 指定UIPageViewControllerDelegate協定的委派
    }

}
