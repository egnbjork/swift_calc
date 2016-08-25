//
//  ViewController.swift
//  calculator
//
//  Created by Yevgen Berberyan on 8/22/16.
//  Copyright © 2016 Yevgen Berberyan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet private weak var display: UILabel!
    
   private var userIsInTheMiddleOfTyping = false
    
    //MARK: Number buttons action
    @IBAction private func touchDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping{
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        } else{
            display.text = digit
        }
        userIsInTheMiddleOfTyping = true
    }
    
   private  var displayValue: Double {
        get{
            return Double(display.text!)!
        }
        set{
            display.text = String(newValue)
        }
    }
    
    private var engine = CalcEngine()
    
    @IBAction private func performOperation(sender: UIButton) {
        if userIsInTheMiddleOfTyping{
            engine.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle{
            engine.performOperation(mathematicalSymbol)
        }
        displayValue = engine.result
    }
}

