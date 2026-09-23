//
//  RecipeFilterSheet.swift
//  ReciMeProject
//
//  Created by Luis Pereira on 22/09/26.
//

import SwiftUI

struct RecipeFilterSheet: View {
    @Binding var filter: RecipeFilter
    let availableCuisines: [String]
    let onApply: () -> Void
    let onReset: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section("Dietary tags") {
                    ForEach(DietaryAttribute.allCases) { attribute in
                        Button {
                            toggleDietary(attribute)
                        } label: {
                            HStack {
                                Image(systemName: attribute.icon)
                                    .foregroundColor(attribute.color)
                                    .frame(width: 24)
                                Text(attribute.displayName)
                                    .foregroundColor(ColorTokens.textPrimary)
                                Spacer()
                                if filter.dietaryAttributes.contains(attribute) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(ColorTokens.primary)
                                }
                            }
                        }
                    }
                }
                
                Section("Difficulty") {
                    difficultyRow(nil, title: "Any")
                    ForEach(Recipe.Difficulty.allCases, id: \.self) { difficulty in
                        difficultyRow(difficulty, title: difficulty.displayName)
                    }
                }
                
                Section("Cuisine") {
                    cuisineRow(nil, title: "Any")
                    ForEach(availableCuisines, id: \.self) { cuisine in
                        cuisineRow(cuisine, title: cuisine)
                    }
                }
                
                Section("Servings & prep time") {
                    Stepper(
                        value: Binding(
                            get: { filter.servings ?? 0 },
                            set: { filter.servings = $0 > 0 ? $0 : nil }
                        ),
                        in: 0...12
                    ) {
                        Text(filter.servings.map { "Min servings: \($0)" } ?? "Min servings: Any")
                    }
                    
                    Picker(
                        "Max prep time",
                        selection: Binding(
                            get: { filter.maxPrepTime ?? 0 },
                            set: { filter.maxPrepTime = $0 == 0 ? nil : $0 }
                        )
                    ) {
                        Text("Any").tag(0)
                        Text("≤ 15 min").tag(15)
                        Text("≤ 30 min").tag(30)
                        Text("≤ 45 min").tag(45)
                        Text("≤ 60 min").tag(60)
                    }
                }
            }
            .navigationTitle("Filters")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Reset") { onReset() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Apply") {
                        onApply()
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
    
    private func toggleDietary(_ attribute: DietaryAttribute) {
        if filter.dietaryAttributes.contains(attribute) {
            filter.dietaryAttributes.remove(attribute)
        } else {
            filter.dietaryAttributes.insert(attribute)
        }
    }
    
    private func difficultyRow(_ value: Recipe.Difficulty?, title: String) -> some View {
        Button {
            filter.difficulty = value
        } label: {
            HStack {
                Text(title).foregroundColor(ColorTokens.textPrimary)
                Spacer()
                if filter.difficulty == value {
                    Image(systemName: "checkmark")
                        .foregroundColor(ColorTokens.primary)
                }
            }
        }
    }
    
    private func cuisineRow(_ value: String?, title: String) -> some View {
        Button {
            filter.cuisine = value
        } label: {
            HStack {
                Text(title).foregroundColor(ColorTokens.textPrimary)
                Spacer()
                if filter.cuisine == value {
                    Image(systemName: "checkmark")
                        .foregroundColor(ColorTokens.primary)
                }
            }
        }
    }
}

#if DEBUG
#Preview("Filter Sheet") {
    RecipeFilterSheet(
        filter: .constant(RecipeFilter()),
        availableCuisines: ["Italian", "Mexican", "Japanese", "American"],
        onApply: {},
        onReset: {}
    )
}

#Preview("Filter Sheet — Active") {
    var filter = RecipeFilter()
    filter.dietaryAttributes = [.vegetarian, .glutenFree]
    filter.difficulty = .easy
    filter.cuisine = "Italian"
    filter.servings = 2
    filter.maxPrepTime = 30
    
    return RecipeFilterSheet(
        filter: .constant(filter),
        availableCuisines: ["Italian", "Mexican", "Japanese"],
        onApply: {},
        onReset: {}
    )
}
#endif
