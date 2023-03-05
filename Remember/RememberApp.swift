//
//  RememberApp.swift
//  Remember
//
//  Created by Clayton Vanfleet on 2/22/23.
//

import SwiftUI

@main
struct RememberApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
