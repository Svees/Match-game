//
//  CardModel.swift
//  MatchGame
//
//  Created by Svyald Bjorn on 14/06/2019.
//  Copyright © 2019 Svyald Bjorn. All rights reserved.
//

import Foundation

class CardModel {
    
   
    func getCards() -> [Card] {
        
        
        var generatedCardsArray = [Card]()
        
        
        for _ in 1...8 {
            
            
            let randomNumber = arc4random_uniform(13) + 1
            
            
            print(randomNumber)
            
            
            let cardOne = Card()
            cardOne.imageName = "card\(randomNumber)"
            
            generatedCardsArray.append(cardOne)
            
            
            let cardTwo = Card()
            cardTwo.imageName = "card\(randomNumber)"
            
            generatedCardsArray.append(cardTwo)
            
            
        }
        
        
        
        
        
        return generatedCardsArray
    }
}
