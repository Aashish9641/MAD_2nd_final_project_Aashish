// Property.swift
import Foundation // foundation import
import SwiftUI // importing the swift UI

// Defining the struct of properties, ensurung to identify and codable patterns
struct Property: Identifiable, Codable {
    // lists of the properties of property struct
    let id: String // unique value for the property part
    let address: String // add address of the property
    let description: String // Description of the property
    let price: Double //initlize the price of property as well
    
    // adding the custom implementation with defaults values
    init(id: String = UUID().uuidString, address: String, description: String, price: Double) {
        self.id = id // make the new id if not given
        self.address = address // Assigning the provide address
        self.description = description // linking the proivided description
        self.price = price // adding the providing price action
    }
}
