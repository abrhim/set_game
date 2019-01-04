//
//  playingCard.swift
//  setGame
//
//  Created by Abram Himmer on 5/19/18.
//  Copyright © 2018 Abram Himmer. All rights reserved.
//

import Foundation

struct SetCard: Equatable, Hashable {
    
    static func == (lhs: SetCard, rhs: SetCard) -> Bool{
        return lhs.color == rhs.color && lhs.number == rhs.number && lhs.shade == rhs.shade && lhs.shape == rhs.shape
    }
    
    var color: Value
    var number: Value
    var shade: Value
    var shape: Value
    
    enum Value: Int {
        case one = 1
        case two = 2
        case three = 3
        static var all = [Value.one, .two, .three]
    }
}
