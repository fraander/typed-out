//
//  ToolbarView.swift
//  typed-out
//
//  Created by Frank Anderson on 2/27/24.
//

import SwiftUI

struct TypedOutButton: View {
    
    let tintColor: Color
    let title: LocalizedStringKey
    let icon: String
    let action: (() -> Void)
    
    init(_ title: LocalizedStringKey, icon: String, tintColor: Color = Color.secondary, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.action = action
        self.tintColor = tintColor
    }
    
    var body: some View {
        Button(title, systemImage: icon, action: action)
            .font(.system(.body, design: .monospaced, weight: .bold))
            .buttonStyle(.bordered)
            .tint(tintColor)
    }
    
}
