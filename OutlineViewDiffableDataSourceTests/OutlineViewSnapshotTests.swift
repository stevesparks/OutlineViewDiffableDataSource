//
//  OutlineViewSnapshotTests.swift
//  OutlineViewDiffableDataSourceTests
//
//  Created by Steve Sparks on 2/10/20.
//  Copyright © 2020 Big Nerd Ranch. All rights reserved.
//

import XCTest
@testable import OutlineViewDiffableDataSource

class OutlineViewSnapshotTests: XCTestCase {
    let dataSource = ArrayDataSource()
    let outlineView = NSOutlineView()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInsertInstructions() {
        dataSource.contents =  [
            ArrayDataSource.RootIdentfier: ["A", "B"],
            "A": ["A1", "A2"],
            "A1": ["A1a", "A1b"],
            "B": ["B1", "B2"],
            "B2": ["B2b"]
        ]

        let firstSnapshot = OutlineViewSnapshot(from: dataSource, for: outlineView)
        dataSource.contents["B"] = ["B1", "B1A", "B2"]
        let secondSnapshot = OutlineViewSnapshot(from: dataSource, for: outlineView)

        let instructions = firstSnapshot.instructions(forMorphingInto: secondSnapshot)
        XCTAssertEqual(instructions.count, 1, "Didn't pan out")
        XCTAssertEqual(instructions.first?.description, "Inserting @ [1, 1]: <OutlineMember: B1A>")
    }

    func testRemoveInstructions() {
        dataSource.contents =  [
            ArrayDataSource.RootIdentfier: ["A", "B"],
            "A": ["A1", "A2"],
            "A1": ["A1a", "A1b"],
            "B": ["B1", "B2"],
            "B2": ["B2b"]
        ]

        let firstSnapshot = OutlineViewSnapshot(from: dataSource, for: outlineView)
        dataSource.contents["B"] = ["B1"]
        let secondSnapshot = OutlineViewSnapshot(from: dataSource, for: outlineView)

        let instructions = firstSnapshot.instructions(forMorphingInto: secondSnapshot)
        XCTAssertEqual(instructions.count, 1, "Didn't pan out")
        XCTAssertEqual(instructions.first?.description, "Removing @ [1, 1]")
    }

    func testMoveInstructions() {
        dataSource.contents =  [
            ArrayDataSource.RootIdentfier: ["A", "B"],
            "A": ["A1", "A2"],
            "A1": ["A1a", "A1b"],
            "B": ["B1", "B2"],
            "B2": ["B2b"]
        ]

        let firstSnapshot = OutlineViewSnapshot(from: dataSource, for: outlineView)
        dataSource.contents["B"] = ["B2", "B1"]
        let secondSnapshot = OutlineViewSnapshot(from: dataSource, for: outlineView)

        let instructions = firstSnapshot.instructions(forMorphingInto: secondSnapshot)
        XCTAssertEqual(instructions.count, 1, "Didn't pan out")
        XCTAssertEqual(instructions.first?.description, "Move from [1, 1] to [1, 0]")
    }
}
