//
//  GenerationGuidesView.swift
//  FoundationLab
//
//  Created by Rudrank Riyam on 6/29/25.
//

import FoundationModels
import SwiftUI

struct GenerationGuidesView: View {
  @State private var currentPrompt = DefaultPrompts.generationGuides
  @State private var executor = ExampleExecutor()

  var body: some View {
    ExampleViewBase(
      title: "Generation Guides",
      description: "Guided generation with constraints and structured output",
      defaultPrompt: DefaultPrompts.generationGuides,
      currentPrompt: $currentPrompt,
      promptInputHeight: 50,
      isRunning: $executor.isRunning,
      errorMessage: executor.errorMessage,
      codeExample: DefaultPrompts.generationGuidesCode(prompt: currentPrompt),
      onRun: executeGenerationGuides,
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

  private func executeGenerationGuides() {
      Task {
        await executor.executeStructuredV2(
          prompt: currentPrompt,
          instructions: "專業的老司機, 對各種車款都很了解", // 描述設定 Model 的角色身份
          type: CarPerformance.self
        ) {
          performance in
            return VStack(alignment: .leading, spacing: 12) {
                InfoRow(
                    icon: "📖",
                    title: "廠牌",
                    value: performance.brandName
                )

                InfoRow(
                    icon: "📖",
                    title: "車型",
                    value: performance.modelName
                )

                Divider()

                InfoRow(
                    icon: "📍",
                    title: "動力系統",
                    value: performance.powerType.title
                )

                InfoRow(
                    icon: "📍",
                    title: "座位數",
                    value: "\(performance.seat) 人座"
                )

                InfoRow(
                    icon: "📍",
                    title: "續航里程",
                    value: performance.rangeKm.map { "\($0) km" } ?? "—"
                )

                InfoRow(
                    icon: "📍",
                    title: "最大馬力",
                    value: "\(performance.horsePower) hp"
                )

                InfoRow(
                    icon: "📍",
                    title: performance.powerType == .electric ? "平均能耗" : "平均油耗",
                    value: performance.efficiency
                )
                
                InfoRow(
                    icon: "📍",
                    title: "妥善率",
                    value: String(format: "%d", performance.reliability)
                )

                Divider()

                InfoRow(
                    icon: "🏷️",
                    title: "評比分數",
                    value: String(format: "%.1f", performance.score)
                )

                InfoRow(
                    icon: "🏷️",
                    title: "評語",
                    value: performance.comment
                )
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
