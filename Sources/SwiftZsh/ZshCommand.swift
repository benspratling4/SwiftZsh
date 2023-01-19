//
//  ZshCommand.swift
//  
//
//  Created by Benjamin Spratling on 1/18/23.
//

import Foundation


///a custom string interpolation for substituting variables into command line stuff
///Just type a string literal anywhere you get a ZshCommand, and any strings you put in \(   ) will get escaping applied automatically
public struct ZshCommand : ExpressibleByStringInterpolation, CustomStringConvertible {
	
	var stringInterpolation: ZshInterpolation
	
	//MARK: - ExpressibleByStringLiteral
	
	public init(stringLiteral value: String) {
		var interpolation = ZshInterpolation(literalCapacity: 1, interpolationCount: 0)
		interpolation.appendLiteral(value)
		self.init(stringInterpolation: interpolation)
	}
	
	//MARK: - ExpressibleByStringInterpolation
	
	public init(stringInterpolation: ZshInterpolation) {
		self.stringInterpolation = stringInterpolation
	}
	
	
	//MARK: - CustomStringConvertible
	
	public var description: String {
		var final:String = ""
		for component in stringInterpolation.components {
			switch component {
			case .literal(let string):
				final.append(string)
			case .string(let string):
				final.append(string.escapingIllegalZshCharacters)
			case .other(let any):
				final.append(String(describing: any))
			case .bool(let boolValue, let boolFormat):
				final.append(boolFormat.formatted(boolValue))
			}
		}
		return final
	}
	
}


public struct ZshInterpolation : StringInterpolationProtocol {
	
	enum Component {
		case literal(String)
		case string(String)	//may need escaping
		case bool(Bool, BoolFormat)
		case other(Any)	//probably doesn't need escaping
		//case argument(String)	//not yet well-considered
	}
	
	var components:[Component] = []
	
	//MARK: - StringInterpolationProtocol
	
	public init(literalCapacity: Int, interpolationCount: Int) {
		components.reserveCapacity(literalCapacity + interpolationCount)
	}
	
	
	public mutating func appendLiteral(_ literal: String) {
		components.append(.literal(literal))
	}
	
	//these methods are assumed by the compiler, but not explicitly listed in the protocol
	
	public mutating func appendInterpolation(_ value:String) {
		components.append(.string(value))
	}
	
	public mutating func appendInterpolation(verbatim value:String) {
		components.append(.literal(value))
	}
	
	/* This is not yet well considered
	public mutating func appendInterpolation(`$` argName:String) {
		//TODO: write me
	}
	*/
	
	public mutating func appendInterpolation(_ value:Bool, format:BoolFormat = .integer) {
		components.append(.bool(value, format))
	}
	
	//catch all for other types
	public mutating func appendInterpolation(_ value:Any) {
		components.append(.other(value))
	}
	
	
	public enum BoolFormat {
		///0 for false, 1 for true
		case integer
		
		///true for true, false for false
		case spellOut
		
		///True for true, False for false
		case capitalized
		
		///TRUE for true, FALSE for false
		case allCaps
		
		
		func formatted(_ value:Bool)->String {
			switch self {
			case .allCaps:
				return value ? "TRUE" : "FALSE"
			case .capitalized:
				return value ? "True" : "False"
			case .spellOut:
				return value ? "true" : "false"
			case .integer:
				return value ? "1" : "0"
			}
		}
		
	}
	
}



