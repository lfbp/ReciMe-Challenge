//
//  RMBadge.swift
//  ReciMeProject
//
//  Created by Luis Pereira on 22/09/26.
//

import SwiftUI

struct RMBadge: View {
    let text: String
    let color: Color
    var icon: String? = nil
    
    var body: some View {
        HStack(spacing: 4) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.system(size: 10))
            }
            Text(text)
                .font(TypographyTokens.caption)
        }
        .padding(.horizontal, SpacingTokens.sm)
        .padding(.vertical, SpacingTokens.xs)
        .background(color.opacity(0.15))
        .foregroundColor(color)
        .cornerRadius(SpacingTokens.xs)
    }
}

#Preview {
    VStack(spacing: 12) {
        RMBadge(text: "Vegan", color: ColorTokens.veganColor, icon: "leaf.fill")
        RMBadge(text: "Gluten-Free", color: ColorTokens.glutenFreeColor, icon: "g.circle.fill")
        RMBadge(text: "Keto", color: ColorTokens.ketoColor, icon: "flame.fill")
    }
}
