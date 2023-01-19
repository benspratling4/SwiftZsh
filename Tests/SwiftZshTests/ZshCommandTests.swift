//
//  CommandLineInterpolableTests.swift
//  
//
//  Created by Benjamin Spratling on 1/18/23.
//

import XCTest
import SwiftZsh

final class ZshCommandTests: XCTestCase {
	
	func takeCommandLine(_ message:ZshCommand)->String {
		message.description
	}
	
	func testNoArguments() {
		let output = takeCommandLine("simpleCommand")
		XCTAssertEqual(output, "simpleCommand")
	}
	
	func testSimpleEscaoed() {
		let argument = "argument with spaces"
		let output = takeCommandLine("swift \(argument)")
		XCTAssertEqual(output, "swift argument\\ with\\ spaces")
	}
	
	func testDigits() {
		let argument = 5
		let output = takeCommandLine("swift \(argument)")
		XCTAssertEqual(output, "swift 5")
	}
	
	func testBool() {
		let argument:Bool = true
		let output = takeCommandLine("swift \(argument)")
		XCTAssertEqual(output, "swift 1")
	}
	
	func testBoolFormat() {
		let argument:Bool = true
		let output = takeCommandLine("swift \(argument, format: .capitalized)")
		XCTAssertEqual(output, "swift True")
	}
	
}
