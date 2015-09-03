osx + Firebase Seed App
=========================

This is a seed application to help you get started building [OSX](https://developer.apple.com/ios) apps in Objective-C with Firebase. If you don't already have a Firebase account, [sign up for free](https://www.firebase.com/signup/) today!

## [Getting Started](https://www.firebase.com/docs/ios/quickstart.html)

To get started with this seed app, follow the instructions below:

```
git clone https://github.com/firebase/seed-osx.git
cd seed-osx
pod install
open Seed\ OSX.xcworkspace
```

Change line 32 of `ViewController.m` to the name of your Firebase Application:

```Objective-C
self.ref = [[Firebase alloc] initWithUrl:@"https://<YOUR-FIREBASE-APP>.firebaseio.com"];
```

You can then delete the `#error Message` on line 31.

## Running your app
Once `Seed OSX.xcworkspace` has been opened, press `cmd + r` to run your appplication on the desktop.

## How it Works
#### Email & password authentication

This app makes use of Firebase's [email & password authentication](https://www.firebase.com/docs/web/guide/login/password.html). To enable email & password auth, navigate to the "Login & Auth" tab in your Firebase app dashboard and select "Enable Email & Password Authentication".

Once it's enabled, the `toggleAuth` and `authOrCreateUser: password:` methods will log users in, log users out, and create a user if one needs to be created. Additionally, an Firebase is observing the auth state and will update that state with the current user's email address in the title of the `UINavigationController`.

Firebase also supports authentication with Facebook, Twitter, GitHub, Google, anonymous auth, and custom authentication. [Check out the docs](https://www.firebase.com/docs/ios/guide/user-auth.html) on user authentication for details on these authentication methods.

#### Adding messages
This app makes use of a `NSTextField` for text input, and uses the `NSControlTextEditingDelegate` `control: textShouldEndEditing:` method to push messages to the `/messages` node of your Firebase database. These messages are of the form:

```
{
  email: 'email@domain.com',
  text: 'Literally cronut post-ironic, shabby chic distillery PBR&B.'
}
```

For more information on saving data to Firebase, check out our [saving data docs](https://www.firebase.com/docs/ios/guide/saving-data.html).

#### Displaying messages
This app uses standard `FEventTypeChildAdded` events to add messages to an `NSMutableArray` containing `FDataSnapshots`. These snapshots are provided by the `NSTableViewDataSource` to populate a `MessageTableViewCell` in the `NSTableView`. For more information on how to view changes from Firebase, check out our [retrieving data docs](https://www.firebase.com/docs/ios/guide/retrieving-data.html).

## Securing your app
Copy and paste the contents of `rules.json` into the Security & Rules tab of your Firebase App Dashboard.

`rules.json` has two basic security rules. The first ensures that only logged in users can add messages to the list:

` ".write": "auth != null"`

The second rule ensures that new messages are not empty:

`".validate": "newData.hasChildren(['email', 'text'])"`

`.validate` rules are run after `.write` rules succeed. You can see the full rules in the `rules.json` file.

For more details on security rules, check out the [security quickstart](https://www.firebase.com/docs/security/quickstart.html) in our documentation.

## Deploying your app
In XCode, simply `cmd + r` to run your application on your desktop.

For more information on deploying your app to the Mac App Store, or on your own, check out Apple's [Distributing your Mac Apps](https://developer.apple.com/osx/distribution/).

## Repo Structure
The top level of the repo contains project metadata, including the `README`, `CONTRIBUTORS`, and `LICENSE`.

Additionally, it contains `Seed OSX`, which contains all of the source code for the project.

In terms of project metadata, `Seed OSX.xcodeproj` is the XCode project file, and `Podfile` is the Cocoapods Podfile, where our dependencies live.

`rules.json` contains the security rules for the project. For more information, see the [Securing your App](https://github.com/firebase/seed-osx#securing-your-app) section of this README.

## Next Steps

### Community

Firebase has an active developer community consisting of over 230,000 developers. There are a number of different channels for contributing to our community, including:

1. [Stack Overflow](http://www.stackoverflow.com/tags/firebase)
1. [Firebase Talk Google Group](https://groups.google.com/forum/#!forum/firebase-talk)
1. [Twitter](https://twitter.com/firebase)
1. [Facebook](https://www.facebook.com/Firebase)
1. [Google+](http://plus.google.com/115330003035930967645)

Additional information on the community, help, or support can be found on our [help page](https://www.firebase.com/docs/help/).

### Contributing

We'd love to accept your sample apps and patches! Before we can take them, we a few business items to take care of including our CLA and an overview of our contribution process. Please view [CONTRIBUTING.md](https://github.com/firebase/seed-osx/blob/master/CONTRIBUTING.md) for more information.

1. Submit an issue describing your proposed change to the repo in question.
1. The repo owner will respond to your issue promptly.
1. If your proposed change is accepted, and you haven't already done so, sign a
   Contributor License Agreement (see details above).
1. Fork the desired repo, develop and test your code changes.
1. Ensure that your code adheres to the existing style of the library to which
   you are contributing.
1. Ensure that your code has an appropriate set of unit tests which all pass.
1. Submit a pull request.
