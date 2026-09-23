//
//  RecipeRowCard.swift
//  ReciMeProject
//
//  Created by Luis Pereira on 22/09/26.
//

import SwiftUI

struct RecipeRowCard: View {
    let recipe: Recipe
    let isFavorite: Bool
    let onTap: () -> Void
    let onFavoriteToggle: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: SpacingTokens.md) {
                // Recipe Image Placeholder
                RoundedRectangle(cornerRadius: 12)
                    .fill(ColorTokens.primary.opacity(0.1))
                    .frame(width: 80, height: 80)
                    .overlay(
                        Image(systemName: "fork.knife")
                            .font(.system(size: 32))
                            .foregroundColor(ColorTokens.primary.opacity(0.3))
                    )
                
                // Recipe Info
                VStack(alignment: .leading, spacing: SpacingTokens.xs) {
                    Text(recipe.title)
                        .font(TypographyTokens.headline)
                        .foregroundColor(ColorTokens.textPrimary)
                        .lineLimit(2)
                    
                    Text(recipe.description)
                        .font(TypographyTokens.caption)
                        .foregroundColor(ColorTokens.textSecondary)
                        .lineLimit(2)
                    
                    HStack(spacing: SpacingTokens.sm) {
                        Label("\(recipe.servings)", systemImage: "person.2.fill")
                        Label("\(recipe.totalTime) min", systemImage: "clock.fill")
                    }
                    .font(TypographyTokens.caption)
                    .foregroundColor(ColorTokens.textSecondary)
                    
                    RMDietaryBadgeGroup(attributes: recipe.dietaryAttributes, maxDisplay: 2)
                }
                
                Spacer()
                
                // Favorite Button
                RMFavoriteButton(isFavorite: isFavorite, action: onFavoriteToggle)
            }
            .padding(SpacingTokens.md)
            .background(ColorTokens.surface)
            .cornerRadius(16)
            .shadow(
                color: Color.black.opacity(0.05),
                radius: 8,
                x: 0,
                y: 2
            )
        }
        .buttonStyle(.plain)
    }
}
