// Property.swift
import Foundation
import SwiftUI

struct Property: Identifiable, Codable {
    let id: String
    let address: String
    let description: String
    let price: Double
    
    init(id: String = UUID().uuidString, address: String, description: String, price: Double) {
        self.id = id
        self.address = address
        self.description = description
        self.price = price
    }
}
