//  ViewController.swift
//  Concentration
//
//  Created by Abram Himmer on 5/2/18.
//  Copyright © 2018 Abram Himmer. All rights reserved.
//

import UIKit

class ConcentrationViewController: UIViewController
{
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards) //can't be used until it is fully initalized.
    private lazy var themeNumber = arrayOfThemes.count.arc4random
    var numberOfPairsOfCards: Int{
        return ((cardButtons.count + 1) / 2 )
    }
    
    //UIViewController --> it is the superclass
    //var flipCount = 0
    
    var flipCount: Int =  100//{
    /*didSet{
     updateFlipCountLabel
     }*/
    // }
    
    /*private func flipCountLabel(){
     let attributes: [NSAttributedStringKey: Any] = [
     .strokeWidth: 5.0,
     .strokeColor : #colorLiteral(red: 1, green: 0.711981833, blue: 0.1608580947, alpha: 1)
     ]
     let attributedString = NSAttributedString(string: "Flips: \(flipCount)", attributes: attributes)
     flipCountLabel.attributedText = attributedString
     }
     }*/
    
    @IBOutlet private weak var flipCountLabel: UILabel!//{
    //didSet{
    //updateFlipCountLabel()
    //}
    //} //the ! is super important - side effect is that it isn't initialized.
    
    @IBOutlet private var cardButtons: [UIButton]!
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print ("chosen card was not in cardButtons")
        }
    }
    
    
    let backgroundColors = [#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1),#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1),#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1),#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1),#colorLiteral(red: 0.3098039329, green: 0.2039215714, blue: 0.03921568766, alpha: 1)]
    let cardColors = [#colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1),#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1),#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)]
    let textColors = [#colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1),#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1),#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1),#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)]
    
    override func awakeFromNib(){
        self.view.backgroundColor = backgroundColors[themeNumber]
        flipCountLabel.text = "Score: \(game.flipCount)"
        flipCountLabel.textColor = cardColors[themeNumber]
        //newGameButton.backgroundColor = cardColors[themeNumber]
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.711981833, blue: 0.1608580947, alpha: 0) : cardColors[themeNumber]
        }
    }
    
    
    @IBAction func newGame(_ sender: UIButton) {
        //game.invalidateTimer()
        game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
        themeNumber = arrayOfThemes.count.arc4random
        cardLabelsArray = arrayOfThemes[themeNumber]
        updateViewFromModel()
    }
    
    
    
    
    private func updateViewFromModel(){
        flipCountLabel.text = "Score: \(game.flipCount)"
        flipCountLabel.textColor = cardColors[themeNumber]
        //self.newGameButton.backgroundColor = cardColors[themeNumber]
        //newGame.background = cardColors[themeNumber]
        //newGame.setTitleColor(backgroundColors[themeNumber], for: UIControlState(rawValue: UIControlState.RawValue(FP_NORMAL)))
        self.view.backgroundColor = backgroundColors[themeNumber]
        
        
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControlState.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: UIControlState.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.711981833, blue: 0.1608580947, alpha: 0) : cardColors[themeNumber] //if card.isMatched --> the color is clear. Otherwise  it is orange. This is a sneaky way to do an if statement.
            }
        }
    }
    
    
    
    
    private var cardLabelDictionary = [Card:String]() //quick syntax for dictionaries
    
    private var halloweenTheme = ["👻","🎃","🐙","🐌", "👹", "🧟", "🧙", "🧞", "🧛‍♂️", "🐘"]
    private var xmasTheme = ["🤶🏻","🎅🏻", "🎄", "☃️", "❄️", "🏔","⛷", "🏂", "🎿", "🎅🏿"]
    private var waterTheme = ["🤽🏻‍♀️", "🏊‍♀️", "㊌", "🌊", "🏄🏻‍♂️", "🐃", "🍉", "🔫", "🚣🏿‍♂️", "🏄🏻‍♀️"]
    private var faceTheme = ["☺️","😊","😍", "😜", "🤓", "🙄", "🤯", "🤥", "🤗", "😶"]
    private var familyTheme = ["👪", "👨‍👩‍👧", "👨‍👩‍👧‍👦", "👨‍👩‍👦‍👦", "👨‍👩‍👧‍👧", "👩‍👦", "👩‍👧", "👩‍👧‍👦", "👩‍👦‍👦", "👩‍👧‍👧", "👨‍👦", "👨‍👧", "👨‍👧‍👦", "👨‍👦‍👦", "👨‍👧‍👧"]
    private var animalTheme = ["🐶", "🐱", "🐭","🐹","🐰","🦊","🐻","🐼","🐨","🐯","🦁","🐮","🐷"]
    
    
    
    
    lazy private var arrayOfThemes = [halloweenTheme, xmasTheme, waterTheme, faceTheme, familyTheme, animalTheme]
    
    
    
    lazy private var cardLabelsArray = arrayOfThemes[themeNumber]
    private func emoji (for card: Card) -> String {
        if cardLabelDictionary[card] == nil, cardLabelsArray.count > 0 {
            cardLabelDictionary[card] = cardLabelsArray.remove(at: cardLabelsArray.count.arc4random)
        }
        return cardLabelDictionary[card] ?? "?" // this = if emoji[card.identifier] != nil { return emoji[card.identifier]! } else {return "?"}
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}

