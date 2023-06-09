//
//  DataParser.swift
//  SVCodingCase
//
//  Created by Wojciech Charysz on 17.03.23.
//

import Foundation
import ComposableArchitecture

struct DataParser {
    var parseData: (Data) throws -> SVData
}


extension DataParser {
    static let instance = DataParser { data in
        let jsonDecoder = JSONDecoder()
        let result = try jsonDecoder.decode(SVData.self, from: data)
        
        return result
    }
}


extension DataParser: DependencyKey {
    static var liveValue = DataParser.instance
    static var testValue = DataParser.instance
}

extension DependencyValues {
    var dataParser: DataParser {
        get {
            self[DataParser.self]
        }
        
        set {
            self[DataParser.self] = newValue
        }
    }
}
