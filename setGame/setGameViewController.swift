//
//  setViewController.swift
//  setGame
//
//  Created by Abram Himmer on 6/1/18.
//  Copyright © 2018 Abram Himmer. All rights reserved.
//

import UIKit

class setGameViewController: UIViewController {
    
    
    var game = SetGame()
    
    @IBOutlet weak var setGameView: SetGameView! {
        didSet {
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeThreeMore))
            swipe.direction = [.up,.down]
            setGameView.addGestureRecognizer(swipe)
            
            let rotate = UIRotationGestureRecognizer(target: self, action: #selector(shuffleDeck))
            setGameView.addGestureRecognizer(rotate)
        }
    }
    
    @objc func swipeThreeMore () {
        game.deal3Cards()
        updateUi()
    }
    
    @objc func shuffleDeck(){
        game.shuffleCards()
        updateUi()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //startTimer()
        updateUi()
    }
    
    @IBAction func dealThree(_ sender: UIButton) {
        game.deal3Cards()
        updateUi()
    }
    
    @IBOutlet weak var deckButton: UIButton!
    
    @IBAction func newGame(_ sender: UIButton) {
        game = SetGame()
        updateUi()
    }
    
    
    @objc func tapCard(tap: UITapGestureRecognizer) {
        if let view = tap.view as? SetCardView{
            if let index = setGameView.subviews.index(of: view) {
                game.selectCard(at: index)
            }
        }
        updateUi()
    }
    
    @IBAction func p2Turn(_ sender: UIButton) {
        game.player2TakeTurn()
        updateUi()
    }
    @IBAction func p1Turn(_ sender: UIButton) {
        game.player1TakeTurn()
        updateUi()
    }
    
    @IBOutlet weak var p1TurnLabel: UIButton!
    @IBOutlet weak var p2TurnLabel: UIButton!
    @IBOutlet weak var p1Score: UILabel!
    @IBOutlet weak var p2Score: UILabel!
    
    @IBAction func hintTap(_ sender: UIButton) {
        game.giveHint()
        updateUi()
    }
    
    func updateUi(){
        p1Score.text = "P1: \(game.p1Score)"
        p2Score.text = "P2: \(game.p2Score)"
        drawPlayerButtonBorders()
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.6,
            delay: 0,
            options: [],
            animations: {self.updateSubviewCount()}
        )
        //updateSubviewCount()
        assignAttributes()
        
    }
    
    func drawPlayerButtonBorders(){
        if game.p1Bool {
            p1TurnLabel.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        } else {
            p1TurnLabel.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        if game.p2Bool {
            p2TurnLabel.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        } else {
            p2TurnLabel.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
    
    lazy var animator = UIDynamicAnimator(referenceView: setGameView)
   
    lazy var collisionBehavior: UICollisionBehavior = {
        let behavior = UICollisionBehavior()
        behavior.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(behavior)
        return behavior
    }()
    
    func updateSubviewCount () {
        while game.cardsInPlay.count > setGameView.subviews.count {
            let deckFrame: CGRect = { () -> CGRect? in
                var deckFrame = self.deckButton.superview?.convert(deckButton.frame, to: nil)
                
                if deckFrame == CGRect(x: 117.0, y: 0.0, width: 109.0, height: 36.0) {
                    deckFrame = CGRect(x: (self.setGameView.superview?.bounds.width)!/2, y: (self.setGameView.superview?.bounds.height)!, width: 109.0, height: 36.0)
                }
                return deckFrame
                }()!
                
            
                print(deckFrame)
                let view = SetCardView(frame: deckFrame)
                let tap = UITapGestureRecognizer(target: self, action: #selector(tapCard(tap:)))
                view.addGestureRecognizer(tap)
                view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
                setGameView.addSubview(view)
            
        }
        while game.cardsInPlay.count < setGameView.subviews.count {
            let deckFrame = deckButton.convert(self.deckButton.frame, to: nil)
            print (deckFrame)
            setGameView.subviews.last?.removeFromSuperview()
        }
    }
    
    
    func assignAttributes(){
        for i in 0 ..< game.cardsInPlay.count{
            let card = game.cardsInPlay[i]
            let view = setGameView.subviews[i] as! SetCardView
            view.color = card.color.rawValue
            view.number = card.number.rawValue
            view.shape = card.shape.rawValue
            view.shade = card.shade.rawValue
            view.border = borderGetter(card: card)
            
        }
    }
    
    private func borderGetter(card: SetCard) -> String {
        if game.hintCards.contains(card) {
            return "hinted"
        } else if game.mismatchedCards.contains(card) {
            return "mismatched"
        } else if game.matchedCards.contains(card), game.selectedCards.contains(card) {
            return "matched"
        } else if game.selectedCards.contains(card) {
            return "selected"
        } else {
            return "untouched"
        }
    }
}

extension CGFloat {
    var arc4random: CGFloat {
        if self > 0 {
            return CGFloat(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -CGFloat(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
