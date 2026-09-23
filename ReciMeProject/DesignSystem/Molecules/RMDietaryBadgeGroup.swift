//
//  RMDietaryBadgeGroup.swift
//  ReciMeProject
//
//  Created by Luis Pereira on 22/09/26.
//

import SwiftUI

struct RMDietaryBadgeGroup: View {
    let attributes: [DietaryAttribute]
    var maxDisplay: Int = 3
    
    var body: some View {
        HStack(spacing: SpacingTokens.xs) {
            ForEach(Array(attributes.prefix(maxDisplay))) { attribute in
                RMBadge(
                    text: attribute.displayName,
                    color: attribute.color,
                    icon: attribute.icon
                )
            }
            
            if attributes.count > maxDisplay {
                RMBadge(
                    text: "+\(attributes.count - maxDisplay)",
                    color: ColorTokens.textSecondary,
                    icon: nil
                )
            }
        }
    }
}

#Preview {
    RMDietaryBadgeGroup(attributes: [
        .vegan,
        .glutenFree,
        .highProtein,
        .organic
    ], maxDisplay: 2)
}
