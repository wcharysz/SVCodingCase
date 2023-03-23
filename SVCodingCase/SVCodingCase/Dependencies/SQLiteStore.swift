//
//  SQLiteStore.swift
//  SVCodingCase
//
//  Created by Wojciech Charysz on 20.03.23.
//

import Foundation
import GRDB

class SQLiteStore {
    
    static let shared = SQLiteStore()
    
    private static let dbFile = "db.sqlite"
    
    var dbPool: DatabasePool?
    
    enum SQLiteStoreErrors: Error {
        case noDBPool
        case noPathForDB
    }
    
    init() {
        do {
            var config = Configuration()
            config.defaultTransactionKind = .immediate
            config.busyMode = .timeout(10)
            
            guard var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                throw SQLiteStoreErrors.noPathForDB
            }
            
            url.append(component: SQLiteStore.dbFile)
            
            dbPool = try DatabasePool(path: url.absoluteString, configuration: config)
            try createTables()
        } catch let error {
            debugPrint("SQLiteStore error: ", error)
        }
    }
    
    func createTables() throws {
        guard let dbPool else {
            throw SQLiteStoreErrors.noDBPool
        }
        
        try Building.createTable(dbPool)
        try Lock.createTable(dbPool)
        try Group.createTable(dbPool)
        try Media.createTable(dbPool)
    }
    
    func saveRecords(_ records: SVData) throws {
        guard let dbPool else {
            throw SQLiteStoreErrors.noDBPool
        }
        
        try dbPool.write({ db in
            
            for building in records.buildings {
                try building.insert(db, onConflict: .replace)
            }
            
            for lock in records.locks {
                try lock.insert(db, onConflict: .replace)
            }
            
            for group in records.groups {
                try group.insert(db, onConflict: .replace)
            }
            
            for media in records.media {
                try media.insert(db, onConflict: .replace)
            }
        })
    }

    func loadRecords(_ searched: String) async throws -> [Row] {
        guard let dbPool else {
            throw SQLiteStoreErrors.noDBPool
        }
        
        let rows = try await dbPool.read({ db in
            try Row.fetchAll(db, sql: "SELECT Lock.id, Building.shortCut, Lock.name, Lock.floor, Lock.roomNumber FROM Building JOIN Lock ON Building.id = Lock.buildingId WHERE Building.shortCut LIKE '%\(searched)%' OR Building.name LIKE '%\(searched)%' OR Lock.name LIKE '%\(searched)%' OR Lock.floor LIKE '%\(searched)%' OR Lock.roomNumber LIKE '%\(searched)%'")
        })
        
        return rows
    }
    
    func loadAllRecords() async throws -> [ContentRecord] {
        guard let dbPool else {
            throw SQLiteStoreErrors.noDBPool
        }
        
        let locks = try await dbPool.read({ db in
            try Lock.annotated(withRequired: Lock.building.select(Column("shortCut")))
                .asRequest(of: ContentRecord.self)
                .fetchAll(db)
        })
        
        return locks
    }
}
