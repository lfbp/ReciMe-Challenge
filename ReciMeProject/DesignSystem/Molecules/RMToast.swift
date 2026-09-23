//
//  RMToast.swift
//  ReciMeProject
//
//  Created by Luis Pereira on 22/09/26.
//

import SwiftUI

struct RMToast: View {
    let message: String
    let type: ToastType
    let onDismiss: () -> Void
    
    enum ToastType {
        case success
        case warning
        case error
        case info
        
        var icon: String {
            switch self {
            case .success: return "checkmark.circle.fill"
            case .warning: return "exclamationmark.triangle.fill"
            case .error: return "xmark.circle.fill"
            case .info: return "info.circle.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .success: return ColorTokens.success
            case .warning: return ColorTokens.warning
            case .error: return ColorTokens.error
            case .info: return ColorTokens.info
            }
        }
    }
    
    var body: some View {
        HStack(spacing: SpacingTokens.md) {
            Image(systemName: type.icon)
                .font(.system(size: 24))
                .foregroundColor(.white)
            
            Text(message)
                .font(TypographyTokens.body)
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
            
            Spacer()
            
            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white.opacity(0.8))
            }
        }
        .padding(SpacingTokens.md)
        .background(type.color)
        .cornerRadius(12)
        .shadow(radius: 8)
        .padding(.horizontal, SpacingTokens.md)
    }
}

#Preview {
    VStack(spacing: 20) {
        RMToast(message: "Success!", type: .success, onDismiss: {})
        RMToast(message: "Warning message", type: .warning, onDismiss: {})
        RMToast(message: "Error occurred", type: .error, onDismiss: {})
    }
}
