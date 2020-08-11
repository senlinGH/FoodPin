//
//  MapViewController.swift
//  Food Pin
//
//  Created by Lin Yi Sen on 2020/6/23.
//  Copyright © 2020 AppCoda. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var mapView: MKMapView!
    
    var restaurant: RestaurantMO!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        
        // 自訂導覽列返回鍵的顏色
        navigationController?.navigationBar.tintColor = UIColor.label
        
    
    }
    
// MARK: - Table View 生命週期
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // 地址轉換為座標後並標記在地圖上
        let geoCoder = CLGeocoder()
        // ?? 是空盒運算子，作用是檢查 location 屬性是否有一個值，如果沒有的話，它將會使用我們設定在 ?? 之後的預設值
        geoCoder.geocodeAddressString(restaurant.location ?? "", completionHandler: {placemarks,
            error in
            if let error = error {
                print(error)
                return
            }
            
            if let placemarks = placemarks {
                // 取得第一個地點標記
                let placemark = placemarks[0]
                
                // 加上標記
                let annotation = MKPointAnnotation()
                annotation.title = self.restaurant.name
                annotation.subtitle = self.restaurant.type
                
                if let location = placemark.location {
                    annotation.coordinate = location.coordinate
                    
                    // 顯示標記
                    self.mapView.showAnnotations([annotation], animated: true)
                    self.mapView.selectAnnotation(annotation, animated: true)
                }
            }
        })
        
        // 定義 MapViewController 作為 mapView 的委派物件
        mapView.delegate = self
        mapView.showsCompass = true     // 地圖顯示交通流量大的點
        mapView.showsScale = true       // 地圖左上角顯示比例尺
        mapView.showsCompass = true     // 地圖右上角顯示指南針, 注意旋轉地圖才會出現
    }
    
    // MARK: - Map View 委派方法
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let  identifier = "MyMaker"
        
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        
        // 如果可行則再重複使用標記
        var annotationView: MKMarkerAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        
        annotationView?.glyphImage = UIImage(systemName: "mappin.and.ellipse")
        annotationView?.markerTintColor = UIColor(red: 231, green: 76, blue: 60)
        
        return annotationView
    }

}
