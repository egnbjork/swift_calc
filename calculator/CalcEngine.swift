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
    
    var operations: Dictionary<String, Operation> = [
        "π": Operation.Constant(M_PI),
        "e": Operation.Constant(M_E),
        "√": Operation.UnaryOperation(sqrt),
        "cos": Operation.UnaryOperation(cos),
        "×": Operation.BinaryOperation({$0*$1}),
        "÷": Operation.BinaryOperation({$0/$1}),
        "+": Operation.BinaryOperation({$0+$1}),
        "−": Operation.BinaryOperation({$0-$1}),
        "=": Operation.Equals
    ]
    
    enum Operation{
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
    
    struct PendingBinaryOperationInfo{
        var binaryFunc:(Double,Double)->Double
        var firstOperand: Double
    }
    
    var result: Double{
        get{
            return accumulator
        }
    }
}