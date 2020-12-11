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
    
    func createNewGame() {
        actionButton.setTitle("Start Game", for: .normal)
        
        for button in coloredButtons {
            button.alpha = 0.5
        }
    }
    
    @IBAction func coloredButtonsPressed(_ sender: CircularButton) {
        print("Button \(sender.tag) tapped")
    }
    @IBAction func actionButtonPressed(_ sender: UIButton) {
        print("action button")
    }
    

}
