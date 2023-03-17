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
    
    enum DataStoreErrors: Error {
        case noFile
    }
}

extension DataClient {
    static let mock = DataClient {
        guard let fileURL = Bundle.main.url(forResource: "sv_lsm_data", withExtension: "json") else {
            throw DataStoreErrors.noFile
        }
        
        let file = try Data(contentsOf: fileURL)
        
        return file
    }
    
    static let live = DataClient {
        
        //TODO: Replace it with an actual call to the backend
        try await Task.sleep(for: .seconds(2))
        
        guard let fileURL = Bundle.main.url(forResource: "sv_lsm_data", withExtension: "json") else {
            throw DataStoreErrors.noFile
        }
        
        let file = try Data(contentsOf: fileURL)
        
        return file
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

