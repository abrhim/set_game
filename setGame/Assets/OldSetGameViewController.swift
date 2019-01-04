//
//  ViewController.swift
//  setGame
//
//  Created by Abram Himmer on 5/19/18.
//  Copyright © 2018 Abram Himmer. All rights reserved.
//

import UIKit

class OldSetGameViewController: UIViewController {
    
    //helper global variables
    var game = SetGame()
    private var cardDictionary = [SetCard:String]()

    var timeS: Int = 0 {
        didSet {
            updateUIfromModel()
        }
    }
    
    //UI variables
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet var UICards: [UIButton]!
    
    //get cards for UI
    func getCardsFromModel() -> [SetCard]{
        var tempArray = [SetCard]()
        for i in game.cardsInPlay.indices{
            tempArray.append(game.cardsInPlay[i])
        }
        return tempArray
    }
    
    //start the game:
    override func viewDidLoad() {
        super.viewDidLoad()
        startTimer()
        drawUICards()
    }
    
    var timerT = Timer()
    
    func startTimer () {
        self.timerT = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timeFunc), userInfo: nil, repeats: true)
    }

    // do the timer
    @objc func timeFunc (_ timer: Timer) {
        timeS += 1
    }
    
    @IBAction func newGameAction(_ sender: UIButton) {
        timeS = 0
        timerT.invalidate()
        game = SetGame()
        updateUIfromModel()
        startTimer()
        
    }
    
    
    @IBAction func touchCard(_ sender: UIButton) {
        if let index = UICards.index(of: sender) {
            game.selectCard(at: index)
        } else {
            print("That card doesn't exist!")
        }
        updateUIfromModel()
    }
    
    @IBAction func dealThreeMore(_ sender: UIButton) {
        game.deal3Cards()
        updateUIfromModel()
    }
    
    @IBAction func hintAction(_ sender: UIButton) {
        game.giveHint()
        updateUIfromModel()
    }

    
    func updateUIfromModel () {
        timeLabel.text = "Time: \(timeS)s"
        scoreLabel.text = "Score: \(game.score)"
        drawUICards()
    }
    
    //create attributedString attributes
    let square = "■"
    let circle = "●"
    let triangle = "▲"
    
    
    //label all the cards
    func drawUICards(){
        for i in 0..<UICards.count {
            if i >= game.cardsInPlay.count {
                UICards[i].backgroundColor = UIColor.clear
                UICards[i].setAttributedTitle(NSAttributedString(string: ""), for: UIControlState.normal)
                UICards[i].layer.borderColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 0)
                UICards[i].layer.borderWidth = 0
            } else {
                var stringTitle = ""
                var color = UIColor.gray
                var attributes = [NSAttributedStringKey:Any]()
                if  !game.matchedCards.contains(game.cardsInPlay[i]){
                    //set color of each card
                    switch game.cardsInPlay[i].color{
                    //case .one : color = (UIColor.green *)colorWithAlphaComponent:(0.0)alpha
                    case .one : color =  UIColor.green
                    case .two : color = UIColor.red
                    case .three : color = UIColor.purple
                    }
                    
                    //set color shading of each card
                    switch game.cardsInPlay[i].shade {
                    case .one : attributes[.strokeWidth] = 4.0
                    case .two : color = color.withAlphaComponent(0.2)
                    case .three : color = color.withAlphaComponent(1.0)
                    }
                    
                    //setting the shape and number of shapes in each card
                    switch game.cardsInPlay[i].shape{
                    case .one:
                        switch game.cardsInPlay[i].number {
                        case .one: stringTitle = triangle
                        case .two: stringTitle = triangle*2
                        case .three: stringTitle = triangle*3
                        }
                    case .two:
                        switch game.cardsInPlay[i].number{
                        case .one: stringTitle = circle
                        case .two: stringTitle = circle*2
                        case .three: stringTitle = circle*3
                        }
                        
                    case .three:
                        switch game.cardsInPlay[i].number{
                        case .one: stringTitle = square
                        case .two: stringTitle = square*2
                        case .three: stringTitle = square*3
                        }
                    }
                    
                    
                    if game.selectedCards.contains(game.cardsInPlay[i]) {
                        if game.selectedCards.count == 3 {
                            UICards[i].layer.borderWidth = 3.0
                            UICards[i].layer.borderColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                        } else {
                            UICards[i].layer.borderWidth = 3.0
                            UICards[i].layer.borderColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                        }
                    } else {
                        UICards[i].layer.borderColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 0)
                        UICards[i].layer.borderWidth = 0
                    }
                    
                    attributes[.foregroundColor] = color
                    let title = NSAttributedString(string: stringTitle, attributes: attributes)
                    UICards[i].setAttributedTitle(title, for: UIControlState.normal)
                    UICards[i].backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    
                    if game.hintCards.contains(game.cardsInPlay[i]) {
                        UICards[i].layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
                        UICards[i].layer.borderWidth = 3.0
                    }
                } else {
                    if game.matchedCards.contains(game.cardsInPlay[i]), game.selectedCards.contains(game.cardsInPlay[i]) {
                        UICards[i].layer.borderColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
                        UICards[i].layer.borderWidth = 3.0
                    } else {
                        UICards[i].layer.borderColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 0)
                        UICards[i].layer.borderWidth = 0
                        UICards[i].setAttributedTitle(NSAttributedString(string: ""), for: UIControlState.normal)
                        UICards[i].backgroundColor = UIColor.clear
                    }

                }
            }

        }
        
       
    }
}

extension String {
    static func * (left: String, right: Int) -> String {
        var result = ""
        for _ in 0..<right {
            result += left
        }
        return result
    }
}
