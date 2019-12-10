//
//  ElevatorTests\.swift
//  ElevatorTests
//
//  Created by Mikhail Rubanov on 10.12.2019.
//  Copyright © 2019 akaDuality. All rights reserved.


import XCTest
@testable import Elevator

class ElevatorTests: XCTestCase {
    
    func test_elevatorHasFloors() {
        XCTAssertEqual(elevator.floors, 16)
    }
  
    func test_elevatorIsPlacedOnFirstFloorByDefault() {
        XCTAssertEqual(elevator.currentFloor, 1)
    }
    
    func test_elevarDoors_areClosedBydefault() {
        XCTAssertTrue(elevator.doorsIsClosed)
    }
    
    func test_elevatorOn1stFloor_whenCallTo1stFloor_shouldOpenDoor() {
        elevator.currentFloor = 1
        
        elevator.call(to: 1)
        
        XCTAssertFalse(elevator.doorsIsClosed)
    }
    
    func test_elevatorOn2ndFloor_whenCallTo1stFloor_shouldNotOpenDoor() {
        elevator.currentFloor = 2
        
        elevator.call(to: 1)
        
        XCTAssertTrue(elevator.doorsIsClosed)
    }

    private var elevator: Elevator!
    override func setUp() {
        elevator = Elevator(floors: 16)
    }

    override func tearDown() {
        elevator = nil
    }

}
