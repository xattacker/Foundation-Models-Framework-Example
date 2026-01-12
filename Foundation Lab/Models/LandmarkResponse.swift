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
struct LandmarkInfo {
    @Guide(description: "景點名稱")
    let title: String
    
    @Guide(description: "景點緯度")
    let latitude: Double
    
    @Guide(description: "景點經度")
    let longitude: Double
    
    @Guide(description: "景點分類, 如交通設施、觀光景點、餐廳、加油站等")
    let category: String
    
    @Guide(description: "景點地址")
    let address: String
}
