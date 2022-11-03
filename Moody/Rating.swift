//
//  Rating.swift
//  Moody
//
//  Created by Josh Smith on 11/2/22.
//

import SwiftUI

extension Int {
    var color: Color {
        switch self {
        case 1:
            return .red
        case 2:
            return .orange
        case 3:
            return .yellow
        case 4:
            return .mint
        case 5:
            return .green
        default:
            return .clear
        }
    }
}

