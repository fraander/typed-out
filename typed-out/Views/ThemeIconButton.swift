//
//  ThemeIconButton.swift
//  typed-out
//
//  Created by Frank Anderson on 3/8/24.
//

import SwiftUI

struct ThemeIconButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct ThemeIconButton: View {
    let action: () -> Void
    let textColor: Color
    let backgroundColor: Color
    let outlineColor: Color
    let icon: String
    let buttonSize: Double
    let iconSize: Double
    let isSelected: Bool
    let namespaceID: Namespace.ID?
    
    init(
        theme: Theme,
        isSelected: Bool = false,
        namespaceID: Namespace.ID? = nil,
        action: @escaping () -> Void = {}
    ) {
        self.init(
            action: action,
            textColor: Color(cgColor: theme.textColor.cgColor),
            backgroundColor: Color(cgColor: theme.backgroundColor.cgColor),
            isSelected: isSelected,
            namespaceID: namespaceID
        )
    }
    
    init(
        action: @escaping () -> Void = {},
        textColor: Color,
        backgroundColor: Color,
        outlineColor: Color = Color.white,
        icon: String = "swirl.circle.righthalf.filled.inverse",
        iconSize: Double = 1, // 0 -> 1
        buttonSize: Double = 32,
        isSelected: Bool = false,
        namespaceID: Namespace.ID? = nil,
    ) {
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.outlineColor = outlineColor
        self.icon = icon
        self.action = action
        self.buttonSize = buttonSize
        self.iconSize = iconSize
        self.isSelected = isSelected
        self.namespaceID = namespaceID
    }
    
    var overlayCircle: some View {
        Circle()
            .fill(.clear)
            .stroke(.accent, lineWidth: 2)
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            ZStack {
                Image(systemName: "circle.fill")
                    .foregroundColor(backgroundColor)
                    .shadow(color: .black.opacity(0.5), radius: 2, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 2)
                    .symbolEffectsRemoved()

                Image(systemName: icon)
                    .foregroundStyle(textColor)
                    .font(.system(size: buttonSize * iconSize))
                Image(systemName: "circle")
                    .foregroundColor(outlineColor)
                    .symbolEffectsRemoved()
            }
            .font(.system(size: 32))
        }
        .buttonStyle(ThemeIconButtonStyle())
        #if os(iOS)
        .contentShape(.contextMenuPreview, .circle)
        #endif
        .overlay {
            if isSelected {
                if let nid = namespaceID {
                    overlayCircle
                        .matchedGeometryEffect(id: "selected-theme", in: nid) // Value of optional type 'Namespace.ID?' must be unwrapped to a value of type 'Namespace.ID'
                } else {
                    overlayCircle
                }
            }
        }
    }
}

#Preview {
    
    @Previewable @State var selectedIndex = 0
    
    HStack {
        ForEach(0..<5) { index in
            ThemeIconButton(
                theme: .init(
                    textColor: .black,
                    backgroundColor: .white
                ),
                isSelected: selectedIndex == index,
                action: {
                    withAnimation(.default.speed(0.1)) {
                        selectedIndex = index
                    }
                }
            )
        }
    }
}
