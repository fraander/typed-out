//
//  ContentView.swift
//  typed-out
//
//  Created by Frank Anderson on 7/24/22.
//

import SwiftUI

struct ContentView: View {
    
    // TODO: feature-plan
    /**  1. Start up Git repo with a better name
         2. Half sheet to adjust settings and toggle save-mode
         3. When keyboard is down, turn off text field and turn on Text view
         4. Quick responses
         5. Preset phrases to quick-access
         6. Color customization/themes
         7. Persistence for save mode and saved view in the settings half-sheet
     */
    
    @State var text = ""
    @State var size = 24.0
    @FocusState var keyboardUp: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                if text.isEmpty {
                    Spacer()
                }
                
                ScrollView {
                        TextField("Type here ...", text: $text, axis: .vertical)
                            .font(.system(size: size))
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                            .focused($keyboardUp)
                }
                
                if text.isEmpty {
                    Spacer()
                }
                
                Slider(value: $size, in: 12...144)
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
//                    if keyboardUp {
                        Button {
                            keyboardUp = false
                        } label: {
                            Label("Done", systemImage: "keyboard.chevron.compact.down")
                                .labelStyle(.titleAndIcon)
                        }
//                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
//                    if !text.isEmpty {
                        Button {
                            text = ""
                        } label: {
                            Label("Clear", systemImage: "trash")
                                .labelStyle(.titleAndIcon)
                        }
//                    }
                    
                }
            }
            .task {
                keyboardUp = true
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
