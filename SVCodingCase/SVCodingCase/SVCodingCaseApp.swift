//
//  SVCodingCaseApp.swift
//  SVCodingCase
//
//  Created by Wojciech Charysz on 17.03.23.
//

import SwiftUI
import ComposableArchitecture

@main
struct SVCodingCaseApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(store: Store(initialState: .init(), reducer: ContentDomain()))
        }
    }
}
