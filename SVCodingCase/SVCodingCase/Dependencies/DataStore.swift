//
//  DataStore.swift
//  SVCodingCase
//
//  Created by Wojciech Charysz on 20.03.23.
//

import Foundation
import ComposableArchitecture
import OrderedCollections

struct DataStore {
    let saveRecords: (_ records: SVData) throws -> Void
    let loadRecords: (_ searched: String) async throws -> OrderedSet<ContentModel>
    let loadAllRecords: () async throws -> OrderedSet<ContentModel>
}

extension DataStore {
    static let live = DataStore { records in
        try SQLiteStore.shared.saveRecords(records)
    } loadRecords: { searched in
        let result = try await SQLiteStore.shared.loadRecords(searched).map({ record in
            ContentModel(record)
        })
        
        return OrderedSet(result)
    } loadAllRecords: {
        let result = try await SQLiteStore.shared.loadAllRecords().map({ record in
            ContentModel(record)
        })
        
        return OrderedSet(result)
    }
}

extension DataStore: DependencyKey {
    static var liveValue = DataStore.live
    static var previewValue = DataStore.live
    static var testValue = DataStore.live
}

extension DependencyValues {
    var dataStore: DataStore {
        get {
            self[DataStore.self]
        }
        
        set {
            self[DataStore.self] = newValue
        }
    }
}

