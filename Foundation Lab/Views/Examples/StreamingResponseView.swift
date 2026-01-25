//
//  StreamingResponseView.swift
//  FoundationLab
//
//  Created by Rudrank Riyam on 6/29/25.
//

import FoundationModels
import SwiftUI

struct StreamingResponseView: View {
    @State private var currentPrompt = "- 時間區段: 3天2夜, 早上8點出發 到第三天下午四點準備回程,\n- 出發地點: 台北,\n- 目的地點: 台東,\n- 旅遊範圍:台東,\n- 交通工具: 自駕汽車,\n- 其他需求: 住宿選擇民宿, 一晚價位3000元內\n-行程時間要考慮交通工具的行駛速度\n- 避免去太遠的離島外島"
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
                instructions: "你是台灣地區旅遊規行程劃專家, 擁有豐富的行程安排經驗"
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
