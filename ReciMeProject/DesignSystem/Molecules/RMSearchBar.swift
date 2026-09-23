//
//  RMSearchBar.swift
//  ReciMeProject
//
//  Created by Luis Pereira on 22/09/26.
//

import SwiftUI

struct RMSearchBar: View {
    @Binding var searchText: String
    var placeholder: String = "Search..."
    var onClear: (() -> Void)?
    
    var body: some View {
        HStack(spacing: SpacingTokens.sm) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(ColorTokens.textSecondary)
            
            TextField(placeholder, text: $searchText)
                .font(TypographyTokens.body)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .submitLabel(.search)
            
            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                    onClear?()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(ColorTokens.textSecondary)
                }
            }
        }
        .padding(SpacingTokens.md)
        .background(ColorTokens.surfaceDark)
        .cornerRadius(10)
    }
}

#Preview {
    VStack {
        RMSearchBar(searchText: .constant(""))
        RMSearchBar(searchText: .constant("Pizza"))
    }
    .padding()
}
