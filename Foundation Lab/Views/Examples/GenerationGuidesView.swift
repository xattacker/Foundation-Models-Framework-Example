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
        if !executor.result.isEmpty {
          VStack(alignment: .leading, spacing: 12) {
            Label("Generated Product Review", systemImage: "star.leadinghalf.filled")
              .font(.headline)

            ResultDisplay(
              result: executor.result,
              isSuccess: executor.errorMessage == nil
            )
          }
        }
      }
    }
  }

  private func executeGenerationGuides() {
      Task {
        await executor.executeStructured(
          prompt: currentPrompt,
          type: CarPerformance.self
        ) { performance in
          """
          🛍️ 廠牌: \(performance.brandName)
                  
          🛍️ 車型: \(performance.modelName)
                      
          📌 動力系統:
          \(performance.powerType.title)
                      
          📌 座位數:
           \(String(format: "%d人座", performance.seat))
                                               
          📌 續航里程:
          \(performance.rangeKm ?? -1)
          
          📌 最大馬力:
          \(performance.horsePower)

          📌 \(performance.powerType == .electric ? "平均能耗" : "平均油耗"):
          \(performance.efficiency)
                        
          📌 評比分數:
          \(performance.score)
                                
          📌 評語:
          \(performance.comment)
          """
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
