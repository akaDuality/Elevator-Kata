//
//  Elevator.swift
//  Elevator
//
//  Created by Mikhail Rubanov on 10.12.2019.
//  Copyright © 2019 akaDuality. All rights reserved.
//

import Foundation

struct Building {
    let floors: Int
    let elevator: Elevator?
    
    init(floors: Int, elevator: Elevator? = nil) {
        self.floors = floors
        self.elevator = elevator
    }
}



class Elevator {
    init(floors: Int, engine: EngineProtocol) {
        self.floorsCount = floors
        self.engine = engine
    }
    
    let floorsCount: Int
    var currentFloor: Int = 1
    var destinations: [Int] = []
    
    var isMoving: Bool {
        return !destinations.isEmpty
    }
    
    func call(to callingFloor: Int) {
        guard callingFloor != currentFloor else {
            doors.open()
            return
        }
        
        move(to: callingFloor)
    }
    
    private func move(to floor: Int) {
        doors.close()
        destinations.append(floor)
        destinations.sort()
        
        guard !engine.isMoving else { return }
        moveToNextDestination()
    }
    
    private func moveToNextDestination() {
        let nextFloor = destinations.first!
        let floorDiff = nextFloor - currentFloor
        
        engine.move(to: floorDiff, onChange: {
            self.stop(on: nextFloor)
            
            guard self.hasDestinations else { return }
            self.moveToNextDestination()
        })
    }
    
    private var hasDestinations: Bool { !destinations.isEmpty }
    
    private func stop(on floor: Int) {
        currentFloor = floor
        doors.open()
        
        destinations.removeAll { (value) -> Bool in
            value == floor
        }
    }
    
    let doors = Doors()
    private let engine: EngineProtocol
}

class Doors {
    var state: DoorState = .close
    enum DoorState {
        case close
        case open
    }
    
    fileprivate func open() {
        state = .open
    }
    
    fileprivate func close() {
        state = .close
    }
}

protocol EngineProtocol {
    func move(to floorDiff: Int, onChange: @escaping () -> Void)
    var isMoving: Bool { get }
}

