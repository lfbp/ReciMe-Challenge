//
//  RMFavoriteButton.swift
//  ReciMeProject
//
//  Created by Luis Pereira on 22/09/26.
//

import SwiftUI

struct RMFavoriteButton: View {
    let isFavorite: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .font(.system(size: 24))
                .foregroundColor(isFavorite ? ColorTokens.accentRed : ColorTokens.textSecondary)
                .contentTransition(.symbolEffect(.replace))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HStack(spacing: 40) {
        RMFavoriteButton(isFavorite: false, action: {})
        RMFavoriteButton(isFavorite: true, action: {})
    }
}
