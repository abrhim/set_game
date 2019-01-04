//
//  Concentration.swift
//  Concentration
//
//  Created by Abram Himmer on 5/7/18.
//  Copyright © 2018 Abram Himmer. All rights reserved.
//

import Foundation

class Concentration
{/*
     private var timer: Timer?
     private var timer2: Timer?
     private func startTimer () {
     print("tried to start timer")
     timer = Timer(timeInterval: 5, repeats: true) { (timer) in
     self.flipCount = 2 * self.flipCount
     print("timer went off")
     }
     }
     
     func invalidateTimer() {
     timer?.invalidate()
     }
     
     */
    
    
    private(set) var cards = [Card]() //array of cards
    
    var flipCount = 0
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get{
            var foundIndex: Int?
            for index in cards.indices {
                if cards[index].isFaceUp{
                    if foundIndex == nil {
                        foundIndex = index
                    } else {
                        return nil
                    }
                }
            }
            return foundIndex
        }
        set(newValue){
            for index in cards.indices{
                cards[index].isFaceUp = (index == newValue) //expression that says if index == newValue set to true, otherwise set to false. Never seen that one before!
            }
        }
    }
    
    func chooseCard(at index: Int){
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not in the cards")
        
        cards[index].view()
        
        if !cards[index].isMatched, !cards[index].isFaceUp {
            flipCount += cards[index].numberOfTimesViewed
        }
        if !cards[index].isMatched{
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                // check if cards match
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                cards[index].isFaceUp = true
            } else {
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    init(numberOfPairsOfCards: Int){
        //startTimer()
        assert(numberOfPairsOfCards > 0, "Concentration.init(\(numberOfPairsOfCards)): you must have atelast one pair of cards")
        
        for _ in 0..<numberOfPairsOfCards { //for each pair of cards
            let card = Card()
            cards += [card, card] //add in two pairs of cards
        }
        
        for i in 1..<cards.count {  //stride(from: cards.count-1, to: 1, by: -1){ <-- that's how to decrement for a high number
            let j = Int(arc4random_uniform(UInt32(i)))
            cards.swapAt(j, i)
        }
    }
    
    
    
    
}
