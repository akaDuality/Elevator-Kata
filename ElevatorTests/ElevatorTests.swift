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
        let elevator = Elevator(floors: 16)
        
        XCTAssertEqual(elevator.floors, 16)
    }
  
    func test_elevatorIsPlacedOnFirstFloorByDefault() {
        let elevator = Elevator(floors: 16)
        
        XCTAssertEqual(elevator.currentFloor, 1)
    }
    
    func test_elevarDoors_areClosedBydefault() {
        let elevator = Elevator(floors: 16)
        
        XCTAssertTrue(elevator.doorsIsClosed)
    }
    
    func test_elevatorOn1stFloor_whenCallTo1stFloor_shouldOpenDoor() {
        let elevator = Elevator(floors: 16)
        elevator.currentFloor = 1
        
        elevator.call(to: 1)
        
        XCTAssertFalse(elevator.doorsIsClosed)
    }
    
    func test_elevatorOn2ndFloor_whenCallTo1stFloor_shouldNotOpenDoor() {
        let elevator = Elevator(floors: 16)
        elevator.currentFloor = 2
        
        elevator.call(to: 1)
        
        XCTAssertTrue(elevator.doorsIsClosed)
    }

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

}
