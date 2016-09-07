//
//  CalcEngine.swift
//  calculator
//
//  Created by Yevgen Berberyan on 8/25/16.
//  Copyright © 2016 Yevgen Berberyan. All rights reserved.
//

import Foundation

class CalcEngine{
    
    private var accumulator = 0.0
    private var lastOperation:PendingBinaryOperationInfo? = nil
    private var description = ""
    
    var isPartialResult: Bool{
        get{
            if pending != nil{
                return true
            }
            else{
                return false
            }
        }
    }
    
    private func setDescription(input:Double){
        
        if description.hasSuffix((" = ")){ //removes description when new number is entered after equality sign
            description = ""
        }
        
        description += String(input)
        
        if(input - floor(input) >= 0){ //takes out floating zeros from doubles
            description.removeRange((description.endIndex.advancedBy(-2) ..< description.endIndex))
        }
    }
    
    private func checkForDoubleEqualsSignInDescription(input:String) -> Bool{
        if(input.containsString("=") && description.hasSuffix(" = ")){ //prevent for several equals signs
            return false}
        else if(input.containsString("=")){ //changes equals with equals which can be changed with "..."
            description += " = "
            return false
        }
        return true
    }
    
    private func setDescription(input:String){
        
        if checkForDoubleEqualsSignInDescription(input) == false{
            return
        }
        
        if(description.hasSuffix(" = ") && //takes out equals when arithmetic operations are entered
            (input == "+" ||
                input == "-" ||
                input == "×" ||
                input == "÷")){
            description.removeRange(Range<String.Index>(description.endIndex.advancedBy(-3) ..< description.endIndex))
        }
        else if(input == "√" || input == "ln" || input == "lg"){
            if description.hasSuffix(" = "){
                description.removeRange(Range<String.Index>(description.endIndex.advancedBy(-3) ..< description.endIndex))
                description = input + "(" + description + ") = "
                return
            }
            else{
                description.insert(input.characters.first!, atIndex: description.endIndex.advancedBy(String(accumulator).characters.count*(-1)+2))
                return
            }
            
        }
        
        description = description + input
    }
    
    func getDescription()-> String{
        return description
    }
    
    func setOperand(operand: Double){
        setDescription(operand)
        accumulator = operand
    }
    
    var result: Double{
        get{
            return accumulator
        }
    }
    
    func performOperation(symbol: String){
        setDescription(symbol)
        if let operation = operations[symbol]{
            switch operation{
            case .Constant(let value):
                accumulator = value
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                executePendingBinaryOperation(symbol)
                pending = PendingBinaryOperationInfo(binaryFunc: function, firstOperand: accumulator)
            case .Equals:
                executePendingBinaryOperation(symbol)
            }
        }
    }
    
    private var operations: Dictionary<String, Operation> = [
        "π":    Operation.Constant(M_PI),
        "e":    Operation.Constant(M_E),
        "ln":   Operation.UnaryOperation({log($0)/log(M_E)}),
        "lg":   Operation.UnaryOperation({log2($0)}),
        "10ⁿ":  Operation.UnaryOperation({pow(10,$0)}),
        "x²":   Operation.UnaryOperation({pow($0,2)}),
        "1/x":  Operation.UnaryOperation({1/$0}),
        "√":    Operation.UnaryOperation(sqrt),
        "xⁿ":   Operation.BinaryOperation({pow($0,$1)}),
        "ⁿ√":   Operation.BinaryOperation({pow($0,1/$1)}),
        "×":    Operation.BinaryOperation({$0*$1}),
        "÷":    Operation.BinaryOperation({$0/$1}),
        "+":    Operation.BinaryOperation({$0+$1}),
        "−":    Operation.BinaryOperation({$0-$1}),
        "=":    Operation.Equals
    ]
    
    private enum Operation{
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double,Double) -> Double)
        case Equals
    }
    
    private var pending: PendingBinaryOperationInfo?
    
    private func executePendingBinaryOperation(symbol: String){
        if pending != nil {
            accumulator = pending!.binaryFunc(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    private struct PendingBinaryOperationInfo{
        var binaryFunc:(Double,Double)->Double
        var firstOperand: Double
    }
    
    func clearContents(){
        accumulator = 0.0
        pending = nil
        lastOperation = nil
        description = ""
    }
    
}