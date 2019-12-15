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
    
    func test_elevatorOn1stFloor_whenCallTo2ndFloor_shouldStartMovementTo2ndFloor() {
        elevator.currentFloor = 1
        
        elevator.call(to: 2)
        
        XCTAssertEqual(elevator.destinations, [2])
        XCTAssertTrue(elevator.isMoving)
    }
    
    func test_whenElevatorHitsDestination_shouldStopMovingAndForgetDestination() {
        elevator.currentFloor = 1
        
        elevator.call(to: 2)
        wait(1)
        
        XCTAssertTrue(elevator.destinations.isEmpty)
        XCTAssertFalse(elevator.isMoving)
    }
    
    func test_on1stFloor_whenCallTo2ndAndWait_shouldMoveTo2ndFloor() {
        elevator.currentFloor = 1
        
        elevator.call(to: 2)
        
        wait(1)
        XCTAssertEqual(elevator.currentFloor, 2)
    }
    
    func test_whenMoveElevatorAfterManEnters_shouldCloseDoorsOnMoveStart() {
        elevator.currentFloor = 1
        
        elevator.call(to: 1)
        elevator.call(to: 2)
        XCTAssertEqual(elevator.doors.state, .close)
    }
    
    func test_whenMoveElevatorAfterManEnters_andArriveToFloor_shouldOpenDoorsOnExit() {
        elevator.currentFloor = 1
        elevator.call(to: 1) // Open doors, enter
        
        elevator.call(to: 2)
        wait(1)
        XCTAssertEqual(elevator.doors.state, .open)
    }
    
    // MARK: - Add passengers alongside route
    
    func test_onFirstFloorAndMovesTo3_whenRequestTo2ndFloor_shouldStopOn2ndFloorAndOpenDoors() {
        elevator.call(to: 3)
        elevator.call(to: 2)
        wait(1)
        XCTAssertEqual(elevator.currentFloor, 2)
        XCTAssertEqual(elevator.doors.state, .open)
    }
    
//    func test_onFirstFloorAndMovesTo3_whenRequestTo2ndFloor_shouldStopAt3rdFloorAsResult() {
//        elevator.call(to: 3)
//        elevator.call(to: 2)
//        wait(2)
//        XCTAssertEqual(elevator.currentFloor, 3)
//    }

    func wait(_ sec: Int) {
        engine.wait(sec)
    }
    
    private var elevator: Elevator!
    private var engine: ManualEngine!
    override func setUp() {
        engine = ManualEngine()
        elevator = Elevator(floors: 16, engine: engine)
    }

    override func tearDown() {
        elevator = nil
    }
}

class ManualEngine: EngineProtocol {
    var onChange: (() -> Void)?
    var diff: Int?
    func move(to floorDiff: Int, onChange: @escaping () -> Void) {
        self.onChange = onChange
        self.diff = floorDiff
    }
    
    func wait(_ sec: Int) {
        if sec == diff.map { abs($0) } {
            onChange?()
        }
    }
}
