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
            NavigationStack {
                VStack {
                    List {
                        ForEach(viewStore.rows) { row in
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("Lock name: ")
                                    Text(row.name)
                                }.padding()
                                
                                HStack {
                                    Text("Building:")
                                    Text(row.buildingDesription)
                                    
                                    Text("-")
                                    Text(row.floorDescription)
                                    Text("-")
                                    
                                    Text(row.roomNumber)
                                }.padding()
                            }
                        }
                    }.animation(.easeInOut, value: viewStore.rows)
                     .refreshable {
                            viewStore.send(.loadData)
                      }
                }
            }.searchable(text: viewStore.binding(\.$search), prompt: "Search for locks")
             .onAppear {
                viewStore.send(.loadData)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(store: Store(initialState: .init(), reducer: ContentDomain()))
    }
}
