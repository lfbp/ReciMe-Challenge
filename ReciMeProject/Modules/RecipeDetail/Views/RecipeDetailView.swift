//
//  RecipeDetailView.swift
//  ReciMeProject
//
//  Created by Luis Pereira on 22/09/26.
//

import SwiftUI

struct RecipeDetailView: View {
    @StateObject var viewModel: RecipeDetailViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SpacingTokens.lg) {
                RoundedRectangle(cornerRadius: 0)
                    .fill(ColorTokens.primary.opacity(0.2))
                    .frame(height: 250)
                    .overlay(
                        Image(systemName: "fork.knife")
                            .font(.system(size: 80))
                            .foregroundColor(ColorTokens.primary.opacity(0.3))
                    )
                
                VStack(alignment: .leading, spacing: SpacingTokens.md) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: SpacingTokens.xs) {
                            Text(viewModel.recipe.title)
                                .font(TypographyTokens.title)
                                .foregroundColor(ColorTokens.textPrimary)
                            
                            Text(viewModel.recipe.cuisine)
                                .font(TypographyTokens.subheadline)
                                .foregroundColor(ColorTokens.textSecondary)
                        }
                        
                        Spacer()
                        
                        RMFavoriteButton(
                            isFavorite: viewModel.isFavorite,
                            action: { viewModel.toggleFavorite() }
                        )
                    }
                    
                    Text(viewModel.recipe.description)
                        .font(TypographyTokens.body)
                        .foregroundColor(ColorTokens.textSecondary)
                    
                    HStack(spacing: SpacingTokens.lg) {
                        Label("\(viewModel.recipe.servings) servings", systemImage: "person.2.fill")
                        Label("\(viewModel.recipe.prepTime) min prep", systemImage: "clock.fill")
                        Label("\(viewModel.recipe.cookTime) min cook", systemImage: "flame.fill")
                    }
                    .font(TypographyTokens.caption)
                    .foregroundColor(ColorTokens.textSecondary)
                    
                    RMDietaryBadgeGroup(attributes: viewModel.recipe.dietaryAttributes, maxDisplay: 10)
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: SpacingTokens.sm) {
                        Text("Ingredients")
                            .font(TypographyTokens.title3)
                            .foregroundColor(ColorTokens.textPrimary)
                        
                        ForEach(viewModel.recipe.ingredients, id: \.self) { ingredient in
                            HStack(alignment: .top, spacing: SpacingTokens.sm) {
                                Image(systemName: "circle.fill")
                                    .font(.system(size: 6))
                                    .foregroundColor(ColorTokens.primary)
                                    .padding(.top, 6)
                                
                                Text(ingredient)
                                    .font(TypographyTokens.body)
                                    .foregroundColor(ColorTokens.textPrimary)
                            }
                        }
                    }
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: SpacingTokens.sm) {
                        Text("Instructions")
                            .font(TypographyTokens.title3)
                            .foregroundColor(ColorTokens.textPrimary)
                        
                        ForEach(Array(viewModel.recipe.instructions.enumerated()), id: \.offset) { index, instruction in
                            HStack(alignment: .top, spacing: SpacingTokens.sm) {
                                Text("\(index + 1).")
                                    .font(TypographyTokens.headline)
                                    .foregroundColor(ColorTokens.primary)
                                    .frame(width: 24, alignment: .leading)
                                
                                Text(instruction)
                                    .font(TypographyTokens.body)
                                    .foregroundColor(ColorTokens.textPrimary)
                            }
                        }
                    }
                }
                .padding(SpacingTokens.md)
            }
        }
        .navigationTitle(viewModel.recipe.title)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .background(ColorTokens.background)
    }
}
