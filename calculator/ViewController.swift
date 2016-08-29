//
//  ViewController.swift
//  calculator
//
//  Created by Yevgen Berberyan on 8/22/16.
//  Copyright © 2016 Yevgen Berberyan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var userIsInTheMiddleOfTyping = false
    private var engine = CalcEngine()
    
    private  var displayValue: Double {
        get{
            return Double(display.text!)!
        }
        set{
            let newValueInteger = Int(newValue)
            
            if(newValue - Double(newValueInteger) > 0){
                display.text = String(newValue)
            }
            else{
                display.text = String(newValueInteger);
            }
        }
    }

    @IBOutlet private weak var display: UILabel!
    
    //MARK: button actions
    
    //digits
    @IBAction private func touchDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfTyping{ //if not in the middle starts with zero
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        } else{
            display.text = digit
        }
        userIsInTheMiddleOfTyping = true
    }
    
    //AC
    @IBAction private func clearAll(sender: UIButton) {
        engine.clearContents()
        displayValue = 0.0;
        userIsInTheMiddleOfTyping = false
    }
    
    //backspace
    @IBAction private func backspace(sender: UIButton) {
        if(display.text!.characters.count == 1 ||
            display.text!.characters.count == 2 && display.text!.hasPrefix("-")){ //hide minus
            displayValue = 0
            userIsInTheMiddleOfTyping = false
        } else{
            display.text = display.text!.substringToIndex(display.text!.endIndex.predecessor())
        }
    }
    
    //change sign
    @IBAction func changeSignButton(sender: UIButton) {
        displayValue *= -1
    }
    
    //dot
    @IBAction private func dotButton(sender: UIButton) {
        if(display.text!.containsString(".")){
            return
        }
        display.text! = display.text! + "."
        userIsInTheMiddleOfTyping = true
    }
    
    //Mark: making math
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

