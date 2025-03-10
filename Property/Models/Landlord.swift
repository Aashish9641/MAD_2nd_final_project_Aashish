import Foundation // imporintg the foundation
import SwiftUI // Importing swift UI

// Defining the landlord class and ensure that identofiable and codable protocols
class Landlord: Identifiable, Codable {
    // different properties of the landlord class
    var id: UUID // id plays as unique identifier for landlord
    var name: String // Name of the landlord
    var email: String // Assigned email of the landlord
    var phone: String // adding phone number of landlord
    var properties: [String] // list out the property id linked with each landlord
    
    // defining the custom identifierwith defaults value
    init(id: UUID = UUID(), name: String, email: String, phone: String, properties: [String] = []) {
        self.id = id // generate new Id if the mentioned
        self.name = name // initlized the provided name
        self.email = email // add the provided email
        self.phone = phone // Assign provided phone number
        self.properties = properties // linking the necessary list of the property ID or array if not mentioned
    }
}
