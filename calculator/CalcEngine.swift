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
    
    private var internalProgram = [AnyObject]()
    
    typealias PropertyList = AnyObject
    var program: PropertyList{
        get{
            return internalProgram
        }
        set{
            clearContents()
            if let arrayOfOps = newValue as? [AnyObject] {
                for op in arrayOfOps{
                    if let operand = op as? Double{
                        setOperand(operand)
                    } else if let operation = op as? String{
                        performOperation(operation)
                    }
                }
            }
        }
    }
    
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
    
    private func setDescription(input:AnyObject){
        if let operand = input as? Double{
            setDescription(operand)
        }else if let operation = input as? String{
            setDescription(operation)
        }
    }
        
    func getDescription()-> String{
        var description = " "
        for item in internalProgram{
            if let operand = item as? Double{
                //clears input if typed number comes after equality sign
                if let index = description.characters.indexOf("="){
                    if index != description.endIndex{
                        description.removeRange(description.startIndex ..< index.advancedBy(1))
                    }
                }
                //takes out floating zeros from doubles
                description += (operand - floor(operand) != 0) ? (String(operand)) : (String(Int(operand)))
            } else if let operation = item as? String{
                description += operation
            }
        }
        return description
    }
    
    func setOperand(operand: Double){
        accumulator = operand
        if((internalProgram.last as? Double) != nil){
            clearContents()
        }
        internalProgram.append(operand)
    }
    
    var result: Double{
        get{
            return accumulator
        }
    }
    
    func performOperation(symbol: String){
        //eliminate two operations one by one in stack
        if (((internalProgram.last as? String)?.hasSuffix("=")) != nil){
            internalProgram.removeLast()
        }
    
        internalProgram.append(symbol)
        
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
            if(pending?.firstOperand == accumulator){
                internalProgram.append(pending!.firstOperand)
            }
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
        internalProgram.removeAll()
    }
    
}