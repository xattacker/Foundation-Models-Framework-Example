//
//  LandmarkQueryView.swift
//  FoundationLab
//
//  Created by Rudrank Riyam on 6/29/25.
//

import FoundationModels
import SwiftUI


struct LandmarkQueryView: View {
  @State private var currentPrompt = "餐飲"
  @State private var executor = ExampleExecutor()

  var body: some View {
    ExampleViewBase(
      title: "Query Landamrks",
      description: "Query Landamrks with constraints and structured output",
      defaultPrompt: "餐飲",
      currentPrompt: $currentPrompt,
      promptInputHeight: 50,
      isRunning: $executor.isRunning,
      errorMessage: executor.errorMessage,
      //codeExample: DefaultPrompts.generationGuidesCode(prompt: currentPrompt),
      onRun: executeQueryLandmark,
      onReset: resetToDefaults
    ) {
      VStack(spacing: 16) {
        // Info Banner
        HStack {
          Image(systemName: "info.circle")
            .foregroundColor(.blue)
          Text("Uses @Guide annotations to structure product reviews with ratings, pros, cons, and recommendations")
            .font(.caption)
            .foregroundColor(.secondary)
          Spacer()
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(8)

        // Prompt Suggestions
        PromptSuggestions(
          suggestions: ["餐飲", "加油站", "交通設施", "便利商店", "購物"],
          onSelect: { currentPrompt = $0 }
        )

        // Prompt History
        if !executor.promptHistory.isEmpty {
          PromptHistory(
            history: executor.promptHistory,
            onSelect: { currentPrompt = $0 }
          )
        }

        // Result Display
          if let resultView = executor.resultView
          {
              VStack(alignment: .leading, spacing: 12) {
                Label("Generated Product Review", systemImage: "star.leadinghalf.filled")
                  .font(.headline)

                ResultViewDisplay(
                  resultView: resultView,
                  isSuccess: executor.errorMessage == nil
                )
              }
        }
        else if let error = executor.errorMessage
        {
            ErrorResultDisplay(error: error)
        }
      }
    }
  }

  private func executeQueryLandmark() {
      var prompt = "中心經緯度座標: 25.04646322,121.5179381,"
      prompt += "搜尋半徑: 5公里,"
      prompt += "category: " + self.currentPrompt
      
      Task {
        await executor.executeStructuredV2(
          prompt: prompt,
          instructions: "幫我以傳入中心經緯度座標/搜尋半徑以及分類(category)查詢周圍的landmark資訊回來", // 描述設定 Model 的角色身份
          type: LandmarkResponse.self
        ) {
          response in
            return LandmarkMapView(landmarks: response.landmarks)
                   .frame(height: 300)
        }
      }
  }

  private func resetToDefaults() {
    currentPrompt = "" // Clear the prompt completely
    executor.clearAll() // Clear all results, errors, and history
  }
}

//#Preview {
//  NavigationStack {
//    GenerationGuidesView()
//  }
//}
