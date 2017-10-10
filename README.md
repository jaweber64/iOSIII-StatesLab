# iOSIII-StatesLab
iOS App Dev III:   Execution states lab
This project is from Chapter 15 of the book "Beginning iPhone Development with Swift -
Exploring the iOS SDK".  Grand Central Dispatch, Background Processing and You.

This project explores execution 'states'.  It uses the console to echo the method being
called from both the AppDelegate and the ViewController.  The layout consists of a
segmented controller, an image of a smiley face, and a spinning label (Bazinga!).
When user hits home button or double hits home button and swipes app off screen,
the states are echoed in the console as they are reached.  The app also stores
the state of the segmented controller so when the app comes up next time, it is
just as we left it.  We also release resources (images, etc) where appropriate.
