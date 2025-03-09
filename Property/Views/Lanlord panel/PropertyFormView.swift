//
//  PropertyFormView.swift
//  Property
//
//  Created by NAAMI COLLEGE on 07/03/2025.
//

import UIKit
import SwiftUI
struct PropertyFormView: View {
    @Binding var showPropertyForm: Bool
    @ObservedObject var dataManager: DataManager
    let landlord: Landlord
    @Binding var selectedProperty: Property?
    @Binding var showSuccessMessage: Bool
    @Binding var successMessage: String
    @Binding var showError: Bool
    @Binding var errorMessage: String
    
    @State private var address = ""
    @State private var description = ""
    @State private var price = ""
    
    var isEditing: Bool {
        selectedProperty != nil
    }
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Address", text: $address)
                TextField("Description", text: $description)
                TextField("Price", text: $price)
                    .keyboardType(.decimalPad)
                
                Button(action: saveProperty) {
                    Text(isEditing ? "Update Property" : "Add Property")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .navigationTitle(isEditing ? "Edit Property" : "Add Property")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        showPropertyForm = false
                    }
                }
            }
            .onAppear {
                if let property = selectedProperty {
                    address = property.address
                    description = property.description
                    price = String(property.price)
                }
            }
        }
    }
    
    func saveProperty() {
        guard !address.isEmpty, !description.isEmpty, let priceValue = Double(price) else {
            showError = true
            errorMessage = "All fields are required and price must be a valid number."
            return
        }
        
        if isEditing, let property = selectedProperty {
            let updatedProperty = Property(id: property.id, address: address, description: description, price: priceValue)
            dataManager.updateProperty(updatedProperty, for: landlord.id)
            successMessage = "Property updated successfully!"
        } else {
            let newProperty = Property(id: UUID().uuidString, address: address, description: description, price: priceValue)
            dataManager.addProperty(newProperty, for: landlord.id)
            successMessage = "Property added successfully!"
        }
        
        showPropertyForm = false
        showSuccessMessage = true
    }
}
