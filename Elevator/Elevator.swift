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
        self.floors = floors
    }
    
    let floors: Int
    var currentFloor: Int = 1
    
    var doorsIsClosed: Bool = true
    var destination: Int?
    
    func call(to callingFloor: Int) {
        guard callingFloor != currentFloor else {
            doorsIsClosed = false
            return
        }
        
        move(to: callingFloor)
    }
    
    private func move(to floor: Int) {
        destination = floor
        doorsIsClosed = true
        
        let timeToWait = TimeInterval(abs(currentFloor - floor))
        DispatchQueue.main.asyncAfter(deadline: .now() + timeToWait) {
            self.currentFloor = floor
        }
    }
}
