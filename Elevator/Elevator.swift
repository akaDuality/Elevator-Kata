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
    init(floors: Int) {
        self.floorsCount = floors
    }
    
    let floorsCount: Int
    var currentFloor: Int = 1
    var destination: Int?
    
    var isMoving: Bool {
        return destination != nil
    }
    
    func call(to callingFloor: Int) {
        guard callingFloor != currentFloor else {
            openDoor()
            return
        }
        
        move(to: callingFloor)
    }
    
    private func move(to floor: Int) {
        closeDoor()
        destination = floor
        
        let floorDiff = currentFloor - floor
        engine.move(to: floorDiff, onChange: {
            self.finishMovement(on: floor)
        })
    }
    
    private func finishMovement(on floor: Int) {
        currentFloor = floor
        destination = nil
        openDoor()
    }
    
    // MARK: - Doors
    var doors: DoorState = .close
    private func openDoor() {
        doors = .open
    }
    
    private func closeDoor() {
        doors = .close
    }
    
    enum DoorState {
        case close
        case open
    }
    
    private let engine = Engine()
}

private class Engine {
    func move(to floorDiff: Int, onChange: @escaping () -> Void) {
        let timeToWait = TimeInterval(abs(floorDiff))
        DispatchQueue.main.asyncAfter(deadline: .now() + timeToWait) {
            onChange()
        }
    }
}
