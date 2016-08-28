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
    private var engine = CalcEngine()
    
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
    @IBAction func clearAll(sender: UIButton) {
        engine.clearContents()
        displayValue = 0.0;
        userIsInTheMiddleOfTyping = false
    }
    
    //dot
    @IBAction func dotButton(sender: UIButton) {
        if(display.text!.containsString(".")){
            return
        }
        display.text! = display.text! + "."
        userIsInTheMiddleOfTyping = true
    }
    
    
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

