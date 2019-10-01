# Notes
Notes demo app

### Author
Sergey Korotkevich

### Description
This is a simple Notes app using SwiftUI.  
Worth mentioning that couple of workarounds were made, for example multiline editable text has been implemented 
as UIViewRepresentable for representing UIKit UITextView becasue SwiftUI's Text is not editable and TextField is not multiline.
Also there is a fix for NavigationLink Back Button Bug (FB6869419, seems to be fixed in iOS 13.1).

### Requirements
- Xcode 11 
- iOS 13.0

