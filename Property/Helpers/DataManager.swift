import Foundation
import SwiftUI

class DataManager: ObservableObject {
    static let shared = DataManager()
    
    @Published var landlords: [Landlord] = []
    @Published var properties: [Property] = [] // Global list of properties
    
    private let landlordsKey = "landlords"
    private let propertiesKey = "properties"
    
    private init() {
        loadLandlords()
        loadProperties()
    }
    
    // MARK: - Data Persistence
    private func loadLandlords() {
        if let data = UserDefaults.standard.data(forKey: landlordsKey),
           let decoded = try? JSONDecoder().decode([Landlord].self, from: data) {
            landlords = decoded
        }
    }
    
    private func loadProperties() {
        if let data = UserDefaults.standard.data(forKey: propertiesKey),
           let decoded = try? JSONDecoder().decode([Property].self, from: data) {
            properties = decoded
        }
    }
    
    private func saveLandlords() {
        if let encoded = try? JSONEncoder().encode(landlords) {
            UserDefaults.standard.set(encoded, forKey: landlordsKey)
        }
    }
    
    private func saveProperties() {
        if let encoded = try? JSONEncoder().encode(properties) {
            UserDefaults.standard.set(encoded, forKey: propertiesKey)
        }
    }
    
    // MARK: - Landlord Operations
    func addLandlord(_ landlord: Landlord) {
        landlords.append(landlord)
        saveLandlords()
    }
    
    func updateLandlord(_ landlord: Landlord) {
        if let index = landlords.firstIndex(where: { $0.id == landlord.id }) {
            landlords[index] = landlord
            saveLandlords()
        }
    }
    
    func deleteLandlord(id: UUID) {
        landlords.removeAll { $0.id == id }
        saveLandlords()
    }
    
    func validateLandlord(username: String, email: String) -> Bool {
        landlords.contains { $0.name == username && $0.email == email }
    }
    
    func getLandlord(username: String, email: String) -> Landlord? {
        landlords.first { $0.name == username && $0.email == email }
    }
    
    // MARK: - Property Operations
    func addProperty(_ property: Property, for landlordID: UUID) {
        // Add property to the global list
        properties.append(property)
        saveProperties()
        
        // Add property ID to the landlord's properties list
        if let index = landlords.firstIndex(where: { $0.id == landlordID }) {
            landlords[index].properties.append(property.id)
            saveLandlords()
        }
    }
    
    func updateProperty(_ property: Property, for landlordID: UUID) {
        if let index = properties.firstIndex(where: { $0.id == property.id }) {
            properties[index] = property // Update the property in the global list
            saveProperties() // Save the updated list to UserDefaults
        }
    }

    func deleteProperty(_ propertyID: String, for landlordID: UUID) {
        // Remove property from the global list
        properties.removeAll { $0.id == propertyID }
        saveProperties()
        
        // Remove property ID from the landlord's properties list
        if let index = landlords.firstIndex(where: { $0.id == landlordID }) {
            landlords[index].properties.removeAll { $0 == propertyID }
            saveLandlords()
        }
    }
    
    func getProperties(for landlordID: UUID) -> [Property] {
        guard let landlord = landlords.first(where: { $0.id == landlordID }) else { return [] }
        
        // Fetch property details from the global list
        return landlord.properties.compactMap { propertyID in
            properties.first { $0.id == propertyID }
        }
    }
}
