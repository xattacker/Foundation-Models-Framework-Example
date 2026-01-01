//
//  CarPerformanceTool.swift
//  Foundation Lab
//
//  Created by xattacker on 2025/12/31.
//

import Foundation
import FoundationModels

// 自定義的 Tool Calling
struct CarPerformanceTool: Tool {
    let name = "fetch_car_spec"
    let description = "查詢車款資料"

    @Generable
    struct Arguments: Codable {
        let brand: String
        let model: String
    }

    func call(arguments: Arguments) async throws -> CarPerformance {
        // 回傳一筆 CarPerformance 假資料，便於測試
        let mock = CarPerformance(
                        brandName: arguments.brand,
                        modelName: arguments.model,
                        powerType: .fuel,
                        seat: 5,
                        horsePower: 4,
                        zeroToHundredSec: 320,
                        rangeKm: 15,
                        efficiency: "15L/100km",
                        reliabilityRanking: 5,
                        score: 80,
                        advantages: ["1", "2", "3"],
                        defects: ["4", "5"],
                        comment: "假資料而已")
        return mock
    }
}
