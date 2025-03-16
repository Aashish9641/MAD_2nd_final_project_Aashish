import SwiftUI

struct AdminDashboardView: View {
    @ObservedObject private var dataManager = DataManager.shared
    @State private var showCreateLandlordView = false
    @State private var selectedLandlord: Landlord? = nil
    @State private var selectedLandlordsForDeletion: Set<UUID> = []
    
    // Custom Color Scheme
    private let primaryColor = Color(red: 0.11, green: 0.37, blue: 0.53) // Deep Blue
    private let secondaryColor = Color(red: 0.92, green: 0.94, blue: 0.96) // Light Gray
    private let accentColor = Color(red: 0.20, green: 0.60, blue: 0.86) // Sky Blue
    private let destructiveColor = Color(red: 0.86, green: 0.22, blue: 0.27) // Coral Red
    private let successColor = Color(red: 0.22, green: 0.65, blue: 0.53) // Teal Green
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Select All Button
                if !dataManager.landlords.isEmpty {
                    HStack {
                        Button(action: toggleSelectAll) {
                            HStack(spacing: 8) {
                                Image(systemName: selectedLandlordsForDeletion.count == dataManager.landlords.count ?
                                     "checkmark.circle.fill" : "circle")
                                    .font(.system(size: 18))
                                
                                Text(selectedLandlordsForDeletion.count == dataManager.landlords.count ?
                                     "Deselect All" : "Select All")
                                    .font(.subheadline)
                            }
                            .foregroundColor(selectedLandlordsForDeletion.isEmpty ? primaryColor : .primary)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 15)
                            .background(Color(.systemBackground))
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.05), radius: 2, y: 1)
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                    .background(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.05), radius: 2, y: 2)
                }
                
                // List of Landlords
                List {
                    ForEach(dataManager.landlords) { landlord in
                        LandlordRow(
                            landlord: landlord,
                            hasChoose: selectedLandlordsForDeletion.contains(landlord.id),
                            selecOn: { toggleSelection(for: landlord.id) },
                            modifyO: {
                                selectedLandlord = landlord
                                showCreateLandlordView = true
                            }
                        )
                        .listRowInsets(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
                        .listRowBackground(Color.clear)
                    }
                }
                .listStyle(PlainListStyle())
                .background(secondaryColor)
                
                // Delete Selected Button
                if !selectedLandlordsForDeletion.isEmpty {
                    Button(action: deleteSelectedLandlords) {
                        HStack {
                            Image(systemName: "trash")
                            Text("Delete Selected (\(selectedLandlordsForDeletion.count))")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(destructiveColor)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .shadow(color: destructiveColor.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .padding()
                }
                
                // Add Landlord Button
                Button(action: {
                    selectedLandlord = nil
                    showCreateLandlordView = true
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add Landlord")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(successColor)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .shadow(color: successColor.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .padding()
            }
            .background(secondaryColor.edgesIgnoringSafeArea(.all))
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
