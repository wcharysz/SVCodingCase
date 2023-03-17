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
                return .none
            }
        }
    }
}
