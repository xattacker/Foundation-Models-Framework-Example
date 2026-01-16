//
//  LandmarkResponse.swift
//  Foundation Lab
//
//  Created by xattacker on 2026/1/12.
//

import Foundation
import FoundationModels
import CoreLocation


@Generable
struct LandmarkResponse {
    @Guide(description: "包含景點列表, 最多回傳20筆", .maximumCount(20))
    let landmarks: [LandmarkInfo]
}


@Generable
struct LandmarkInfo: Identifiable { // <--- 在這裡加上 Identifiable
    // 新增 id 屬性，使用 address 作為唯一識別
    let markId = UUID().uuidString
    var id: String
    {
        return markId
    }
    
    @Guide(description: "景點名稱")
    let title: String
    
    @Guide(description: "景點緯度")
    let latitude: Double
    
    @Guide(description: "景點經度")
    let longitude: Double
    
    @Guide(description: "景點分類, 如交通設施、觀光景點、餐飲、加油站等")
    let category: String
    
    @Guide(description: "景點地址")
    let address: String
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

