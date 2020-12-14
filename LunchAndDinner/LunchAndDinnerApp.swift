//
//  LunchAndDinnerApp.swift
//  LunchAndDinner
//
//  Created by 満尾希美 on 14/12/20.
//

import SwiftUI

@main
struct LunchAndDinnerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
