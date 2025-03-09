import Foundation
import SwiftUI

class Landlord: Identifiable, Codable {
    var id: UUID
    var name: String
    var email: String
    var phone: String
    var properties: [String]
    
    init(id: UUID = UUID(), name: String, email: String, phone: String, properties: [String] = []) {
        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
        self.properties = properties
    }
}
