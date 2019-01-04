//
//  SetGameView.swift
//  setGame
//
//  Created by Abram Himmer on 6/1/18.
//  Copyright © 2018 Abram Himmer. All rights reserved.
//

import UIKit

class SetGameView: UIView {
    
    var grid = Grid(layout: .aspectRatio(8/5)) //TODO: make the aspect ration a constant
    
    //use property animator to move all of the cards to their new position. 
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let  frame2 = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        grid.cellCount = subviews.count //number of cards on the table
        grid.frame = frame2
        for i in 0..<subviews.count {
            let cardView = subviews[i] as? SetCardView
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: 1.0,
                delay: 0,
                options: [],
                animations: {
                    self.subviews[i].alpha = 0
                    self.subviews[i].frame = self.grid[i]!.insetBy(dx: self.grid[i]!.width/57.1666666667, dy: self.grid[i]!.height/35.7291666667)
                    self.subviews[i].alpha = 1
            },
            
                completion: { position in
                    if cardView?.faceUp == false {
                        UIView.transition(
                            with: self.subviews[i],
                            duration: 0.5,
                            options: [.transitionFlipFromLeft],
                            animations: {self.flipCard(card: cardView!)}
                        )
                    }
                }
            )
        }
    }
    private func flipCard(card: SetCardView){
        card.faceUp = true
    }
    
    private struct Constants {
        let aspectRatio: CGFloat = 166/99
        
    }
    
    

}


