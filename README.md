# SwiftZsh
 Swift async wrapper for zsh commands sent to Process


## Overview

This package makes it easy to call zsh command line arguments interfacing with both `async` and `throws` in Swift, wrapping up the output as a String

```swift
let output:String = try await Process.zsh("swift -version")
``` 

If all goes well, the output is a `String`, for example:
```
swift-driver version: 1.62.15 Apple Swift version 5.7.2 (swiftlang-5.7.2.135.5 clang-1400.0.29.51)
Target: arm64-apple-macosx13.0
```

If the process does not exit normally, it throws a `ProcessError` with forwarding the `terminationStatus` and `output`.


## pwd

To make your commands relative to a specific directory, pass in the current working directory in the optional `pwd:` argument.

```swift
import Foundation
import System

let pwd:FilePath = ... 
let output:String = try await Process.zsh("swift -version", pwd:pwd)
``` 


## Command arguments interpolation

The String literal you input into the `.zsh( )` method should be exactly what you would type into the command line.  In cases where you want to interpolate other Strings as arguments which need escaping, the ZshCommand interpolation will do that for you, leaving other types intact.

So the String argument this example:

```swift
let commitMessage:String = "WIP.  I'm still \"testing\" it."
let output = Process.zsh("git commit -m \(commitMessage)")
```
 
 is escaped to produce the same output as if you had typed:
 
 ```swift
let output = Process.zsh("git commit -m WIP.\\ \\ I\\'m\\ still\\ \\\"testing\\\"\\ it.")
```

While other variables are passed through as is:

```swift
let level:Int = 5
let output = Process.zsh("echo \(level)")
```

In this example, the output would be `5`.


### Verbatim strings

If your string already has proper escaping, you can turn off the escaping by using the argument label `varbatim:`.

```swift
let alreadyEscapedString:String = "WIP.\\ \\ I\\'m\\ still\\ \\\"testing\\\"\\ it."
let output = Process.zsh("git commit -m \(verbatim:alreadyEscapedString)")
```

### Bool

For the special case of booleans, many different apps interpret the format differently, so there is a `BoolFormat` option available

```swift
let shouldIStay:Bool = false
let output = Process.zsh("git commit -m \(verbatim:alreadyEscapedString)")
```


## Progress

I may be able to relax the version restrictions and support earlier versions by about a year.

I've tested only the most basic strings for escaping support.  There are many complexities of argument formatting which escape me.

Should more complex objects also receive special handling?  And perhaps only recognized POD types, like ints and floats should get no escaping?

Is there a way to send the arguments directly, without requiring us to actually do the interpolation?

Should both standardoutput and standard error both be sent into the same pipe?

Should we add support for interactive streaming?


