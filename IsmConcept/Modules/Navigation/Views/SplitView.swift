//
//  SplitView.swift
//  IsmConcept
//
//  Created by Christophe Guégan on 07/03/2025.
//

import SwiftUI

struct SplitView: View {
    
    /// Environment Properties
    @Environment(PreferencesManager.self) var preferences
    
    /// State Properties
    @State var navigation = NavigationManager()
    @State var visibility: NavigationSplitViewVisibility = .all
    
    var user: User
    
    /// Main Body
    var body: some View {
        NavigationSplitView(columnVisibility: $visibility) {
            SidebarView()
                .environment(navigation)

        } detail: {
            switch navigation.selectedModule {
//                case .profile:
//                    UserEditView(user: AuthService.shared.user)
                case .home:
                    CompanyView()
//                case .checklists(let department):
//                    ChecklistsView(department: department)
//                        .environment(checklistsStore)
                case .safetyChecks:
                    UnderConstructionView()
                case .vessels:
                   VesselsListView()
                case .users:
                    UsersListView()
                default:
                    UnderConstructionView()
                }
        }
        .navigationSplitViewStyle(.balanced)
    }
}


// MARK: - Preview
// ———————————————

#Preview {
    SplitView(user: User.samples[0])
        .environment(PreferencesManager())
}
