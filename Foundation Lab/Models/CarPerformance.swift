//
//  CarPerformance.swift
//  Foundation Lab
//
//  Created by xattacker on 2025/12/29.
//

import Foundation
import FoundationModels


@Generable
enum CarPowerType: String
{
    case electric = "electric" // 電動車
    case fuel = "gasoline" // 燃油車
    case hybrid = "hybrid" // 油電混合車
    
    var title: String
    {
        switch self {
            case .electric:
                return "電車"
            case .fuel:
                return "油車"
            case .hybrid:
                return "混合動力"
        }
    }
}


/// 車款性能比較項目
@Generable
struct CarPerformance {
    @Guide(description: "廠牌名稱, 例如：福斯、三菱")
    let brandName: String

    @Guide(description: "車款名稱，例如：Tesla Model 3、Toyota Camry")
    let modelName: String

    @Guide(description: "動力系統類型，請選擇 electric / fuel / hybrid")
    let powerType: CarPowerType
    
    @Guide(description: "幾人座")
    let seat: Int

    @Guide(description: "最大馬力 (PS)")
    let horsePower: Int

    @Guide(description: "0-100 km/h 加速時間 (秒)，若無則填 null")
    let zeroToHundredSec: Double?

    @Guide(description: "續航里程（公里），如適用")
    let rangeKm: Int?

    @Guide(description: "能源效率或平均油耗（例如：km/kWh 或 L/100km）")
    let efficiency: String
 
    @Guide(description: "妥善率排名，維持穩定、不易發生故障的程度，數字愈小愈好，以台灣歷年來的排名數據為主")
    let reliabilityRanking: Int

    @Guide(description: "整體性能評比分數", .range(0...100))
    let score: Double
    
    @Guide(description: "車款優點條列")
    let advantages: [String]
    
    @Guide(description: "車款缺陷條列")
    let defects: [String]

    @Guide(description: "簡短評語，用中文描述性能優缺點")
    let comment: String
}
