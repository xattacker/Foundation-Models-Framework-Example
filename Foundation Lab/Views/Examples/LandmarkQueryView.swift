//
//  LandmarkQueryView.swift
//  FoundationLab
//
//  Created by Rudrank Riyam on 6/29/25.
//

import FoundationModels
import SwiftUI


struct LandmarkQueryView: View {
  @State private var currentPrompt = "餐廳"
  @State private var executor = ExampleExecutor()

  var body: some View {
    ExampleViewBase(
      title: "Query Landamrks",
      description: "Query Landamrks with constraints and structured output",
      defaultPrompt: "餐廳",
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
          suggestions: DefaultPrompts.generationGuidesSuggestions,
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
      var prompt = "latitude-longitude: 25.04646322, 121.5179381,"
      prompt += "搜尋半徑: 5公里,"
      prompt += "category: " + self.currentPrompt
      
      Task {
        await executor.executeStructuredV2(
          prompt: prompt,
          instructions: "幫我以傳入座標點以及分類查詢周圍的landmark 資訊回來", // 描述設定 Model 的角色身份
          type: LandmarkResponse.self
        ) {
          response in
            return VStack(alignment: .leading, spacing: 12) {
                
                ForEach(response.landmarks, id: \.address) {
                    landmark in
                    Text(landmark.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
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
