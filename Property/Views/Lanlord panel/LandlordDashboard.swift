import SwiftUI

@available(iOS 15.0, *)
struct LandlordDashboard: View {
    @ObservedObject private var dataManager = DataManager.shared
    let landlord: Landlord
    
    @State private var showPropertyForm = false
    @State private var selectedProperty: Property? = nil
    @State private var showSuccessMessage = false
    @State private var successMessage = ""
    @State private var showError = false
    @State private var errorMessage = ""
    
    @State private var selectedProperties: Set<String> = [] // Track selected properties
    @State private var isSelectModeActive = false // Toggle select mode
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("My Properties")
                    .font(.title2.bold())
                    .foregroundColor(.white)
                
                Spacer()
                
                // Add Property Button
                Button(action: {
                    selectedProperty = nil
                    showPropertyForm = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title)
                        .foregroundColor(.white)
                }
                
                // Select/Deselect Button
                Button(action: {
                    isSelectModeActive.toggle()
                    if !isSelectModeActive {
                        selectedProperties.removeAll() // Deselect all when exiting select mode
                    }
                }) {
                    Text(isSelectModeActive ? "Cancel" : "Select")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                .padding(.leading, 10)
            }
            .padding()
            .background(Color.blue)
            
            // Select All/Deselect All Buttons (Visible in Select Mode)
            if isSelectModeActive {
                HStack {
                    Button(action: {
                        if selectedProperties.count == dataManager.getProperties(for: landlord.id).count {
                            selectedProperties.removeAll() // Deselect all
                        } else {
                            // Select all
                            selectedProperties = Set(dataManager.getProperties(for: landlord.id).map { $0.id })
                        }
                    }) {
                        Text(selectedProperties.count == dataManager.getProperties(for: landlord.id).count ? "Deselect All" : "Select All")
                            .font(.subheadline.bold())
                            .foregroundColor(.blue)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(Color(.systemBackground))
                            .cornerRadius(8)
                    }
                    
                    Spacer()
                    
                    if !selectedProperties.isEmpty {
                        Button(action: {
                            // Delete selected properties
                            for propertyId in selectedProperties {
                                dataManager.deleteProperty(propertyId, for: landlord.id)
                            }
                            selectedProperties.removeAll()
                            successMessage = "Properties deleted successfully!"
                            showSuccessMessage = true
                        }) {
                            Text("Delete Selected")
                                .font(.subheadline.bold())
                                .foregroundColor(.red)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .background(Color(.systemBackground))
                                .cornerRadius(8)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color(.systemGray6))
            }
            
            // Property List
            List {
                ForEach(dataManager.getProperties(for: landlord.id), id: \.id) { property in
                    PropertyCard(
                        property: property,
                        isSelected: selectedProperties.contains(property.id),
                        isSelectModeActive: isSelectModeActive,
                        onUpdate: {
                            selectedProperty = property
                            showPropertyForm = true
                        },
                        onDelete: {
                            dataManager.deleteProperty(property.id, for: landlord.id)
                            successMessage = "Property deleted successfully!"
                            showSuccessMessage = true
                        },
                        onSelect: {
                            if selectedProperties.contains(property.id) {
                                selectedProperties.remove(property.id)
                            } else {
                                selectedProperties.insert(property.id)
                            }
                        }
                    )
                    .listRowInsets(EdgeInsets())
                    .padding(.vertical, 8)
                    .padding(.horizontal)
                }
            }
            .listStyle(.plain)
            .refreshable {
                dataManager.objectWillChange.send()
            }
        }
        .sheet(isPresented: $showPropertyForm) {
            PropertyFormView(
                showPropertyForm: $showPropertyForm,
                dataManager: dataManager,
                landlord: landlord,
                selectedProperty: $selectedProperty,
                showSuccessMessage: $showSuccessMessage,
                successMessage: $successMessage,
                showError: $showError,
                errorMessage: $errorMessage
            )
        }
        .alert(isPresented: $showError) {
            Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
        .overlay(
            Group {
                if showSuccessMessage {
                    Text(successMessage)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .transition(.opacity)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                showSuccessMessage = false
                            }
                        }
                }
            }, alignment: .top
        )
    }
}




struct PropertyCard: View {
    let property: Property
    let isSelected: Bool
    let isSelectModeActive: Bool
    let onUpdate: () -> Void
    let onDelete: () -> Void
    let onSelect: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            // Selection Checkbox (Visible in Select Mode)
            if isSelectModeActive {
                Button(action: onSelect) {
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .font(.title2)
                        .foregroundColor(isSelected ? .blue : .gray)
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            // Property Details
            VStack(alignment: .leading, spacing: 8) {
                Text(property.address)
                    .font(.headline)
                
                Text(property.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text("$\(property.price, specifier: "%.2f")/month")
                    .font(.subheadline.bold())
                    .foregroundColor(.green)
            }
            
            Spacer()
            
            // Action Buttons (Visible when not in Select Mode)
            if !isSelectModeActive {
                VStack(spacing: 8) {
                    // Update Button
                    Button(action: onUpdate) {
                        Text("Update")
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    // Delete Button
                    Button(action: onDelete) {
                        Text("Delete")
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .contentShape(Rectangle())
    }
}
