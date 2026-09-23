//
//  ColorTokens.swift
//  ReciMeProject
//
//  Created by Luis Pereira on 22/09/26.
//

import SwiftUI

enum ColorTokens {
    // Primary Colors (Warm & Appetizing)
    static let primary = Color(red: 1.0, green: 0.42, blue: 0.21)           // #FF6B35 - Coral Orange
    static let primaryDark = Color(red: 0.90, green: 0.35, blue: 0.17)      // #E55A2B
    static let primaryLight = Color(red: 1.0, green: 0.55, blue: 0.37)      // #FF8C5F
    
    // Secondary Colors (Fresh & Natural)
    static let secondary = Color(red: 0.30, green: 0.69, blue: 0.31)        // #4CAF50 - Fresh Green
    static let secondaryDark = Color(red: 0.22, green: 0.56, blue: 0.24)    // #388E3C
    static let secondaryLight = Color(red: 0.40, green: 0.73, blue: 0.42)   // #66BB6A
    
    // Accent Colors
    static let accent = Color(red: 1.0, green: 0.76, blue: 0.03)            // #FFC107 - Golden Yellow
    static let accentRed = Color(red: 0.96, green: 0.26, blue: 0.21)        // #F44336 - Tomato Red
    
    // Neutral Colors
    static let background = Color(red: 0.98, green: 0.98, blue: 0.98)       // #FAFAFA - Off White
    static let surface = Color.white                                         // #FFFFFF - Pure White
    static let surfaceDark = Color(red: 0.96, green: 0.96, blue: 0.96)      // #F5F5F5 - Light Gray
    
    // Text Colors
    static let textPrimary = Color(red: 0.13, green: 0.13, blue: 0.13)      // #212121 - Almost Black
    static let textSecondary = Color(red: 0.46, green: 0.46, blue: 0.46)    // #757575 - Medium Gray
    static let textTertiary = Color(red: 0.74, green: 0.74, blue: 0.74)     // #BDBDBD - Light Gray
    
    // Semantic Colors
    static let success = Color(red: 0.30, green: 0.69, blue: 0.31)          // #4CAF50
    static let warning = Color(red: 1.0, green: 0.60, blue: 0.0)            // #FF9800
    static let error = Color(red: 0.96, green: 0.26, blue: 0.21)            // #F44336
    static let info = Color(red: 0.13, green: 0.59, blue: 0.95)             // #2196F3
    
    // Border & Divider
    static let border = Color(red: 0.88, green: 0.88, blue: 0.88)           // #E0E0E0
    static let divider = Color(red: 0.93, green: 0.93, blue: 0.93)          // #EEEEEE
    
    // Dietary Attribute Colors
    static let vegetarianColor = Color(red: 0.55, green: 0.76, blue: 0.29)  // #8BC34A - Light Green
    static let veganColor = Color(red: 0.40, green: 0.73, blue: 0.42)       // #66BB6A - Green
    static let glutenFreeColor = Color(red: 1.0, green: 0.76, blue: 0.03)   // #FFC107 - Amber
    static let ketoColor = Color(red: 1.0, green: 0.34, blue: 0.13)         // #FF5722 - Deep Orange
    static let organicColor = Color(red: 0.61, green: 0.15, blue: 0.69)     // #9C27B0 - Purple
    static let halalColor = Color(red: 0.0, green: 0.74, blue: 0.83)        // #00BCD4 - Cyan
    static let kosherColor = Color(red: 0.25, green: 0.32, blue: 0.71)      // #3F51B5 - Indigo
}
