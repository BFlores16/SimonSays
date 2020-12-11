//
//  SimonViewController.swift
//  Simon
//
//  Created by Brando Flores on 12/10/20.
//

import UIKit

class SimonViewController: UIViewController {

    private var currentPlayer = 0
    private var scores = [0,0]
    
    private var sequenceIndex = 0
    private var colorSequence = [Int]()
    private var colorsToTap = [Int]()
    
    private var gameEnded = false
    
    @IBOutlet var coloredButtons: [CircularButton]!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet var playerLabels: [UILabel]!
    @IBOutlet var scoreLabels: [UILabel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coloredButtons = coloredButtons.sorted() {
            $0.tag < $1.tag
        }
        playerLabels = playerLabels.sorted() {
            $0.tag < $1.tag
        }
        scoreLabels = scoreLabels.sorted() {
            $0.tag < $1.tag
        }
        createNewGame()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameEnded {
            gameEnded = false
            createNewGame()
        }
    }
    
    func createNewGame() {
        colorSequence.removeAll()
        
        actionButton.setTitle("Start Game", for: .normal)
        actionButton.isEnabled = true
        disableColoredButtons()
        for button in coloredButtons {
            button.alpha = 0.5
        }
        
        currentPlayer = 0
        scores = [0,0]
        playerLabels[currentPlayer].alpha = 1.0
        playerLabels[1].alpha = 0.10
        updateScoreLabels()
    }
    
    func updateScoreLabels() {
        for (index,label) in scoreLabels.enumerated() {
            label.text = "\(scores[index])"
        }
    }
    
    func switchPlayers() {
        playerLabels[currentPlayer].alpha = 0.10
        //playerLabels[currentPlayer].backgroundColor = UIColor.red
        // Switch the current player
        currentPlayer = currentPlayer == 0 ? 1 : 0
        playerLabels[currentPlayer].alpha = 1.0
        //playerLabels[currentPlayer].backgroundColor = UIColor.clear
    }
    
    func addNewColor() {
        // Generate a random number for Simon to press. The number represents
        // the button's tag
        colorSequence.append(Int(arc4random_uniform(UInt32(4))))
    }
    
    func playSequence() {
        if sequenceIndex < colorSequence.count {
            flash(button: coloredButtons[colorSequence[sequenceIndex]])
            sequenceIndex += 1
        }
        else {
            colorsToTap = colorSequence
            view.isUserInteractionEnabled = true
            actionButton.setTitle("Tap the circles", for: .normal)
            enableColoredButtons()
        }
    }
    
    func flash(button: CircularButton) {
        // Just creates the animation to flash a button
        UIView.animate(withDuration: 0.5) {
            button.alpha = 1.0
            button.alpha = 0.5
        } completion: { (Bool) in
            self.playSequence()
        }

    }
    
    func endGame() {
        let message = currentPlayer == 0 ? "Player 2 Wins!" : "Player 1 Wins!"
        actionButton.setTitle(message, for: .normal)
        gameEnded = true
    }
    
    @IBAction func coloredButtonsPressed(_ sender: CircularButton) {
        // If user has pressed the correct button
        if sender.tag == colorsToTap.removeFirst() {
            
        }
        else {
            disableColoredButtons()
            endGame()
            return
        }
        
        // User has pressed the buttons in the correct sequence
        if colorsToTap.isEmpty {
            enableColoredButtons()
            scores[currentPlayer] += 1
            updateScoreLabels()
            switchPlayers()
            actionButton.setTitle("Continue", for: .normal)
            actionButton.isEnabled = true
        }
    }
    
    private func enableColoredButtons() {
        for button in coloredButtons {
            button.isEnabled = true
        }
    }
    
    private func disableColoredButtons() {
        for button in coloredButtons {
            button.isEnabled = false
        }
    }
    
    @IBAction func actionButtonPressed(_ sender: UIButton) {
        // Disable all user interaction while game loads
        view.isUserInteractionEnabled = false
        
        sequenceIndex = 0
        actionButton.setTitle("Follow Simon!", for: .normal)
        actionButton.isEnabled = false
        
        addNewColor()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.playSequence()
        }
    }
    
    

}
