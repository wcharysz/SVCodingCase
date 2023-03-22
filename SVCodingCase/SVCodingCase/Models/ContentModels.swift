//
//  ContentModel.swift
//  SVCodingCase
//
//  Created by Wojciech Charysz on 22.03.23.
//

import Foundation
import GRDB

struct ContentModel: Identifiable, Equatable, Hashable {
    var id: String
    let lockName: String
    let shortCut: String
    let floor: String
    let roomNumber: String
    
    init(_ record: ContentRecord) {
        id = record.lock.id
        lockName = record.lock.name
        shortCut = record.shortCut
        floor = record.lock.floorDescription
        roomNumber = record.lock.roomNumber
    }
}


struct ContentRecord: Decodable, FetchableRecord {
    var shortCut: String
    var lock: Lock
}

struct BuildingRequest: Decodable, FetchableRecord {
    var building: Building
    var locks: [Lock]
}
