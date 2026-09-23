//
//  RMLoadingView.swift
//  ReciMeProject
//
//  Created by Luis Pereira on 22/09/26.
//

import SwiftUI

struct RMLoadingView: View {
    var message: String = "Loading..."
    
    var body: some View {
        VStack(spacing: SpacingTokens.md) {
            ProgressView()
                .scaleEffect(1.5)
            Text(message)
                .font(TypographyTokens.body)
                .foregroundColor(ColorTokens.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    RMLoadingView()
}
