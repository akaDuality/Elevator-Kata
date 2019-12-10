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
        XCTAssertEqual(elevator.floorsCount, 16)
    }
  
    func test_elevatorIsPlacedOnFirstFloorByDefault() {
        XCTAssertEqual(elevator.currentFloor, 1)
    }
    
    // MARK: - Doors
    func test_elevarDoors_areClosedBydefault() {
        XCTAssertEqual(elevator.doors.state, .close)
    }
    
    func test_elevatorOn1stFloor_whenCallTo1stFloor_shouldOpenDoor() {
        elevator.currentFloor = 1
        
        elevator.call(to: 1)
        
        XCTAssertEqual(elevator.doors.state, .open)
    }
    
    func test_elevatorOn2ndFloor_whenCallTo1stFloor_shouldNotOpenDoorImmediately() {
        elevator.currentFloor = 2
        
        elevator.call(to: 1)
        
        XCTAssertEqual(elevator.doors.state, .close)
    }
    
    func test_elevatorOn2ndFloor_whenCallTo1stFloor_shouldOpenDoorWhenArrived() {
        elevator.currentFloor = 2
        
        elevator.call(to: 1)
        wait(1)
        XCTAssertEqual(elevator.doors.state, .open)
    }
    
    // MARK: - Moving
    func test_elevatorInNotMovingByDefault() {
        XCTAssertFalse(elevator.isMoving)
    }
    
    func test_elevatorOn1stFloor_whenCallTo2ndFloor_shouldMoveTo2ndFloor() {
        elevator.currentFloor = 1
        
        elevator.call(to: 2)
        
        XCTAssertEqual(elevator.destination, 2)
        XCTAssertTrue(elevator.isMoving)
    }
    
    func test_whenElevatorHitsDestination_shouldStopMovingAndForgetDestination() {
        elevator.currentFloor = 1
        
        elevator.call(to: 2)
        wait(1)
        
        XCTAssertNil(elevator.destination)
        XCTAssertFalse(elevator.isMoving)
    }
    
    func test_on1stFloor_whenCallTo2ndAndWait_shouldBeOn2ndFloor() {
        elevator.currentFloor = 1
        
        elevator.call(to: 2)
        
        wait(1)
        XCTAssertEqual(elevator.currentFloor, 2)
    }
    
    func test_whenMoveElevatorAfterManEnters_shouldCloseDoors() {
        elevator.currentFloor = 1
        
        elevator.call(to: 1)
        elevator.call(to: 2)
        XCTAssertEqual(elevator.doors.state, .close)
    }
    
    func test_whenMoveElevatorAfterManEnters_andArriveToFloor_shouldOpenDoors() {
        elevator.currentFloor = 1
        
        elevator.call(to: 1)
        elevator.call(to: 2)
        wait(1)
        XCTAssertEqual(elevator.doors.state, .open)
    }

    func wait(_ sec: Int) {
        RunLoop.main.run(until: Date().addingTimeInterval(TimeInterval(sec)))
    }
    
    private var elevator: Elevator!
    override func setUp() {
        elevator = Elevator(floors: 16)
    }

    override func tearDown() {
        elevator = nil
    }

}
