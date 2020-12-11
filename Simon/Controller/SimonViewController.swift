//
//  SimonViewController.swift
//  Simon
//
//  Created by Brando Flores on 12/10/20.
//

import UIKit
import AVFoundation

class SimonViewController: UIViewController {
    
    var player: AVAudioPlayer?
    
    private var currentPlayer = 0
    private var scores = [0,0]
    
    private var sequenceIndex = 0
    private var colorSequence = [Int]()
    private var colorsToTap = [Int]()
    
    private var gameEnded = false
    
    @IBOutlet var coloredButtons: [CircularButton]!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet var playerLabels: [UILabel]!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actionButton.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        coloredButtons = coloredButtons.sorted() {
            $0.tag < $1.tag
        }
        playerLabels = playerLabels.sorted() {
            $0.tag < $1.tag
        }
        
        createNewGame()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameEnded {
            playMenuSound(soundFileName: "infoButtonSound")
            gameEnded = false
            createNewGame()
            fadeOutInfoLabel()
            fadeOutIconImage()
        }
    }
    
    func createNewGame() {
        colorSequence.removeAll()
        
        actionButton.setTitle("Start Game", for: .normal)
        infoLabel.text = "Press To Continue"
        actionButton.isEnabled = true
        disableColoredButtons()
        for button in coloredButtons {
            button.alpha = 0.5
        }
        
        currentPlayer = 0
        scores = [0,0]
        playerLabels[currentPlayer].alpha = 1.0
        playerLabels[1].alpha = 0.10
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
            actionButton.setTitle("Player \(currentPlayer + 1) Go!", for: .normal)
            enableColoredButtons()
        }
    }
    
    func flash(button: CircularButton) {
        // Just creates the animation to flash a button
        playMenuSound(soundFileName: "simonSound")
        UIView.animate(withDuration: 0.5) {
            button.alpha = 1.0
            button.alpha = 0.5
        } completion: { (Bool) in
            self.playSequence()
        }
        
    }
    
    func endGame() {
        let message = currentPlayer == 0 ? "Player 2 Wins!" : "Player 1 Wins!"
        switchPlayers()
        actionButton.setTitle(message, for: .normal)
        infoLabel.text = "Press To Play Again"
        fadeInInfoLabel()
        gameEnded = true
    }
    
    @IBAction func coloredButtonsPressed(_ sender: CircularButton) {

        // If user has pressed the correct button
        if sender.tag == colorsToTap.removeFirst() {
            playMenuSound(soundFileName: "simonSound")
        }
        else {
            iconImage.image = UIImage(named: "xmark")
            playMenuSound(soundFileName: "loseSound")
            fadeInIconImage()
            disableColoredButtons()
            endGame()
            return
        }
        
        // User has pressed the buttons in the correct sequence
        if colorsToTap.isEmpty {
            //enableColoredButtons()
            playMenuSound(soundFileName: "correctSound")
            iconImage.image = UIImage(named: "checkmark")
            fadeInIconImage()
            scores[currentPlayer] += 1
            switchPlayers()
            disableColoredButtons()
            actionButton.setTitle("Player \(currentPlayer + 1)'s Turn", for: .normal)
            
            fadeInInfoLabel()
            
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
    
    func fadeInInfoLabel() {
        UIView.animate(withDuration: 0.0, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.infoLabel.alpha = 0.0
        }, completion: {
            (finished: Bool) -> Void in
            
            //Once the label is completely invisible, set the text and fade it back in
            self.infoLabel.isHidden = false
            
            // Fade in
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                self.infoLabel.alpha = 1.0
            }, completion: nil)
        })
    }
    
    func fadeOutInfoLabel() {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.infoLabel.alpha = 0.0
        }, completion: {
            (finished: Bool) -> Void in
            
            //Once the label is completely invisible, set the text and fade it back in
            self.infoLabel.isHidden = true
            
        })
    }
    
    func fadeInIconImage() {
        UIView.animate(withDuration: 0.0, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.iconImage.alpha = 0.0
        }, completion: {
            (finished: Bool) -> Void in
            
            //Once the label is completely invisible, set the text and fade it back in
            self.iconImage.isHidden = false
            
            // Fade in
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                self.iconImage.alpha = 1.0
            }, completion: nil)
        })
    }
    
    func fadeOutIconImage() {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.iconImage.alpha = 0.0
        }, completion: {
            (finished: Bool) -> Void in
            
            //Once the label is completely invisible, set the text and fade it back in
            self.iconImage.isHidden = true
            
        })
    }
    
    @IBAction func actionButtonPressed(_ sender: UIButton) {
        // Disable all user interaction while game loads
        view.isUserInteractionEnabled = false
        playMenuSound(soundFileName: "infoButtonSound")
        fadeOutInfoLabel()
        fadeOutIconImage()
        sequenceIndex = 0
        actionButton.setTitle("Follow Simon!", for: .normal)
        actionButton.isEnabled = false
        
        addNewColor()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.playSequence()
        }
    }
    
    func playMenuSound(soundFileName: String) {
        guard let url = Bundle.main.url(forResource: soundFileName, withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            guard let player = player else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
}
