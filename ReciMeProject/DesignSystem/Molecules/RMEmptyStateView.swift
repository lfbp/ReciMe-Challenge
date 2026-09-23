//
//  RMEmptyStateView.swift
//  ReciMeProject
//
//  Created by Luis Pereira on 22/09/26.
//

import SwiftUI

struct RMEmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    var actionTitle: String?
    var action: (() -> Void)?
    
    var body: some View {
        VStack(spacing: SpacingTokens.lg) {
            Image(systemName: icon)
                .font(.system(size: 64))
                .foregroundColor(ColorTokens.textSecondary)
            
            VStack(spacing: SpacingTokens.sm) {
                Text(title)
                    .font(TypographyTokens.title)
                    .foregroundColor(ColorTokens.textPrimary)
                
                Text(message)
                    .font(TypographyTokens.body)
                    .foregroundColor(ColorTokens.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            if let actionTitle = actionTitle, let action = action {
                RMButton(title: actionTitle, style: .primary, action: action)
                    .frame(maxWidth: 200)
            }
        }
        .padding(SpacingTokens.xl)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    RMEmptyStateView(
        icon: "tray",
        title: "No Recipes",
        message: "Start by adding your favorite recipes",
        actionTitle: "Add Recipe",
        action: {}
    )
}
