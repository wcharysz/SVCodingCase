//
//  SQLiteStore.swift
//  SVCodingCase
//
//  Created by Wojciech Charysz on 20.03.23.
//

import Foundation
import GRDB

class SQLiteStore {
    
    private static let dbFile = "db.sqlite"
    
    let dbPool: DatabasePool
    
    init?() {
        do {
            var config = Configuration()
            config.defaultTransactionKind = .immediate
            config.busyMode = .timeout(10)
            
            guard var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                return nil
            }
            
            url.append(component: SQLiteStore.dbFile)
            
            dbPool = try DatabasePool(path: url.absoluteString, configuration: config)
        } catch let error {
            debugPrint("SQLiteStore error: ", error)
            
            return nil
        }
    }
    
    func createTables(_ objects: [some CreateTable]) throws {
        for object in objects {
            try type(of: object.self).createTable(dbPool)
        }
    }
    
    func saveRecords(_ records: SVData) throws {
        try dbPool.write({ db in
            for lock in records.locks {
                try lock.insert(db, onConflict: .replace)
            }
            
            for building in records.buildings {
                try building.insert(db, onConflict: .replace)
            }
            
            for group in records.groups {
                try group.insert(db, onConflict: .replace)
            }
            
            for media in records.media {
                try media.insert(db, onConflict: .replace)
            }
        })
    }
    /*
    func loadRecords() async throws -> SVData {
        try await dbPool.read({ db in
            try SVData.fetchOne(db)
        })
    }
     */
}
