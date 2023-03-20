//
//  SVDataExtensions.swift
//  SVCodingCase
//
//  Created by Wojciech Charysz on 20.03.23.
//

import Foundation
import GRDB

protocol CreateTable {
    static func createTable(_ pool: DatabasePool) throws
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

extension Building: CreateTable {
    static func createTable(_ pool: DatabasePool) throws {
        try pool.write({ db in
            if !(try db.tableExists("Building")) {
                try db.create(table: "Building", body: { table in
                    table.primaryKey("id", .text).unique().notNull(onConflict: .fail)
                    table.column("shortCut", .text)
                    table.column("name", .text).notNull(onConflict: .fail)
                    table.column("description", .text)
                })
            }
        })
    }
}

extension Lock: CreateTable {
    static func createTable(_ pool: GRDB.DatabasePool) throws {
        try pool.write({ db in
            if !(try db.tableExists("Lock")) {
                try db.create(table: "Lock", body: { table in
                    table.primaryKey("id", .text).notNull(onConflict: .fail).unique()
                    table.column("buildingId", .text).notNull(onConflict: .fail).references("Building")
                    table.column("type", .text).notNull(onConflict: .fail)
                    table.column("name", .text).notNull(onConflict: .fail)
                    table.column("description", .text)
                    table.column("serialNumber", .text).notNull(onConflict: .fail)
                    table.column("floor", .text)
                    table.column("roomNumber", .text).notNull(onConflict: .fail)
                })
            }
        })
    }
}

extension Media: CreateTable {
    static func createTable(_ pool: GRDB.DatabasePool) throws {
        try pool.write({ db in
            if !(try db.tableExists("Media")) {
                try db.create(table: "Media", body: { table in
                    table.primaryKey("id", .text).notNull(onConflict: .fail).unique()
                    table.column("groupId", .text).notNull(onConflict: .fail).references("Group")
                    table.column("type", .text).notNull(onConflict: .fail)
                    table.column("owner", .text).notNull(onConflict: .fail)
                    table.column("description", .text)
                    table.column("serialNumber", .text).notNull(onConflict: .fail)
                })
            }
        })
    }
}

extension Group: CreateTable {
    static func createTable(_ pool: GRDB.DatabasePool) throws {
        try pool.write({ db in
            if !(try db.tableExists("Group")) {
                try db.create(table: "Group", body: { table in
                    table.primaryKey("id", .text).notNull().unique()
                    table.column("name", .text).notNull(onConflict: .fail)
                    table.column("description", .text).notNull(onConflict: .fail)
                })
            }
        })
    }
}
