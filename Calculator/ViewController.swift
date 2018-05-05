//
//  ViewController.swift
//  Calculator
//
//  Created by Ahmed Al-Zahrani on 2018-03-06.
//  Copyright © 2018 Ahmed Al-Zahrani. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private var brain: CalculatorBrain = CalculatorBrain()
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    var userIsTyping = false
    var enteringFloat = false

    @IBAction func touchClear(_ sender: UIButton) {
        display.text = "0"
        userIsTyping = false
        enteringFloat = false
        if (brain.description != nil) {
            brain.description = " "
        }
        descriptionLabel.text = " "
    }
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
       // print("\(digit) was touched")
        
        if (digit == ".") {
            if (enteringFloat){
                return
            } else {
                enteringFloat = true
            }
        }
        
        if userIsTyping {
            let textCurrentlyInDisplay = display!.text!
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
            userIsTyping = true
        }
    }
    
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    // updates the UILabel based on the brain's description
    func updateDescriptionLabel() {
        if let description = brain.description{
            if (brain.resultIsPending) {
                descriptionLabel.text = description + "..."
            } else {
                descriptionLabel.text = description +  "= "
            }
        }
    }
    
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsTyping {
            // testing last UILabel req
            if (brain.description != nil && isBinary(operation: sender.currentTitle!)) {
                brain.description = " "
            }
            brain.setOperand(displayValue)
            userIsTyping = false
        }
        if let symbol = sender.currentTitle {
            brain.performOperation(symbol)
        }
        if let result = brain.result {
            displayValue = result
        }
        updateDescriptionLabel()
    }
    
    private func isBinary(operation: String) -> Bool {
        return operation == "+" || operation == "x" || operation == "÷" || operation == "-"
    }
}

