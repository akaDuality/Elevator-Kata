//
//  ElevatorTests.swift
//  ElevatorTests
//
//  Created by Mikhail Rubanov on 10.12.2019.
//  Copyright © 2019 akaDuality. All rights reserved.
//

import XCTest
@testable import Elevator

class ElevatorTests: XCTestCase {

    func test_buildingHas16Floors() {
        let building = Building(floors: 16)
        
        XCTAssertEqual(building.floors, 16)
    }
    
    override func setUp() {
        
    }

    override func tearDown() {
        
    }
}
