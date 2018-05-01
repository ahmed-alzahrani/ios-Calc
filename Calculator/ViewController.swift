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
    var userIsTyping = false
    var enteringFloat = false
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        print("\(digit) was touched")
        
        
        if (digit == "." && enteringFloat){
            return
        }
        
        if (digit == "C"){
            display.text = "0"
            userIsTyping = false
            enteringFloat = false
            return
        }
        
        
        if userIsTyping {
            let textCurrentlyInDisplay = display!.text!
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
            userIsTyping = true
        }
        if (digit == ".") {
            enteringFloat = true
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
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsTyping {
            brain.setOperand(displayValue)
            userIsTyping = false
        }
        if let symbol = sender.currentTitle {
            brain.performOperation(symbol)
        }
        if let result = brain.result {
            displayValue = result
        }
    }
}

