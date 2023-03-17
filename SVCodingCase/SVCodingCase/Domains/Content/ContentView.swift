//
//  ContentView.swift
//  SVCodingCase
//
//  Created by Wojciech Charysz on 17.03.23.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    
    let store: StoreOf<ContentDomain>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text("Hello, world!")
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(store: Store(initialState: .init(), reducer: ContentDomain()))
    }
}
