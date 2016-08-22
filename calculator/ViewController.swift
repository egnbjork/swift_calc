//
//  ViewController.swift
//  calculator
//
//  Created by Yevgen Berberyan on 8/22/16.
//  Copyright © 2016 Yevgen Berberyan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //Mark: Display output
    @IBOutlet weak var display: UILabel!
    
    //MARK: options
    var userIsInTheMiddleOfTyping = false
    
    //MARK: Number buttons action
    @IBAction func touchDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        let textCurrentlyOnDisplay = display.text!
        if(userIsInTheMiddleOfTyping){
            display.text = textCurrentlyOnDisplay + digit
        } else if(Int(digit) == 0){}
        else{
            display.text = digit
            userIsInTheMiddleOfTyping = true
        }
             }
    
    //MARK: Clear button
    @IBAction func clearButton(sender: UIButton) {
        display.text = String(0)
        userIsInTheMiddleOfTyping = false;
    }
}

