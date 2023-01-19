//
//  Process+zsh.swift
//  
//
//  Created by Benjamin Spratling on 1/18/23.
//

import Foundation
import System

extension Process {
	
	///asynchronously returns the results of executing a ZshCommand
	///A ZshCommand is a String literal of what you'd type into the zsh shell command line
	///And it uses a custom string interpolation which escapes interpolated String arguments
	public static func zsh(_ command:ZshCommand, pwd:FilePath? = nil)async throws -> String {
		let task = Process()
		task.launchPath = "/bin/zsh"
		task.arguments = ["-c", command.description]
		if let dir = pwd {
			task.currentDirectoryURL = URL(filePath: dir)
		}
		let pipe = Pipe()
		task.standardOutput = pipe
		task.standardError = pipe
		return try await withCheckedThrowingContinuation { continuation in
			task.terminationHandler = { process in
				let data = pipe.fileHandleForReading.readDataToEndOfFile()
				let output = String(data: data, encoding: .utf8) ?? ""
				
				switch process.terminationReason {
				case .uncaughtSignal:
					let error = ProcessError(terminationStatus: process.terminationStatus, output: output)
					continuation.resume(throwing:error)
				case .exit:
					continuation.resume(returning:output)
				@unknown default:
					//TODO: theoretically, this ought not to happen
					continuation.resume(returning:output)
				}
			}
			do {
				try task.run()
			} catch {
				continuation.resume(throwing:error)
			}
		}
	}
	
}

public struct ProcessError : Error {
	public var terminationStatus:Int32
	public var output:String
}
