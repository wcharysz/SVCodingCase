// This file was generated from JSON Schema using quicktype
// To parse the JSON, add this file to your project and do:
//
//   let sVData = try? JSONDecoder().decode(SVData.self, from: jsonData)

import Foundation
import GRDB

// MARK: - SVData
struct SVData: Codable, Equatable, FetchableRecord {
    let buildings: [Building]
    let locks: [Lock] //# searchable
    let groups: [Group] //# searchable
    let media: [Media]
}

// MARK: - Building
struct Building: Codable, Identifiable, Equatable, FetchableRecord, PersistableRecord, TableRecord {
    static let locks = hasMany(Lock.self)
    
    var locks: QueryInterfaceRequest<Lock> {
        request(for: Building.locks)
    }
    
    var id: String
    let shortCut: String? //# searchable
    let name: String // # searchable
    let description: String?
}

// MARK: - Lock
struct Lock: Codable, Equatable, Identifiable, FetchableRecord, PersistableRecord, TableRecord {
    static let buildingForeignKey = ForeignKey([CodingKeys.buildingID])
    static let building = belongsTo(Building.self, using: buildingForeignKey)
    
    var building: QueryInterfaceRequest<Building> {
        request(for: Lock.building)
    }
    
    var id, buildingID: String
    let type: LockType
    let name: String //# searchable
    let description: String?
    let serialNumber: String
    let floor: Floor? //# searchable
    let roomNumber: String //# searchable

    enum CodingKeys: String, CodingKey, ColumnExpression {
        case id
        case buildingID = "buildingId"
        case type, name, description, serialNumber, floor, roomNumber
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.buildingID = try container.decode(String.self, forKey: .buildingID)
        self.type = try container.decode(LockType.self, forKey: .type)
        self.name = try container.decode(String.self, forKey: .name)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.serialNumber = try container.decode(String.self, forKey: .serialNumber)
        if let rawFloor = try container.decodeIfPresent(String.self, forKey: .floor) {
            if rawFloor == "EG" {
                self.floor = .ground
            } else {
                let floorString = rawFloor.trimmingCharacters(in: .decimalDigits.inverted)
                let number = NumberFormatter().number(from: floorString)
                guard let number else {
                    throw Floor.FloorErrors.invalidNumber
                }
                self.floor = .order(number.intValue)
            }
        } else {
            self.floor = nil
        }
        
        self.roomNumber = try container.decode(String.self, forKey: .roomNumber)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(buildingID, forKey: .buildingID)
        try container.encode(type, forKey: .type)
        try container.encode(name, forKey: .name)
        try container.encode(description, forKey: .description)
        try container.encode(serialNumber, forKey: .serialNumber)
        
        var rawFloor: String?
        
        switch floor {
        case .ground?:
            rawFloor = "EG"
        case .order(let number)?:
            rawFloor = String(number)
        default:
            break
        }
        
        try container.encode(rawFloor, forKey: .floor)
        try container.encode(roomNumber, forKey: .roomNumber)
    }
}

enum Floor: Codable, Equatable {
    case ground
    case order(Int)
    
    enum FloorErrors: Error {
        case invalidNumber
    }
    
    var description: String {
        switch self {
        case .order(let number):
            return String(number)
        case .ground:
            return "Ground"
        }
    }
}

enum LockType: String, Codable, Equatable {
    case cylinder = "Cylinder"
    case smartHandle = "SmartHandle"
}

// MARK: - Media
struct Media: Codable, Identifiable, Equatable, FetchableRecord, PersistableRecord {
    static let groupForeignKey = ForeignKey([CodingKeys.groupID])
    static let group = belongsTo(Group.self, using: groupForeignKey)
    
    var group: QueryInterfaceRequest<Group> {
        request(for: Media.group)
    }
    
    var id, groupID: String
    let type: MediaType
    let owner: String
    let description: String?
    let serialNumber: String

    enum CodingKeys: String, CodingKey, ColumnExpression {
        case id
        case groupID = "groupId"
        case type, owner, description, serialNumber
    }
}

enum MediaType: String, Codable, Equatable {
    case card = "Card"
    case transponder = "Transponder"
    case transponderWithCardInlay = "TransponderWithCardInlay"
}

struct Group: Codable, Identifiable, Equatable, FetchableRecord, PersistableRecord {
    static let media = hasMany(Media.self)
    
    var media: QueryInterfaceRequest<Media> {
        request(for: Group.media)
    }
    
    var id: String
    let name: String
    let description: String
}


