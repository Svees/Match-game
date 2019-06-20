//
//  ViewController.swift
//  MatchGame
//
//  Created by Svyald Bjorn on 14/06/2019.
//  Copyright © 2019 Svyald Bjorn. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var model = CardModel()
    var cardArray = [Card]()
    
    var firstFlippedCardIndex:IndexPath?
    
    var timer:Timer?
    var miliseconds:Float = 10 * 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardArray = model.getCards()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        timer = Timer.init(timeInterval: 0.001, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    @objc func timerElapsed() {
        
        miliseconds -= 1
        
        let seconds = String(format: "%.2f", miliseconds/1000)
        
        timerLabel.text = "Timer Remaining:\(seconds)"
        
        if miliseconds <= 0{
            timer?.invalidate()
            
            timerLabel.textColor = UIColor.red
            checkGameEnded()
            
            
        }
    }

    // MARK: - UICollectionView Protocol Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return cardArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath)
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if miliseconds <= 0{
            return
        }
        
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        
        let card = cardArray[indexPath.row]
        
        if card.isFlipped == false && card.isMatched == false{
            
            cell.flip()
            
            card.isFlipped = true
            
            if firstFlippedCardIndex == nil {
                
                firstFlippedCardIndex = indexPath
            }
        
        else {
            
            cell.flipback()
            
            card.isFlipped = false
        }
    }
}
    func checkForMatches(_ secondFlippedCardIndex:IndexPath){
        
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        let cardOne = cardArray[firstFlippedCardIndex!.row]
        let cardTwo = cardArray[secondFlippedCardIndex.row]
        
        if cardOne.imageName == cardTwo.imageName {
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            checkGameEnded()
        }
        else{
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            cardOneCell?.flipback()
            cardTwoCell?.flipback()
            
        }
        if cardOneCell == nil {
            collectionView.reloadItems(at: [firstFlippedCardIndex!])
        }
        
        firstFlippedCardIndex = nil
    }
    
    func checkGameEnded(){
        var isWon = true
        for card in cardArray {
            if card.isMatched == false {
                isWon = false
                break
            }
        }
        
        var title = ""
        var message = ""
        
        if isWon == true {
            if miliseconds > 0 {
                timer?.invalidate()
            }
            title = "Congratulation!"
            message = "You've won"

        }
        else{
            if miliseconds > 0 {
                return
            }
            title = "Game Over"
            message = "You've lost"
        }
        showAlert(title, message)
    }
    
    func showAlert(_ title:String, _ message:String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
    }
}
