//
//  RMButton.swift
//  ReciMeProject
//
//  Created by Luis Pereira on 22/09/26.
//

import SwiftUI

struct RMButton: View {
    enum Style {
        case primary
        case secondary
        case outline
        case text
    }
    
    let title: String
    let style: Style
    let action: () -> Void
    var isLoading: Bool = false
    var isDisabled: Bool = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: SpacingTokens.sm) {
                if isLoading {
                    ProgressView()
                        .tint(textColor)
                }
                Text(title)
                    .font(TypographyTokens.headline)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, SpacingTokens.md)
            .padding(.horizontal, SpacingTokens.lg)
            .background(backgroundColor)
            .foregroundColor(textColor)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(borderColor, lineWidth: style == .outline ? 2 : 0)
            )
        }
        .disabled(isDisabled || isLoading)
        .opacity(isDisabled ? 0.5 : 1)
    }
    
    private var backgroundColor: Color {
        switch style {
        case .primary: return ColorTokens.primary
        case .secondary: return ColorTokens.secondary
        case .outline, .text: return .clear
        }
    }
    
    private var textColor: Color {
        switch style {
        case .primary, .secondary: return .white
        case .outline, .text: return ColorTokens.primary
        }
    }
    
    private var borderColor: Color {
        style == .outline ? ColorTokens.primary : .clear
    }
}

#Preview("Primary") {
    VStack(spacing: 16) {
        RMButton(title: "Primary Button", style: .primary) {}
        RMButton(title: "Secondary Button", style: .secondary) {}
        RMButton(title: "Outline Button", style: .outline) {}
        RMButton(title: "Text Button", style: .text) {}
        RMButton(title: "Loading", style: .primary, action: {}, isLoading: true)
        RMButton(title: "Disabled", style: .primary, action: {}, isDisabled: true)
    }
    .padding()
}
