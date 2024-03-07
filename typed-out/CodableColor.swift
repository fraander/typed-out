//
//  CodableColors.swift
//  typed-out
//
//  Created by Frank Anderson on 3/7/24.
//

import Foundation
import SwiftUI

#if os(iOS)
import UIKit
typealias PlatformColor = UIColor
extension Color: Codable {
    public init(from decoder: Decoder) throws {
        
        decoder.unkeyedContainer()
        
        decodeColor(from: <#T##Data#>)
    }
    
    public func encode(to encoder: Encoder) throws {
        <#code#>
    }
    
    
    
    
    init(platformColor: PlatformColor) {
        self.init(uiColor: platformColor)
    }
}
#elseif os(macOS)
import AppKit
typealias PlatformColor = NSColor
extension Color {
    init(platformColor: PlatformColor) {
        self.init(nsColor: platformColor)
    }
}
#endif

let color = Color(.sRGB, red: 0, green: 0, blue: 1, opacity: 1)

func encodeColor() throws -> Data {
    let platformColor = PlatformColor(color)
    return try NSKeyedArchiver.archivedData(
        withRootObject: platformColor,
        requiringSecureCoding: true
    )
}

func decodeColor(from data: Data) throws -> Color {
    guard let platformColor = try NSKeyedUnarchiver.unarchivedObject(ofClass: PlatformColor.self, from: data) else {
        throw DecodingError.wrongType
    }
    return Color(platformColor: platformColor)
}

enum DecodingError: Error {
    case wrongType
}
