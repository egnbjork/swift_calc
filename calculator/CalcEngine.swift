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
    
    func setOperand(operand: Double){
        accumulator = operand
    }
    
    var result: Double{
        get{
            return accumulator
        }
    }
    
    func performOperation(symbol: String){
        if let operation = operations[symbol]{
            switch operation{
            case .Constant(let value):
                accumulator = value
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunc: function, firstOperand: accumulator)
            case .Equals:
                executePendingBinaryOperation()
                executeLastOperation()
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
    
    private func executePendingBinaryOperation(){
        if pending != nil {
            
            lastOperation = pending
            lastOperation!.firstOperand = accumulator
            
            accumulator = pending!.binaryFunc(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    private func executeLastOperation(){
        if (pending == nil && lastOperation != nil) {
            accumulator = lastOperation!.binaryFunc(lastOperation!.firstOperand, accumulator)
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
    }
    
}