# Swift wrapper for the GNU Multiple Precision Arithmetic Library.

This project is a work in progress. Currently integer and some floating-point functions are implemented.

## Install
### Requirements
#### [GMP](//gmplib.org)
Currently libgmp.a 6.1.1 is included. You can rebuild it using the [GMP iOS Builder](//github.com/NeoTeo/gmp-ios-builder). 
#### Swift Package Manager
##### Note: Currently SPM only supports macOS.
Add the following to your pROject's package definition in the Package.swift file:

    dependencies: [ .Package(url: "https://github.com/NeoTeo/SwiftGMP", majorVersion: 0) ]

Then either build the project from the command line with:

    swift build -Xlinker -LPackages/GMPLib-0.1.3/macosx/

or generate an xcode project with swift package

    swift package generate-xcodeproj -Xlinker -LPackages/GMPLib-0.1.3/macosx/

Also you can run tests with:

`swift test -Xlinker -LPackages/GMPLib-0.1.3/macosx/

##### You will then need to add frameworks to your own Xcode project:  
1.  Select your target's Build Phases tab.  
2.  Select the Link Binary With Libraries, click the + and then Add Other... buttons.  
3.  Navigate to the Carthage/Build/Mac directory in your project root and select the SwiftGMP.framework.  
In case of a code signing error, select the target's Build Settings tab make sure the "Code Signing Identity" is either a valid identity or "Don't Code Sign".

#### Swift 3
This is part of Xcode 8.

## Usage

A full set of examples can be found in our [test suite](//github.com/NeoTeo/SwiftGMP/tree/master/SwiftGMPTests).

	import SwiftGMP
	
	let s2d = SwiftGMP.GMPDouble("12356789123456789.9876")
	let d2d = SwiftGMP.GMPDouble(12345.678)
	print(String(s2d + d2d))

### Example projects
*  [SwiftBase58](//github.com/NeoTeo/SwiftBase58)

## Contribute

Contributions are welcome! Check out [the issues](//github.com/NeoTeo/SwiftGMP/issues).

## License

GMP follows the  [GNU LGPL v3](//www.gnu.org/licenses/lgpl.html) and [GNU GPL v2](//www.gnu.org/licenses/gpl-2.0.html) licenses. This project has an additional [MIT](//opensource.org/licenses/MIT) license.
