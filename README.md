# flashcard_app
iOS 10.3 Mobile-App to represent flashcards

to-do:
- fix alignment/auto-layout issues for flashcard front/back/full controller view
- handle animation
- fix flashcard back textview scrolling limitation (enlarge textview, or re-architect whole card back to UIView, which breaks more things with the front)
-- one way to do this is the make the main flashcard a UIView, and then the FrontFlashcard a StackedView, and add it is a subview to the main flashcard, but maxed out in size
- write unit tests for flashcard and flashcards
-- include swipe tests for flashcard unit tests
- fix-up icon errors

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
