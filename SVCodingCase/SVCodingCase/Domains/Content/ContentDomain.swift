//
//  ContentDomain.swift
//  SVCodingCase
//
//  Created by Wojciech Charysz on 17.03.23.
//

import Foundation
import ComposableArchitecture

struct ContentDomain: ReducerProtocol {
    
    struct State: Equatable, Hashable {
        @BindingState var search = ""
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case loadData
    }
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .loadData:
                return .none
            }
        }
    }
}
