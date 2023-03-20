//
//  ContentDomain.swift
//  SVCodingCase
//
//  Created by Wojciech Charysz on 17.03.23.
//

import Foundation
import ComposableArchitecture

struct ContentDomain: ReducerProtocol {
    
    struct State: Equatable {
        var model: SVData?
        var rows: IdentifiedArrayOf<Lock> = []
        @BindingState var search = ""
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case loadData
        case reloadModel(SVData)
    }
    
    @Dependency(\.dataClient) var dataClient
    @Dependency(\.dataParser.parseData) var parser
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(\.$search):
                let searchedPhrase = state.search
                
                guard let model = state.model else {
                    return .none
                }
                
                guard searchedPhrase != "" else {
                    state.rows = IdentifiedArrayOf(uniqueElements: model.locks)
                    return .none
                }
                        
                let locks = model.locks.filter({ lock in
                    lock.allFields.contains { string in
                        string.range(of: searchedPhrase, options: .caseInsensitive) != nil
                    }
                })
                
                state.rows = IdentifiedArrayOf(uniqueElements: locks)
                
                return .none
            case .binding:
                return .none
            case .loadData:
                return .run { send in
                    let data = try await dataClient.loadData()
                    let model = try parser(data)
                    await send(.reloadModel(model))
                }
            case .reloadModel(let newModel):
                state.model = newModel
                state.rows = IdentifiedArrayOf(uniqueElements: newModel.locks)
                return .none
            }
        }
    }
}
