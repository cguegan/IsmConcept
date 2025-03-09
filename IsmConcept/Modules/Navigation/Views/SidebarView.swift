//
//  SidebarView.swift
//  IsmConcept
//
//  Created by Christophe Guégan on 07/03/2025.
//

import SwiftUI

struct SidebarView: View {
    
    /// Environment Properties
    @Environment(NavigationManager.self)  var navigation
    @Environment(PreferencesManager.self) var preferences

    /// AppStorage for expanded sections of the sidebar
    @AppStorage("is_expanded_checklists") var isExpandedChecklists: Bool = false
    @AppStorage("is_expanded_forms")      var isExpandedForms: Bool = false
    @AppStorage("is_expanded_ism")        var isExpandedIsm: Bool = false
    @AppStorage("is_expanded_admin")      var isExpandedAdmin: Bool = false
    
    /// Given properties
    let user: User

    /// State properties
    @State private var showAddChecklist = false

    /// Main Body
    var body: some View {
        @Bindable var navigation = navigation

        /// Sidebar list
        List(selection: $navigation.selectedModule) {
            
            /// User profile
            ///
            NavigationLink(value: Module.profile) {
                UserSideView(user: user)
            }
            Divider()
            
            /// Home screen
            ///
            NavigationLink(value: Module.home) {
                HStack {
                    Image("icon.corail")
                        .resizable()
                        .frame(width: 24, height: 24)
                    Text("Yachting Concept Monaco")
                }
            }
            
            /// Checklists section
            ///
            Section(isExpanded: $isExpandedChecklists) {
                let departments = navigation.getDepartmentsDict()
                ForEach(Array(departments.keys), id: \.self) { department in
                    NavigationLink(value: Module.checklists(department: department)) {
                        Label(department.description, systemImage: department.icon)
//                            .badge(departments[department] ?? 0)
                            .tag(department.rawValue)
                    }
                }
            } header: {
                Text("Checklists")
            }
            
            /// Safety Checks Section
            ///
            Section(isExpanded: $isExpandedForms) {
                NavigationLink(value: Module.safetyChecks) {
                    Label("Safety Checks", systemImage: "pencil.and.list.clipboard")
                }
            } header: {
                Text("Forms")
            }
            
            /// Is admin
            ///
            if user.role.rawValue < 10 {
                Section(isExpanded: $isExpandedAdmin) {
                    
                    NavigationLink(value: Module.vessels) {
                        Label("Manage Yachts", systemImage: "ferry")
                    }
                    
                    NavigationLink(value: Module.users) {
                        Label("Manage Users", systemImage: "person.2")
                    }
                    
                } header: {
                    Text("Admin")
                }
            }
        }
        .listStyle(.sidebar)
        .navigationTitle("ISM Concept")
    }
}


// MARK: - Preview
// ———————————————

#Preview {
    SidebarView(user: User.samples[0])
        .environment(NavigationManager())
        .environment(PreferencesManager())
}
