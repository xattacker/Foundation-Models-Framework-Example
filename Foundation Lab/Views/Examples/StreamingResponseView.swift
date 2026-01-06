//
//  StreamingResponseView.swift
//  FoundationLab
//
//  Created by Rudrank Riyam on 6/29/25.
//

import FoundationModels
import SwiftUI

struct StreamingResponseView: View {
    @State private var currentPrompt = "我後天早上8點要從台北出發到台東進行3天2夜的旅遊, 並在第三天下午4點回去, 請規劃一下旅遊行程給我, 並提供每個行程花費的時間"
    @State private var executor = ExampleExecutor()
    @State private var streamingText = ""
    @State private var isStreaming = false

    var body: some View {
        ExampleViewBase(
            title: "Streaming Response",
            description: "Real-time response streaming as text is generated",
            defaultPrompt: currentPrompt,
            currentPrompt: $currentPrompt,
            isRunning: $executor.isRunning,
            errorMessage: executor.errorMessage,
            codeExample: DefaultPrompts.streamingResponseCode(prompt: currentPrompt),
            onRun: executeStreaming,
            onReset: resetToDefaults
        ) {
            VStack(spacing: 16) {
                // Info Banner
                HStack {
                    Image(systemName: "info.circle")
                        .foregroundColor(.green)
                    Text("Watch as the AI generates text in real-time, character by character")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                .padding()
                .background(Color.green.opacity(0.1))
                .cornerRadius(8)

                // Prompt Suggestions
                PromptSuggestions(
                    suggestions: DefaultPrompts.streamingSuggestions,
                    onSelect: { currentPrompt = $0 }
                )

                // Prompt History
                if !executor.promptHistory.isEmpty {
                    PromptHistory(
                        history: executor.promptHistory,
                        onSelect: { currentPrompt = $0 }
                    )
                }

                // Streaming Result Display
                if !streamingText.isEmpty || isStreaming {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Label("Streaming Output", systemImage: "text.cursor")
                                .font(.headline)

                            if isStreaming {
                                ProgressView()
                                    .scaleEffect(0.8)
                            }

                            Spacer()
                        }

                        ScrollViewReader { proxy in
                            ScrollView {
                                Text(streamingText)
                                    .animation(.easeInOut(duration: 0.3), value: streamingText)
                                    .font(.system(.body, design: .monospaced))
                                    .textSelection(.enabled)
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.secondaryBackgroundColor)
                                    .cornerRadius(8)
                                    .id("streamingText")
                                    .drawingGroup()
                            }
                            .frame(maxHeight: 300)
                            .onChange(of: streamingText) {
                                withAnimation {
                                    proxy.scrollTo("streamingText", anchor: .bottom)
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    private func executeStreaming() {
        Task {
            isStreaming = true
            streamingText = ""

            await executor.executeStreaming(
                prompt: currentPrompt,
                instructions: "旅遊規劃專家, 擁有豐富的行程安排經驗, 尤其是台灣地區"
            ) { partialResult in
                streamingText = partialResult
            }

            isStreaming = false
        }
    }

    private func resetToDefaults() {
        currentPrompt = "" // Clear the prompt completely
        streamingText = ""
        executor.clearAll() // Clear all results, errors, and history
    }
}

//#Preview {
//    NavigationStack {
//        StreamingResponseView()
//    }
//}
