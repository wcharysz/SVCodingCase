// This file was generated from JSON Schema using quicktype
// To parse the JSON, add this file to your project and do:
//
//   let sVData = try? JSONDecoder().decode(SVData.self, from: jsonData)

import Foundation

// MARK: - SVData
struct SVData: Decodable, Equatable {
    let buildings: [Building]
    let locks: [Lock]
    let groups: [Building]
    let media: [Media]
}

// MARK: - Building
struct Building: Decodable, Equatable {
    let id: String
    let shortCut: String?
    let name: String
    let description: String?
}

// MARK: - Lock
struct Lock: Decodable, Equatable {
    let id, buildingID: String
    let type: LockType
    let name: String
    let description: String?
    let serialNumber: String
    let floor: Floor?
    let roomNumber: String

    enum CodingKeys: String, CodingKey {
        case id
        case buildingID = "buildingId"
        case type, name, description, serialNumber, floor, roomNumber
    }
}

enum Floor: Decodable, Equatable {
    case order(Int)
    /*
    case ground = "EG"
    case the1Og = "1.OG"
    case the3Og = "3.OG"
    case the4Og = "4.OG"
     */
    enum CodingKeys: CodingKey {
        case order
    }
    
    enum OrderCodingKeys: CodingKey {
        case _0
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var allKeys = ArraySlice(container.allKeys)
        guard let onlyKey = allKeys.popFirst(), allKeys.isEmpty else {
            throw DecodingError.typeMismatch(Floor.self, DecodingError.Context.init(codingPath: container.codingPath, debugDescription: "Invalid number of keys found, expected one.", underlyingError: nil))
        }
        switch onlyKey {
        case .order:
            let nestedContainer = try container.nestedContainer(keyedBy: Floor.OrderCodingKeys.self, forKey: .order)
            self = Floor.order(try nestedContainer.decode(Int.self, forKey: Floor.OrderCodingKeys._0))
        }
    }
}

enum LockType: String, Decodable, Equatable {
    case cylinder = "Cylinder"
    case smartHandle = "SmartHandle"
}

// MARK: - Media
struct Media: Decodable, Equatable {
    let id, groupID: String
    let type: MediaType
    let owner: String
    let description: String?
    let serialNumber: String

    enum CodingKeys: String, CodingKey {
        case id
        case groupID = "groupId"
        case type, owner, description, serialNumber
    }
}

enum MediaType: String, Decodable, Equatable {
    case card = "Card"
    case transponder = "Transponder"
    case transponderWithCardInlay = "TransponderWithCardInlay"
}
