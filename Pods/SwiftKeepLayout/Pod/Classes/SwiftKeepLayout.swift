//
//  test.swift
//  Pods
//
//  Created by Tancrède Chazallet on 30/03/2016.
//
//

public extension KeepAttribute {
	private func makeKeepValue(any: Any) -> KeepValue {
		switch any {
		case let newInt as Int:
			return KeepValueMake(CGFloat(newInt), KeepPriorityRequired)
		case let newDouble as Double:
			return KeepValueMake(CGFloat(newDouble), KeepPriorityRequired)
		case let newTupleIntInt as (Int, Int):
			return KeepValueMake(CGFloat(newTupleIntInt.0), Float(newTupleIntInt.1))
		case let newTupleDoubleDouble as (Double, Double):
			return KeepValueMake(CGFloat(newTupleDoubleDouble.0), Float(newTupleDoubleDouble.1))
		case let newTupleIntDouble as (Int, Double):
			return KeepValueMake(CGFloat(newTupleIntDouble.0), Float(newTupleIntDouble.1))
		case let newTupleDoubleInt as (Double, Int):
			return KeepValueMake(CGFloat(newTupleDoubleInt.0), Float(newTupleDoubleInt.1))
		default:
			assert(false, "Value given into vEqual isn't managed, KeepNone given")
			return KeepNone
		}
	}
	
	public var vEqual: Any {
		get {
			return self.equal
		}
		set(newValue) {
			self.equal = makeKeepValue(newValue)
		}
	}
	
	public var vMin: Any {
		get {
			return self.min
		}
		set(newValue) {
			self.min = makeKeepValue(newValue)
		}
	}
	
	public var vMax: Any {
		get {
			return self.max
		}
		set(newValue) {
			self.max = makeKeepValue(newValue)
		}
	}
}