//
//  RMTextField.swift
//  ReciMeProject
//
//  Created by Luis Pereira on 22/09/26.
//

import SwiftUI

struct RMTextField: View {
    let placeholder: String
    @Binding var text: String
    var icon: String?
    var errorMessage: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTokens.xs) {
            HStack(spacing: SpacingTokens.sm) {
                if let icon = icon {
                    Image(systemName: icon)
                        .foregroundColor(ColorTokens.textSecondary)
                }
                
                TextField(placeholder, text: $text)
                    .font(TypographyTokens.body)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            }
            .padding(SpacingTokens.md)
            .background(ColorTokens.surface)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(errorMessage != nil ? ColorTokens.error : ColorTokens.border, lineWidth: 1)
            )
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .font(TypographyTokens.caption)
                    .foregroundColor(ColorTokens.error)
            }
        }
    }
}

struct RMSecureField: View {
    let placeholder: String
    @Binding var text: String
    var icon: String?
    var errorMessage: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTokens.xs) {
            HStack(spacing: SpacingTokens.sm) {
                if let icon = icon {
                    Image(systemName: icon)
                        .foregroundColor(ColorTokens.textSecondary)
                }
                
                SecureField(placeholder, text: $text)
                    .font(TypographyTokens.body)
            }
            .padding(SpacingTokens.md)
            .background(ColorTokens.surface)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(errorMessage != nil ? ColorTokens.error : ColorTokens.border, lineWidth: 1)
            )
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .font(TypographyTokens.caption)
                    .foregroundColor(ColorTokens.error)
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        RMTextField(placeholder: "Username", text: .constant(""), icon: "person")
        RMSecureField(placeholder: "Password", text: .constant(""), icon: "lock")
        RMTextField(placeholder: "Email", text: .constant("test"), icon: "envelope", errorMessage: "Invalid email")
    }
    .padding()
}
