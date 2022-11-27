//
//  Mood.swift
//  Moody
//
//  Created by Josh Smith on 11/2/22.
//

import SwiftUI

extension Mood {
    
    var rating: Int {
        get {
            return Int(self.number)
        } set {
            self.number = Double(newValue)
        }
    }
    
    var notes: String {
        get {
            return self.notesValue ?? ""
        } set {
            self.notesValue = newValue
        }
    }
    
    var dateAdded: Date {
        get {
            return self.dateAddedValue ?? .now
        } set {
            self.dateAddedValue = newValue
        }
    }
    
    var date: Date {
        get {
            return self.dateValue ?? .now
        } set {
            self.dateValue = newValue
        }
    }
    
    var color: Color {
        switch rating {
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
