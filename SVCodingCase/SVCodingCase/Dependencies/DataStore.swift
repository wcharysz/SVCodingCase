//
//  DataStore.swift
//  SVCodingCase
//
//  Created by Wojciech Charysz on 20.03.23.
//

import Foundation
import ComposableArchitecture

struct DataStore {
    let saveRecords: (_ records: SVData) throws -> Void
    let loadRecords: () async throws -> SVData
}


