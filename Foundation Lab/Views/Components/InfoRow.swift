//
//  InfoRow.swift
//  Foundation Lab
//
//  Created by xattacker on 2025/12/29.
//

import SwiftUI


struct InfoRow: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text(icon)
            Text(title)
                .foregroundStyle(.secondary)
                .frame(width: 80, alignment: .leading)

            Text(value)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .font(.body)
    }
}


struct InfoArrayRow: View {
    let icon: String
    let title: String
    let values: [String]

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text(icon)
            Text(title)
                .foregroundStyle(.secondary)
                .frame(width: 80, alignment: .leading)

            VStack(alignment: .leading, spacing: 8) {
                ForEach(values, id: \.self) {
                    value in
                    Text(value)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .font(.body)
    }
}
