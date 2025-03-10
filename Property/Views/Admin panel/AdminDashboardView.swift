import SwiftUI

struct AdminDashboardView: View {
    @ObservedObject private var dataManager = DataManager.shared
    @State private var showCreateLandlordView = false
    @State private var selectedLandlord: Landlord? = nil
    @State private var selectedLandlordsForDeletion: Set<UUID> = []
    
    var body: some View {
        NavigationView {
            VStack {
                // Select All Button
                if !dataManager.landlords.isEmpty {
                    HStack {
                        Button(action: toggleSelectAll) {
                            Text(selectedLandlordsForDeletion.count == dataManager.landlords.count ? "Deselect All" : "Select All")
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .background(Color.blue)
                                .cornerRadius(8)
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                }
                
                // List of Landlords
                List {
                    ForEach(dataManager.landlords) { landlord in
                        LandlordRow(
                            landlord: landlord,
                            isSelected: selectedLandlordsForDeletion.contains(landlord.id),
                            onSelect: { toggleSelection(for: landlord.id) },
                            onUpdate: {
                                selectedLandlord = landlord
                                showCreateLandlordView = true
                            }
                        )
                    }
                }
                .listStyle(PlainListStyle())
                
                // Delete Selected Button
                if !selectedLandlordsForDeletion.isEmpty {
                    Button(action: deleteSelectedLandlords) {
                        Text("Delete Selected (\(selectedLandlordsForDeletion.count))")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                }
                
                // Add Landlord Button
                Button(action: {
                    selectedLandlord = nil
                    showCreateLandlordView = true
                }) {
                    Text("Add Landlord")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
            .navigationTitle("Admin Dashboard")
            .sheet(isPresented: $showCreateLandlordView, onDismiss: {
                selectedLandlord = nil
            }) {
                CreateLandlordView(
                    showCreateLandlordView: $showCreateLandlordView,
                    dataManager: dataManager,
                    landlordToEdit: $selectedLandlord
                )
            }
        }
    }
    
    // Toggle Select All
    func toggleSelectAll() {
        if selectedLandlordsForDeletion.count == dataManager.landlords.count {
            selectedLandlordsForDeletion.removeAll()
        } else {
            selectedLandlordsForDeletion = Set(dataManager.landlords.map { $0.id })
        }
    }
    
    // Toggle Selection for a Single Landlord
    func toggleSelection(for id: UUID) {
        if selectedLandlordsForDeletion.contains(id) {
            selectedLandlordsForDeletion.remove(id)
        } else {
            selectedLandlordsForDeletion.insert(id)
        }
    }
    
    // Delete Selected Landlords
    func deleteSelectedLandlords() {
        for id in selectedLandlordsForDeletion {
            dataManager.lordRemove(id: id)
        }
        selectedLandlordsForDeletion.removeAll()
    }
}
