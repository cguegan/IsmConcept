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
    
    /// Given Properties
    @State var user: User
    
    /// State Properties
    @State var navigation = NavigationManager()
    @State var visibility: NavigationSplitViewVisibility = .all
    
    /// Main Body
    var body: some View {
        NavigationSplitView(columnVisibility: $visibility) {
            SidebarView(user: user)
                .environment(navigation)
        } detail: {
            switch navigation.selectedModule {
                case .profile:
                    UserEditView(user: user)
                        .environment(UserStore())
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
