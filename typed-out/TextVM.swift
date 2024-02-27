//
//  TextVM.swift
//  typed-out
//
//  Created by Frank Anderson on 7/24/22.
//

import SwiftUI

enum SheetType: Identifiable {
    var id: Self { self }
    
    case settings, saved
}

class TextVM: ObservableObject {
    @Published var text = ""
    @Published var sheet: SheetType?
    @Published var focus: Bool = false
}
