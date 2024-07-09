# ACReview

[![Swift](https://img.shields.io/badge/Swift-5-orange?style=flat-square)](https://img.shields.io/badge/Swift-5-Orange?style=flat-square)
[![Platforms](https://img.shields.io/badge/Platforms-iOS-yellowgreen?style=flat-square)](https://img.shields.io/badge/Platforms-iOS?style=flat-square)
[![Swift Package Manager](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat-square)](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat-square)
[![version](https://img.shields.io/badge/version-0.0.1-white.svg)](https://semver.org)

## Requirements
- Xcode 13 and later
- iOS 12 and later
- Swift 5.0 and later

## Overview
* [How to use](#how-to-use)
	* [Basic usage](#basic-usage)
	* [Rules](#rules)
	* [Review alert call counter](#review-alert-call-counter)
* [Demo](#demo)
* [Install](#install)

## How to use

### Basic usage
To try to call a review alert, you need to create an object of the `ACReviewService` class and pass a single [rule](#rules) or an array of rules there. Optionally, you can pass a limit on the number of calls to the request, if exceeded, the request will not be executed, and your own implementation of [ACReviewCallsCounter](#review-alert-call-counter).

```swift
let rules: [ACRequestReviewRule] = [
  ACSeriallyRule(actionFrequency: .daily(everyXDays: 15)),
  ACAppUpdateRule(),
]
let reviewService = ACReviewService(rules: rules)
reviewService.tryToShowRating(
  notRequiredFinished: {
    // Do something
  },
  requiredFinished: { isDisplayd in
    // Do something
  }
)
```

### Rules
Rules is a strategy that checks that all required conditions are present to invoke the application review window.
You can use pre-defined rules or create your own rules that comply with the protocol `ACRequestReviewRule`.

#### ACAppUpdateRule
 Show an evaluation request after a certain amount of time using the app after the app has been upgraded to a new version.

```swift
 ACAppUpdateRule()
```

#### ACAppUpdateWithDelayRule
Show an evaluation request after a specified time of using a new version of the application.

```swift
ACAppUpdateWithDelayRule(minimumUsageTime:.days(2))
```

To give an example, we need to show the evaluation window after a few days of using the app:

```swift
@main 
class AppDelegate: UIResponder, UIApplicationDelegate {
  private let appUpdateWithDelayRule = ACAppUpdateWithDelayRule(minimumUsageTime: .days(2))

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    appUpdateWithDelayRule.startSession()
    return true
  }

  func applicationWillTerminate(_ application: UIApplication) {
    appUpdateWithDelayRule.endSession()
  }
}
```

Don't forget about the calling of the request alert, e.g. on the main screen, via `tryToShowRating()`.

#### ACEventDelayRule
Show an evaluation request after a specified period of time of using the app after an action has been performed by user.

```swift
let rule = ACEventDelayRule(key: "<enter_unique_key>", minimumUsageTime: .hours(3)) 
// After a user has made an important action in the application,
// for example, after registration of an account
rule.setCondition(true)
rule.startSession()

/// When you exit the screen or before closing an application
rule.endSession()
```

#### ACRuleCounter
Show an evaluation request after the user performs a specific action a number of times. The flag value is increased manually and reset automatically when the limit is reached.

```swift
let rule = ACRuleCounter(customFlagKey: "<enter_unique_key>", threshold: 5)
rule.incrementFlag()
let reviewService = ACReviewService(rule: rule)
reviewService.tryToShowRating()
```

#### ACSeriallyRule
Show the evaluation request periodically, after a specified interval of time. Example:

```swift
ACSeriallyRule(actionFrequency: .onceEveryMonths(month: 2))
```

To create a custom rule that will take into consideration the time of using an application (or a specific screen) it is also necessary to add the `ACDelayRule` protocol.

### Review alert call counter
A set of methods for counting the number of calls to the request review call.

```swift
public protocol ACReviewCallsCounter {
    func incrementAttempt()
    func getCurrentAttempts() -> Int
    func resetAttempts()
}
```

## Demo
All these examples, as well as the integration of the `ACReview` module into the application, can be seen in action in the [Demo project](/Demo).

## Install
To install this Swift package into your project, follow these steps:

1. Open your Xcode project.
2. Go to "File" > "Swift Packages" > "Add Package Dependency".
3. In the "Choose Package Repository" dialog, enter `https://github.com/AppCraftTeam/appcraft-review-ios.git`.
4. Click "Next" and select the version you want to use.
5. Choose the target where you want to add the package and click "Finish".

Xcode will then resolve the package and add it to your project. You can now import and use the package in your code.

## License
This library is licensed under the MIT License.

## Author
Email: <moslienko.p@gmail.com>
