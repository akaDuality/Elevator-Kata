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
    
    func call(to callingFloor: Int) {
        guard callingFloor != currentFloor else {
            openDoor()
            return
        }
        
        move(to: callingFloor)
    }
    
    private func move(to floor: Int) {
        closeDoor()
        
        simulateMovement(to: floor)
    }
    
    private func simulateMovement(to floor: Int) {
        destination = floor
        let timeToWait = TimeInterval(abs(currentFloor - floor))
        DispatchQueue.main.asyncAfter(deadline: .now() + timeToWait) {
            self.currentFloor = floor
        }
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
}
