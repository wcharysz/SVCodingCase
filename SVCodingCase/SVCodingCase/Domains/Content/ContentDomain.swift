//
//  ContentDomain.swift
//  SVCodingCase
//
//  Created by Wojciech Charysz on 17.03.23.
//

import Foundation
import ComposableArchitecture
import OrderedCollections

struct ContentDomain: ReducerProtocol {
    
    struct State: Equatable {
        var rows: IdentifiedArrayOf<ContentModel> = []
        @BindingState var search = ""
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case loadData
        case reloadAllRows
        case reloadRows(OrderedSet<ContentModel>)
        case saveModel(SVData)
    }
    
    @Dependency(\.dataClient) var dataClient
    @Dependency(\.dataParser.parseData) var parser
    @Dependency(\.dataStore) var dataStore
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(\.$search):
                let searchedPhrase = state.search
                
                guard searchedPhrase != "" else {
                    return .task {
                        .reloadAllRows
                    }
                }

                return .run { send in
                    let result = try await dataStore.loadRecords(searchedPhrase)
                    
                    await send(.reloadRows(result))
                }
            case .binding:
                return .none
            case .loadData:
                return .run { send in
                    let data = try await dataClient.loadData()
                    let model = try parser(data)
                    await send(.saveModel(model))
                }
            case .reloadAllRows:
                return .run { send in
                    let rows = try await dataStore.loadAllRecords()
                    await send(.reloadRows(rows))
                }
            case .saveModel(let newModel):
                return .task {
                    try dataStore.saveRecords(newModel)
                    return .reloadAllRows
                }
            case .reloadRows(let newRows):
                state.rows = IdentifiedArrayOf(uniqueElements: newRows)
                
                return .none
            }
        }
    }
}
