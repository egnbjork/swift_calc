//
//  ViewController.swift
//  calculator
//
//  Created by Yevgen Berberyan on 8/22/16.
//  Copyright © 2016 Yevgen Berberyan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfTyping = false
    
    //MARK: Number buttons action
    @IBAction func touchDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping{
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        } else{
            display.text = digit
        }
        userIsInTheMiddleOfTyping = true
    }
    
    
    @IBAction func performOperation(sender: AnyObject) {
        if let mathematicalSymbol = sender.currentTitle{
            if mathematicalSymbol == "π" {
                display.text = String(M_PI)
            }
        }
        
    }
    
    
}

