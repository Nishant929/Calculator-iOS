//
//  ViewController.swift
//  Calculator
//
//  Created by Nishant Hooda on 19/06/17.
//  Copyright © 2017 digix. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private var display: UILabel!
    @IBOutlet private var sequenceOfOperations: UILabel!
    
    private var userInTheMiddleOfTyping = false
    
    @IBAction private func buttonPressed(_ sender: UIButton) {
        let digit = sender.currentTitle!
        let currentlyTextInDisplay = display.text!
        if userInTheMiddleOfTyping  {
            if digit == "." {
                if !(display.text?.contains("."))! {
                    display.text = currentlyTextInDisplay + digit
                    sequenceOfOperations.text?.append(digit)
                }
            }
            else {
                 display.text = currentlyTextInDisplay + digit
                 sequenceOfOperations.text?.append(digit)
            }
            
        } else {
            display.text! = digit
            sequenceOfOperations.text?.append(digit)
        }
        userInTheMiddleOfTyping = true
    }
    
    private var displayValue: Double {
       get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userInTheMiddleOfTyping {
            if Double(display.text!) == nil {
                brain.setOperand(operand: 0.0)
            }
            else {
                brain.setOperand(operand: displayValue)
            }
            userInTheMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(symbol: mathematicalSymbol)
          /*  if mathematicalSymbol == "±" {
                let token = sequenceOfOperations.text?.characters.index(of: mathematicalSymbol[mathematicalSymbol.characters.startIndex])
                let indexRangeOfOperand = sequenceOfOperations.text?.range(of: String(brain.signChange), options: .backwards)
                if brain.signChange > 0 {
                    sequenceOfOperations.text?.replaceSubrange(indexRangeOfOperand!, with: "(-\(brain.signChange))")
                    sequenceOfOperations.text?.remove(at: token!)
                }
            }*/
            sequenceOfOperations.text?.append(mathematicalSymbol)
        }
            displayValue = brain.result
    }
    
    @IBAction func clearDisplay(_ sender: UIButton) {
        display.text = "0"
        sequenceOfOperations.text = " "
    }
    
    
}



