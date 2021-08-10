# Project 13 (Instafilter)

This is my solution to the Instafilter project (project 13) in the [100 Days Of SwiftUI](https://www.hackingwithswift.com/100/swiftui/) tutorial created by Paul Hudson ([@twostraws](https://github.com/twostraws)). This was an introduction to Core Image and gave us a taste of what's possible with this very powerful (but very old) API. The project led us through the creation of useful SwiftUI-friendly objects that wrap image picking and saving.

Implemented challenge 1 by adding a state variable to show an elert. The condition is set to true in the save function if the guard statement indicates that the image has not been set.

Challenge 2 was to set the button label to the name of the selected filter. Setting up the action sheet buttons and their action closures led to refactoring the button creation into a function that takes an index and uses it to retrieve the filter and label from a static tuple array that I added to the content view.

For challenge 3, separate sliders (with their own apropriate ranges) were added to control radius and scale settings. Each slider has its own state variable and a custom binding to enable changes to be reflected immediately in the view. Finally, the sliders are only displayed when the setting is supported by the current filter and updates to the state occur inside a default animation to make the transitions more pleasing.
