//
//  ElevatorTests.swift
//  ElevatorTests
//
//  Created by Mikhail Rubanov on 10.12.2019.
//  Copyright © 2019 akaDuality. All rights reserved.
//

import XCTest
@testable import Elevator

class BuildingTests: XCTestCase {

    func test_buildingHas16Floors() {
        let building = Building(floors: 16)
        
        XCTAssertEqual(building.floors, 16)
    }
    
    func test_buildingIsPossibleWithoutElevator() {
        let building = Building(floors: 16)
        
        XCTAssertNil(building.elevator)
    }
    
    func test_buildingHasOptionalElevator() {
        let building = Building(
            floors: 16,
            elevator: Elevator(
                floors: 16,
                engine: ManualEngine(),
                timer: TimerMock()))

        XCTAssertNotNil(building.elevator)
    }
    
    override func setUp() {
        
    }

    override func tearDown() {
        
    }
}
