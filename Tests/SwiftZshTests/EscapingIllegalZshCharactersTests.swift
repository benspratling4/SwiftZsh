//
//  IllegalCharacterTests.swift
//  
//
//  Created by Benjamin Spratling on 1/18/23.
//

import XCTest
@testable import SwiftZsh



final class EscapingIllegalZshCharactersTests: XCTestCase {

	func testSpace() {
		let output = "something else".escapingIllegalZshCharacters
		XCTAssertEqual(output, "something\\ else")
	}
	
	func testTwoSpaces() {
		let output = "something  else".escapingIllegalZshCharacters
		XCTAssertEqual(output, "something\\ \\ else")
	}
	
	func testLeadingSpace() {
		let output = " something else".escapingIllegalZshCharacters
		XCTAssertEqual(output, "\\ something\\ else")
	}
	
	func testEscapingEscapes() {
		let output = "something\\else".escapingIllegalZshCharacters
		XCTAssertEqual(output, "something\\\\else")
	}
	
}
