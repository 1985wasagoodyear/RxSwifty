# RxSwifty

Updated February 9, 2020.

A basic test app for demonstrating usage of [RxSwift/RxCocoa](https://github.com/ReactiveX/RxSwift). 

Includes 3 different mini-apps, demonstrating incrementally-useful details.

## To Run:

RxSwift is packed by CocoaPods, and are not included with this repository.

Be sure to perform `pod install` before building and running this app.


## Table of Contents

* App 1: SimpleTableViewArray
* App 2: Networking Example
* App 3: Google Books Example
* Learning Lessons
* Additional References

## App 1. SimpleTableViewArray

Introduction to creating `Observable`s from an Array, as well as using the `rx` extension on UITableView, in *replacement* of `UITableViewDataSource` and `UITableViewDelegate` delegate methods.

Can create elements on the TableView using the Button and Stepper. Can remove elements by tapping them on the TableView.

### Relevant files:
1. ArrayTableViewController.swift
	* `func setupBindings()`
2. ArrayViewModel.swift

### Noteworthy lessons:
Creating `Observables`, Observing Arrays, creating Observables using the `rx` extension on `UIKit` objects.


## App 2. Networking Example

Similar to the simple table example, but consumes the [DuckDuckGo Instant Answer API](https://duckduckgo.com/api).

### Relevant files:
1. DDGViewController.swift
2. ArrayViewModel.swift
3. APIClient.swift

### Noteworthy lessons:
Creating `Observable` items from URLSessionDataTasks and binding their results to an Array for usage.


## App 3. Google Books Example

Similar to the networking example, but consumes the [Google Books API v1](https://developers.google.com/books/docs/v1/using).

### Relevant files:
1. GBViewController.swift

### Noteworthy lessons:
This does not use an array nor observe the array. Instead, it uses an Observable on the search bar to fetch results from the networking Observable and bind the results to the table.

The end-result is an incredibly simple-to-read and small codebase that relies heavily on RxSwift for its implementation.


## Learning Lessons

DisposeBags are what retain all Observables, per Cocoa's memory management implementation. These are destroyed when the ViewController is released, avoiding a memory leak.

Memory leaks can still exist, however (this test app has not been validated to ensure a lack of leaks)

iOS 13 seems to have made RxSwift [very noisy with tableViews](https://github.com/RxSwiftCommunity/RxDataSources/issues/331)...
	
* (this is what you get for using third-party libraries.)

RxCocoa is the Reactive-X implementation, wherein RxSwift is your interface, for use in Swift

* coincidentally, you'll see both be imported for usage, as a result.


## Additional References

1. https://www.netguru.com/codestories/networking-with-rxswift

2. http://swiftyjimmy.com/network-request-with-rxswift/