//
//  Card.swift
//  Concentration
//
//  Created by Abram Himmer on 5/7/18.
//  Copyright © 2018 Abram Himmer. All rights reserved.
//

import Foundation

struct Card: Hashable
{
    
    var hashValue: Int {return identifier}
    
    static func == (lhs: Card, rhs: Card) -> Bool{
        return lhs.identifier == rhs.identifier
    }
    
    var numberOfTimesViewed = 0
    var isFaceUp = false
    var isMatched = false
    private var identifier: Int
    
    
    mutating func view(){
        numberOfTimesViewed += 1
    }
    
    private static var  identifierFactory = 0
    
    private static func getUniqueIdentifier() -> Int{ //static means that it is tied to the card type. not the card. An object can't call this --> only the type. We are using it so
        
        identifierFactory += 1
        return identifierFactory
    }
    
    init(){
        self.identifier = Card.getUniqueIdentifier()
    }
    
}
