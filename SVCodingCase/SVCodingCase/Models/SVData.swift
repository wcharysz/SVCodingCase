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
struct Lock: Decodable, Equatable, Identifiable {
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
        allFields = parseAllFields()
    }
    
    var allFields: Set<String> = Set()
    
    private func parseAllFields() -> Set<String> {
        let mirror = Mirror(reflecting: self)
        
        let array = mirror.children.compactMap { child in
            switch child.value {
            case let value as String:
                return value
            case let value as LockType:
                return value.rawValue
            case let value as Floor:
                return value.description
            default:
                return nil
            }
        }
        
        return Set(array)
    }
}

enum Floor: Decodable, Equatable {
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


extension Lock {
    var buildingDesription: String {
        let result = buildingID.prefix(5)
        
        return String(result)
    }
    
    var floorDescription: String {
        guard let floor else {
            return "🤷‍♂️"
        }
        
        return floor.description
    }
}
