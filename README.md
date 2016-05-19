[![Build Status](https://img.shields.io/travis/GabrielMassana/lead-ios-developer/master.svg?style=flat-square)](https://travis-ci.org/GabrielMassana/lead-ios-developer)

# How and why

### Unit Test

I added some tests to the project. I know they are a really small part of the tests that can be added to this project, but they are only trying to be a small example of how powerful they are.

### Continuous Integration

The project is integrated with [Travis-CI](https://travis-ci.org/GabrielMassana/lead-ios-developer) as Continuous Integration to automate the build and test of the project.

### Using my own Pods

I used four of [my own pods in Cocoapods](https://cocoapods.org/owners/10374).   
   
- **CoreDataFullStack**. A project to simplify the use of Core Data.
- **CoreOperation**. Small wrapper project to simplify `NSOperation` and `NSOperationQueue`.
- **CoreNetworking**. A small project that simplifies NSURLSession.

### Third party Pods

- **[PureLayout](https://cocoapods.org/pods/PureLayout)**. An easy and powerfull pod that helps a lot using auto-layout.
- **[ConvenientFileManager](https://cocoapods.org/pods/ConvenientFileManager)**. A suite of categories to ease using NSFileManager for common tasks. 

### The app meets all the functional requirements 

 - When i open the application I want to see a list of all Marvel’s released comic books covers ordered from most recent to the oldest so I can scroll trough the the Marvel universe;
 - When I select one of the comics I want to be able to change the cover picture with a photo taken from my camera so I can be a Marvel character!
 - When I change a comic cover image I want to able to store it in my dropbox account so I won’t lose it when I reopen the application.


# Streetbees lead iOS developer position

[Role description](https://github.com/Streetbees/lead-ios-developer/wiki/Role-description)

[Requirements](https://github.com/Streetbees/lead-ios-developer/wiki/Requirements)

[Benefits](https://github.com/Streetbees/lead-ios-developer/wiki/Benefits)


### To apply you shoud follow the instructions below:

- Fork this repo;
- Look at the specification below and do your thing;
- When ready open a pull into the master branch of this repo and mention @streetbees/development;
- We will then review the code and if necessary discuss within the pull request.

### Challenge spec:

- Description:
    - Using the best API available on this side of the universe, https://developer.marvel.com/ , make a simple app that allows the user to scroll trough all the comics ever released from the most recent to the oldest (and please, let me see the cover picture while I do it!);
    - For each entry on the list make it possible for the user to replace a cover image with his own image (taken from the iPhone camera) and save the custom entry to the user’s dropbox account.

- Functional requirements (Using the Job to be Done framework):

    - When i open the application I want to see a list of all Marvel’s released comic books covers ordered from most recent to the oldest so I can scroll trough the the Marvel universe;
    - When I select one of the comics I want to be able to change the cover picture with a photo taken from my camera so I can be a Marvel character!
    - When I change a comic cover image I want to able to store it in my dropbox account so I won’t lose it when I reopen the application.

- Technical requirements
    - Application must run in an iPhone 6 running iOS 9.

- Evaluation Criteria
    - you create maintainable code;
    - you care about the user experience ;
    - you pay attention to details;
    - you develop in a scalable manner.

- Deliverables
    - The forked version of this repo;
    - A video of the app working (a TestFlight invite from which we can directly run the app will also add a good amount of bonus points).
