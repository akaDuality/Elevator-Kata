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
    
    func call() {
        doorsIsClosed = false
    }
}
