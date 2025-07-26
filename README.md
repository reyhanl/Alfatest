

# AlfaPlay (Test 1)
<img src="https://github.com/reyhanl/Dump/blob/f59c768fc05b62bb82f5487858994a8419939240/image1.png?raw=true" width="100%" />

## Snippets
<div align="center">
  <img src="https://github.com/reyhanl/Dump/blob/f59c768fc05b62bb82f5487858994a8419939240/swipingAnimation.gif?raw=true" width="20%" />
  <img src="https://github.com/reyhanl/Dump/blob/f59c768fc05b62bb82f5487858994a8419939240/shimmer.gif?raw=true" width="20%" />
  <img src="https://github.com/reyhanl/Dump/blob/f59c768fc05b62bb82f5487858994a8419939240/bouncyAnimation.gif?raw=true" width="20%" />
</div>



## Notes
I put the notes up here because it is very important, the Git history gets messed up because I made a mistake. 
The .gitignore ignores some very important files from the beginning resulting in the project won't run if you are using 
any commit before **f58b2864c743a74579f9e35243546947fac834b6** (message: FIX GITIGNORE ignoring some swift files).
I apologise for that, but I do hope you can still get the idea from the history.

## Overview
A simple Movie Library App where you can browse movies from moviedb Database.

UI: `SwiftUI`
Architecture: `MVVM`

## Libraries

### Apple Internal Libraries
- `SwiftUI`
- `Combine` (just a lil 🤏🏻)
- `WKWebView`

### External Libraries
- [Firebase Remote Config] - A simple library (a lil overkill) to securely fetching Authentication Token

I usually use Kingfisher for Image caching but I don't want to use Cocoapods for this project.

## Installation
This app is created in **XCode version 16.2**. It might not be possible to run it in lower version of XCode, If that is the case please do let me know. 

1. Clone or download zip from [https://github.com/reyhanl/Alfatest.git](https://github.com/reyhanl/Alfatest.git)

    > `git clone https://github.com/reyhanl/Alfatest.git`

2. Go to project directory

    > `cd insert_project_directory_here`
3. Open `AlfaMovie.xcodeproj`

4. Update Xcode Package if necessary
   > `file` > `Packages` > `Update to latest package version`

4. Run the project

[//]: # 
[Firebase Remote Config]: <https://firebase.google.com/docs/remote-config/get-started?platform=ios>
