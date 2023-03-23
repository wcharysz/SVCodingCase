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
    
    init(_ row: Row) {
        id = row["id"]
        lockName = row["name"]
        shortCut = row["shortCut"]
        floor = row["floor"] ?? "🤷‍♂️"
        roomNumber = row["roomNumber"]
    }
}

struct ContentRecord: Decodable, FetchableRecord {
    var shortCut: String
    var lock: Lock
}
