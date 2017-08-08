# sf-ios
An app for #sf-coffee and #sf-beer events from the iOS Folks Slack.

## Why Obj-C?
For interviews, I needed to become comfortable again with Obj-C. What better way than to write an app?

## Getting the app

Join the TestFlight: [SF iOS testflight](https://sf-ios-testflight.herokuapp.com)

## Building from source

The app has no external dependencies. However, for travel time estimates, it uses Uber and Lyft REST APIs and the corresponding credentials are stored in `Secrets/secrets.plist` file. This file, for obvious reasons, is not checked-in into version control. To build and run:

1. Duplicate `Secrets/secrets-example.plist` and rename it to `secrets.plist`. you can build the project now but Uber and Lyft travel times will not be available.
2. Get [Uber](https://auth.uber.com/login/?next_url=https%3A%2F%2Fdeveloper.uber.com%2Fdashboard%2F&state=jZgX3-jJNzOiN57ly8Tv0uY0ArFXStNvQsjM_mzcYdg%3D) and [Lyft](https://www.lyft.com/developers/manage) `client-id` and `server-token` and populate `secrets.plist`.

The app uses CLoudKit as its backend and you will need to replicate the required models in your CloudKit dev environemnt.
