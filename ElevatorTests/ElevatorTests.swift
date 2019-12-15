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
    
    func test_onFirstFloorAndMovesTo2_whenRequestTo3rdFloor_shouldStopOn2ndFloorAndOpenDoors() {
        elevator.call(to: 2)
        elevator.call(to: 3)
        wait(1) // Move to 1st floor
        XCTAssertEqual(elevator.currentFloor, 2)
        XCTAssertEqual(elevator.doors.state, .open)
    }
    
    func test_onFirstFloorAndMovesTo2_whenRequestTo3rdFloor_shouldStopAt3rdFloorAsResult() {
        elevator.call(to: 2)
        elevator.call(to: 3)
        wait(1)
        timer.waitWhileDoorsClosed()
        wait(1)
        XCTAssertEqual(elevator.currentFloor, 3)
    }
    
    func test_onFirstFloorAndMovesTo2_whenRequestTo4thFloor_shouldStopAt4thFloorAsResult() {
        elevator.call(to: 2)
        elevator.call(to: 4)
        wait(1)
        timer.waitWhileDoorsClosed()
        wait(2)
        XCTAssertEqual(elevator.currentFloor, 4)
    }

    func test_onFirstFloorAndMovesTo2_whenRequestTo4thFloor_shouldNotStopAt3rdFloorAsResult() {
        elevator.call(to: 2)
        elevator.call(to: 4)
        wait(1)
        timer.waitWhileDoorsClosed()
        wait(1)
        XCTAssertEqual(elevator.currentFloor, 3)
        XCTAssertEqual(elevator.doors.state, .close)
    }

    func wait(_ sec: Int) {
        engine.wait(sec)
    }
    
    private var elevator: Elevator!
    private var engine: ManualEngine!
    private var timer: TimerMock!
    override func setUp() {
        timer = TimerMock()
        engine = ManualEngine()
        elevator = Elevator(floors: 16, engine: engine, timer: timer)
    }

    override func tearDown() {
        elevator = nil
    }
}

class ManualEngine: EngineProtocol {
    var onChange: ((_ elapsedDiff: Int) -> Void)?
    var onStop: (() -> Void)?
    var diff: Int?
    
    var isMoving: Bool { diff != nil }
    func move(to floorDiff: Int,
              onChange: @escaping (_ elapsedDiff: Int) -> Void,
              onStop: @escaping () -> Void) {
        self.onChange = onChange
        self.onStop = onStop
        self.diff = floorDiff
    }
    
    func wait(_ sec: Int) {
        guard let diff = diff else { return }
        
        for _ in 0..<sec {
            let stepToZero = diff.stepToZero
            self.diff?.reduceToZero(step: 1)
            onChange?(-stepToZero)
            if self.diff == 0 {
                onStop?()
            }
        }
    }
}

extension Int {
    mutating func reduceToZero(step: Int) {
        self += stepToZero * step
    }
    
    var stepToZero: Int {
        guard self != 0 else {
            return 0
        }
        
        if self < 0 {
            return +1
        } else {
            return -1
        }
    }
}

class TimerMock: ElevatorTimer {
    var nextAction: (() -> Void)?
    func waitWhilePeopleExits(then nextAction: @escaping () -> Void) {
        self.nextAction = nextAction
    }
    
    func waitWhileDoorsClosed() {
        nextAction?()
    }
}
