//
//  String+escapingIllegalZshCharacters.swift
//  
//
//  Created by Benjamin Spratling on 1/18/23.
//

import Foundation

extension String {
	
	///prefixes characters in .illegalZshCharacters with a \
	var escapingIllegalZshCharacters:String {
		var finalString = self
		//iterate backwards, replacing illegal characters with \ then that character
		var cursor = finalString.endIndex
		while cursor > finalString.startIndex
				,let foundRange = finalString.rangeOfCharacter(from: .illegalZshCharacters, options:[.backwards], range: finalString.startIndex..<cursor) {
			finalString.insert("\\", at: foundRange.lowerBound)
			cursor = foundRange.lowerBound
		}
		return finalString
	}
}


extension CharacterSet {
	///characters which cannot be typed into zsh without
	static let illegalZshCharacters:CharacterSet = CharacterSet(charactersIn: "!#$^&*?[(){}<>~;'\"`|=\\ \t\n")
	
}
