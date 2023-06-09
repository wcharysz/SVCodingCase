//
//  SVCodingCaseTests.swift
//  SVCodingCaseTests
//
//  Created by Wojciech Charysz on 17.03.23.
//

import XCTest
import ComposableArchitecture
@testable import SVCodingCase

final class SVCodingCaseTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testJSONParsing() async throws {
        @Dependency(\.dataClient) var dataClient
        @Dependency(\.dataParser) var parser
        
        let data = try await dataClient.loadData()
        let result = try parser.parseData(data)
        XCTAssertNotNil(result)
    }

    
    func testLockSearching() async throws {
        @Dependency(\.dataClient) var dataClient
        @Dependency(\.dataParser) var parser
        @Dependency(\.dataStore) var dataStore
        
        let data = try await dataClient.loadData()
        let result = try parser.parseData(data)
        XCTAssertNotNil(result)
        
        //Save data
        try dataStore.saveRecords(result)
        
        //Search for string "PROD"
        let result1 = try await dataStore.loadRecords("PROD")
        XCTAssertTrue(result1.count == 2)
        
        //Search for string "WC."
        let result2 = try await dataStore.loadRecords("WC.")
        XCTAssertTrue(result2.count == 4)
        
        //Search for string "WC."
        let result3 = try await dataStore.loadRecords("EG")
        XCTAssertTrue(result3.count == 1)
    }
    
    
    @MainActor
    func testContentDomain() async throws {
        @Dependency(\.dataClient) var dataClient
        @Dependency(\.dataParser) var parser
        @Dependency(\.dataStore) var dataStore
        
        let store = TestStore(initialState: .init(), reducer: ContentDomain())
        
        _ = await store.send(.loadData) {
            $0.isLoading = true
        }
        
        let data = try await dataClient.loadData()
        let model = try parser.parseData(data)
        
        await store.receive(.saveModel(model), timeout: 1)
        await store.receive(.reloadAllRows, timeout: 1)
        
        let rows = try await dataStore.loadAllRecords()
        
        await store.receive(.reloadRows(rows)) {
            $0.isLoading = false
            $0.rows = IdentifiedArrayOf(uniqueElements: rows)
        }
    }
}
