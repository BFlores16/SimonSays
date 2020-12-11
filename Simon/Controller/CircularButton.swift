//
//  CircularButton.swift
//  Simon
//
//  Created by Brando Flores on 12/10/20.
//

import UIKit

class CircularButton: UIButton {

    override func awakeFromNib() {
        // Make the buttons circular. You could also use height but
        // because the buttons are square it doesnt matter
        layer.cornerRadius = frame.size.width/2
        // No sublayers are drawn behind the button to ensure it is circular
        layer.masksToBounds = true
    }

}
