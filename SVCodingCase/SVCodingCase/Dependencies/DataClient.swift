//
//  DataClient.swift
//  SVCodingCase
//
//  Created by Wojciech Charysz on 17.03.23.
//

import Foundation
import ComposableArchitecture

struct DataClient {
    var loadData: () async throws -> Data
    
    enum DataClientErrors: Error {
        case noFile
        case wrongURL
    }
}

extension DataClient {
    static let mock = DataClient {
        guard let fileURL = Bundle.main.url(forResource: "sv_lsm_data", withExtension: "json") else {
            throw DataClientErrors.noFile
        }
        
        let file = try Data(contentsOf: fileURL)
        
        return file
    }
    
    static let live = DataClient {
        guard let url = URL(string: "https://dev.homework.system3060.com/sv_lsm_data.json") else {
            throw DataClientErrors.wrongURL
        }
        let reply = try await URLSession.shared.data(from: url)
        
        return reply.0
    }
}

extension DataClient: DependencyKey {
    static var liveValue = DataClient.live
    static var previewValue = DataClient.mock
    static var testValue = DataClient.mock
}
 

extension DependencyValues {
    var dataClient: DataClient {
        get {
            self[DataClient.self]
        }
        
        set {
            self[DataClient.self] = newValue
        }
    }
}

