//
//  setGame.swift
//  setGame
//
//  Created by Abram Himmer on 5/19/18.
//  Copyright © 2018 Abram Himmer. All rights reserved.
//

import Foundation

struct SetGame {

    private var deckOfCards = [SetCard]()
    private(set) var selectedCards = [SetCard]()
    private(set) var cardsInPlay = [SetCard]()
    private(set) var matchedCards = [SetCard]()
    private(set) var hintCards = [SetCard]()
    private(set) var mismatchedCards = [SetCard]()
    private(set) var score = 0
    
    
    var p2Score = 0
    var p1Score = 0
    var p1Bool = false
    var p2Bool = false
    var playerBool: Bool {
        get {
            return p2Bool || p1Bool
        }
    }
    
    mutating func playerTouchCard(points: Int){
        if p1Bool {
            p1Score += points
            p1Bool = false
        } else if p2Bool {
            p2Score += points
            p2Bool = false
        }
    }
    
    mutating func player1TakeTurn() {
        p1Bool = !p1Bool
        p2Bool = false
    }
    
    mutating func player2TakeTurn() {
        p2Bool = !p2Bool
        p1Bool = false
    }
    
    

    private var moreCards: Bool {
        if deckOfCards.count > 0 {
            return true
        } else {
            return false
        }
    }
    
    
    
    mutating func shuffleCards (){
        for i in 1..<cardsInPlay.count {
            let j = Int(arc4random_uniform(UInt32(i)))
            cardsInPlay.swapAt(j, i)
        }
    }
    
    mutating func fillDeckOfCards () {
        for color in SetCard.Value.all{
            for number in SetCard.Value.all{
                for shade in SetCard.Value.all {
                    for shape in SetCard.Value.all{
                            deckOfCards.append(SetCard(color: color, number: number, shade: shade, shape: shape))
                        //shuffle the deck
                            for i in 1..<deckOfCards.count {
                                let j = Int(arc4random_uniform(UInt32(i)))
                                deckOfCards.swapAt(j, i)
                            }
                        }
                    }
                }
            }
    }
    
    mutating func deal12Cards() {
        for _ in 0..<12 {
            let tempCard = deckOfCards.remove(at: 0)
            cardsInPlay.append(tempCard)
        }
    }
    
    mutating func checkIfMatch (subtract num: Int, hint: Bool) -> Bool {
        var tempArr = [SetCard]()
        for i in 0..<cardsInPlay.count {
            if !matchedCards.contains(cardsInPlay[i]){
                for j in i+1..<cardsInPlay.count {
                    if !matchedCards.contains(cardsInPlay[j]){
                        for k in j+1..<cardsInPlay.count {
                            if !matchedCards.contains(cardsInPlay[k]){
                                tempArr.append(cardsInPlay[i])
                                tempArr.append(cardsInPlay[j])
                                tempArr.append(cardsInPlay[k])
                                if isMatch(cardsToCheck: tempArr) {
                                    score -= num
                                    if hint {
                                        hintCards+=tempArr
                                    }
                                    tempArr.removeAll()
                                    return true
                                }
                                tempArr.removeAll()
                            }
                        }
                    }
                }
            }
        }
        return false
    }
    
    mutating func deal3Cards() {
        //if !checkIfMatch(subtract: 2, hint: false){
            if moreCards {
                for _ in cardsInPlay.count..<(cardsInPlay.count+3){
                    let tempCard = deckOfCards.remove(at: 0)
                    cardsInPlay.append(tempCard)
                }
            }
        //}
    }
    
    mutating func giveHint () {
        if checkIfMatch(subtract: 0, hint: true) {
             playerTouchCard(points: -6)
        }
    }
    
    mutating func isMatch(cardsToCheck arr: [SetCard]) ->Bool{
        var totalColor = 0
        var totalNumber = 0
        var totalShade = 0
        var totalShape = 0
        //color
        for i in 0..<arr.count {
            totalColor += arr[i].color.rawValue
        }
        
        //number
        for i in 0..<arr.count {
            totalNumber += arr[i].number.rawValue
        }
        //shade
        for i in 0..<arr.count {
            totalShape += arr[i].shape.rawValue
        }
        //shape
        for i in 0..<arr.count {
            totalShade += arr[i].shade.rawValue
        }
        
        var matchBool: Bool {
            let total = (totalShade % 3) + (totalNumber % 3) + (totalShape % 3) + (totalColor % 3)
            if total == 0 {
                return true
            } else {
                return false
            }
        }
        return matchBool
    }
    
    mutating func checkSelectedCardsForMatch(){
        if selectedCards.count == 3 {
            if isMatch(cardsToCheck: selectedCards) {
                matchedCards += selectedCards
                selectedCards.removeAll()
                playerTouchCard(points: 6)
            } else {
                playerTouchCard(points: -3)
                mismatchedCards += selectedCards
            }
        }
    }
    
    mutating func dumpMatchedCardsAndDealCards(){
        for i in 0..<matchedCards.count {
            if cardsInPlay.contains(matchedCards[i]) {
                if deckOfCards.count > 0, let replaceIndex = cardsInPlay.index(of: matchedCards[i]){
                    cardsInPlay[replaceIndex] = deckOfCards.remove(at: 0)
                } else if deckOfCards.count == 0, let removeIndex = cardsInPlay.index(of: matchedCards[i]) {
                    cardsInPlay.remove(at: removeIndex)
                }
            }
        }
    }
    
    mutating func selectCard (at index: Int) {
        if playerBool, index < cardsInPlay.count {
            hintCards.removeAll()
            mismatchedCards.removeAll()
            if !selectedCards.contains(cardsInPlay[index]), !matchedCards.contains(cardsInPlay[index])  {
                let card = cardsInPlay[index]
                if selectedCards.count == 3 {
                    selectedCards.removeAll()
                }
                selectedCards.append(card)
                if selectedCards.count == 3 {
                    checkSelectedCardsForMatch()
                    dumpMatchedCardsAndDealCards()
                }
            } else if index < cardsInPlay.count, selectedCards.count < 3, selectedCards.contains(cardsInPlay[index]) {
                let selectedIndex = selectedCards.index(of: cardsInPlay[index])
                selectedCards.remove(at: selectedIndex!)
            }
        }
    }
    
    
    
    
    //TO SEE SELECTION AFTERWARD
    
//    mutating func selectCard (at index: Int) {
//        hintCards.removeAll()
//        if index < cardsInPlay.count, !selectedCards.contains(cardsInPlay[index]), !matchedCards.contains(cardsInPlay[index])  {
//
//            if selectedCards.count == 3 {
//                pullAndDrawCards()
//                selectedCards.removeAll()
//                selectedCards.append(cardsInPlay[index])
//            } else {
//                selectedCards.append(cardsInPlay[index])
//                checkSelectedCardsForMatch()
//            }
//        } else if index < cardsInPlay.count, selectedCards.count < 3, selectedCards.contains(cardsInPlay[index]) {
//            let selectedIndex = selectedCards.index(of: cardsInPlay[index])
//            selectedCards.remove(at: selectedIndex!)
//        }
//    }
//
    init () {
        fillDeckOfCards()
        deal12Cards()
    }


}


