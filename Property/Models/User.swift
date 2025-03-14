import Foundation
import SwiftUI

// Defination  the User structure, conforming to Identifiable and Codable protocols
struct User: Identifiable, Codable {
    // Properties of the User partd
    let id: String // make it unique identifier for the user
    let name: String // Name of the user
    let email: String // Email of the user
    let password: String // Password of the user
    
    // Custom Declaring  with default values
    init(id: String = UUID().uuidString, name: String, email: String, password: String) {
        self.id = id // setting ng  the provided ID or generate a new UUID if not provided
        self.name = name // Adding   the provided name
        self.email = email // assign the provided email
        self.password = password // add the provided password
    }
    
}
