//
//  Item.swift
//  redLightGreenLight
//
//  Created by Nick Porrazzo on 3/23/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
