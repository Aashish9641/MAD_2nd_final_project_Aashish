import Foundation // Importing the foundation class
import SwiftUI // Importing swift

// This is database class to manage or handle  landlords and properties
class DataManager: ObservableObject {
    
    static let shared = DataManager() // using instance of data manager
    
    // adding the published properties to notify when make changes
    @Published var landlords: [Landlord] = [] // lists of the landlords
    @Published var properties: [Property] = [] //  lists of properties using global
    
    private let KeyLord = "landlords" // using key for landlord information
    private let KeyProp = "properties" // using key for properties information
    
    // using private initilizer to follow skeleton pattern
    private init() {
        landLoad() // loading lanlord information from userdefault
        propLoad() // 	load properties daya from userdefault
    }
    
// begin landlord data from dafault user
    private func landLoad() {
        if let data = UserDefaults.standard.data(forKey: KeyLord),// follow retriving data for landlord parts
           let decoded = try? JSONDecoder().decode([Landlord].self, from: data) { // decoding data to landlord panel
            landlords = decoded // Assigned data decode to the arry of landlord
        }
    }
    // loading the properties from user default side
    private func propLoad() {
        if let data = UserDefaults.standard.data(forKey: KeyProp),// follow retriving data for properties part
           let decoded = try? JSONDecoder().decode([Property].self, from: data) { // using decoding data to properties panel
            properties = decoded // Assigning the decode data to properties section
        }
    }
    
    private func landSaver() { // Saving the landlord data to user defaults side
        if let encoded = try? JSONEncoder().encode(landlords) { // encoding array landlord to dataset
            
            UserDefaults.standard.set(encoded, forKey: KeyLord)// saving the encode data to user default side
        }
    }
    // Saving all the properties to user by fault
    private func PropSaver() {
        if let encoded = try? JSONEncoder().encode(properties) { // using encode way to property array to datasets
            UserDefaults.standard.set(encoded, forKey: KeyProp) // Save encoded data to dafault user
        }
    }
    
    // Performing the necessary landlord operation
    func lordAdd(_ landlord: Landlord) { //query to add the new landlord
        landlords.append(landlord) // in landlord array append new landlord
        landSaver() // make save the update landlord array to default user
    }
    //Updating the exisinng lanlord query
    func lordUpdate(_ landlord: Landlord) {
        if let index = landlords.firstIndex(where: { $0.id == landlord.id }) { //looking for index to update the landlord
            landlords[index] = landlord // with the help of index update the landlord
            landSaver() // saving the updated landlord to user defaults
        }
    }
    // Delete lanlord operation by ID
    func lordRemove(id: UUID) {
        // if the id matche	then delete
        landlords.removeAll { $0.id == id }
        landSaver() // Saving the updated part in array
    }
    // verifying the landlords credentials using email and username
    func lordValidation(username: String, email: String) -> Bool {
        landlords.contains { $0.name == username && $0.email == email } // verify if the landlord exists or not added by admin
    }
    // getting landlord function by username and email added by admin
    func lordGet(username: String, email: String) -> Landlord? {
        landlords.first { $0.name == username && $0.email == email } // Retruning the first landlord with matched username and email
    }
    
    // managing the required properties operation here
    func propPlus(_ property: Property, for landlordID: UUID) {// adding the new property by landlord operation
        
        properties.append(property)// adding  the necessary  properties to the global list properties
        PropSaver() // Saving the updated properties added by landlord to userdefaults
        
        // listing the  property ID to the list of the landlord property
        if let index = landlords.firstIndex(where: { $0.id == landlordID }) {
            landlords[index].properties.append(property.id)// verify append property id to the list of property in landlord side
            landSaver() // Saving the updated landlord array
        }
    }
    // Query to update the existing propert by landlord
    func propModify(_ property: Property, for landlordID: UUID) {
        if let index = properties.firstIndex(where: { $0.id == property.id }) {
            properties[index] = property // Update the property in the global list
            PropSaver() // Save the updated list to UserDefaults
        }
    }

    func propRemove(_ propertyID: String, for landlordID: UUID) {
        // Remove property from the global list
        properties.removeAll { $0.id == propertyID } // Delete the property from gloabal list as well
        PropSaver() // saved the modified properties to default user
        
        // delete  property ID from the landlords properties list
        if let index = landlords.firstIndex(where: { $0.id == landlordID }) {
            landlords[index].properties.removeAll { $0 == propertyID }// find index of landlord
            landSaver() // Save the latest landlord to user defaults
        }
    }
    
    // Fetching the properties to a particular landlord
    func propG(for landlordID: UUID) -> [Property] {
        guard let landlord = landlords.first(where: { $0.id == landlordID }) else { return [] } // finding the landlord as per ID
        
        // Get property data from the global list side
        return landlord.properties.compactMap { propertyID in // mapping the prop ids to object of properties
            properties.first { $0.id == propertyID } //Returung property object to every id
        }
    }
}
