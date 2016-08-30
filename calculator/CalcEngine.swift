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
    
    func setOperand(operand: Double){
        accumulator = operand
    }
    
    
    
    private var operations: Dictionary<String, Operation> = [
        "π": Operation.Constant(M_PI),
        "10ⁿ": Operation.UnaryOperation({pow(10,$0)}),
        "x²": Operation.UnaryOperation({pow($0,2)}),
        "1/x": Operation.UnaryOperation({1/$0}),
        "√": Operation.UnaryOperation(sqrt),
        "xⁿ": Operation.BinaryOperation({pow($0,$1)}),
        "ⁿ√": Operation.BinaryOperation({pow($0,1/$1)}),
        "×": Operation.BinaryOperation({$0*$1}),
        "÷": Operation.BinaryOperation({$0/$1}),
        "+": Operation.BinaryOperation({$0+$1}),
        "−": Operation.BinaryOperation({$0-$1}),
        "=": Operation.Equals
    ]
    
    private enum Operation{
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double,Double) -> Double)
        case Equals
    }
    
    private var pending: PendingBinaryOperationInfo?
    
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
            }
        }
    }
    
    private func executePendingBinaryOperation(){
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
    }
    
    var result: Double{
        get{
            return accumulator
        }
    }
}