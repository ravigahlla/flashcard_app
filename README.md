# flashcard_app
iOS 10.3 Mobile-App to represent flashcards

to-do:
- fix alignment/auto-layout issues for flashcard front/back/full controller view
- fix flashcard back textview scrolling limitation (one way to do this is the make the main flashcard a UIView, and then the FrontFlashcard a StackedView, and add it is a subview to the main flashcard, but maxed out in size)
- is there a way of not instantiating and storing both sides of the flashcard, instantiating when necessary?
- write unit tests for flashcard and flashcards
-- include swipe tests for flashcard unit tests
- fix-up icon errors
- add swipe gesture inside text views of flashcard
- add a shake gesture to randomize the deck of cards
- remove magic numbers from FlashcardDeckViewController

helpful links/references/inspiration:
- https://developer.apple.com/library/content/referencelibrary/GettingStarted/DevelopiOSAppsSwift/index.html#//apple_ref/doc/uid/TP40015214-CH2-SW1
- https://spin.atomicobject.com/2015/09/02/switch-container-views/
- https://stackoverflow.com/questions/4660371/how-to-add-a-touch-event-to-a-uiview
- https://stackoverflow.com/questions/32437094/pass-data-to-the-container-view-in-swift
- https://www.allaboutswift.com/dev/2016/5/14/stackviews-in-ios9
- https://stackoverflow.com/questions/30728062/add-views-in-uistackview-programmatically
- https://developer.apple.com/reference/uikit/uistackview
- https://stackoverflow.com/questions/24710041/adding-uitextfield-on-uiview-programmatically-swift
- https://developer.apple.com/library/content/documentation/UserExperience/Conceptual/AutolayoutPG/AnatomyofaConstraint.html#//apple_ref/doc/uid/TP40010853-CH9-SW1
- https://www.raywenderlich.com/114552/uistackview-tutorial-introducing-stack-views
- https://www.natashatherobot.com/ios-frame-vs-bounds-resize-basic-uitableview-cell/
- https://stackoverflow.com/questions/41236473/scrollview-add-subview-in-swift-3
- https://stackoverflow.com/questions/26180822/swift-adding-constraints-programmatically
- https://stackoverflow.com/questions/26086175/swift-retrieving-subviews
- http://www.howtobuildsoftware.com/index.php/how-do/byAz/ios-swift-uiview-uiviewcontroller-uitapgesturerecognizer-flipping-view-in-swift-issues-with-whole-screen-flipping-tap-gesture-only-works-twice
- https://stackoverflow.com/questions/28938660/how-to-lock-orientation-of-one-view-controller-to-portrait-mode-only-in-swift
- https://stackoverflow.com/questions/31207783/reloading-a-view-controller-swift
- https://iosdevcenters.blogspot.com/2017/02/uipangesturerecognizer-tutorial-in.html
- https://www.youtube.com/watch?v=0fXR-Ksuqo4 (iOS Tinder-Like Swipe - Part 1- UIPanGestureRecognizer (Xcode 8, Swift 3))
- https://www.youtube.com/watch?v=sBnqFLJqn9M (iOS Tinder-Like Swipe - Part 3 - Animating card off screen (Xcode 8, Swift 3))
