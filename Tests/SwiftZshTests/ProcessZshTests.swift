//
//  ProcessZshTests.swift
//  
//
//  Created by Benjamin Spratling on 1/18/23.
//

import XCTest
import SwiftZsh

final class ProcessZshTests: XCTestCase {

	func testCallingSwiftVersion()async throws {
		let output = try await Process.zsh("swift -version")
		XCTAssertTrue(output.contains("Swift version"))//somewhere in there
	}

}
