## Two legged example using Twitter
Here's the guide which was used: \
https://developer.twitter.com/en/docs/authentication/oauth-2-0/bearer-tokens

Apply for a new Twitter developer account here: https://developer.twitter.com and once this has been approved create a new app here: https://developer.twitter.com/en/apps where a new set of keys can be created. Store in a safe place!

> Copy & paste the keys into OAuth2ClientCredentials which can be found in PJCAppDelegate.swift.
```swift
var clientCredentials: OAuth2ClientCredentials
{
    return  OAuth2ClientCredentials(apiKey: "<paste api key here>",
				    apiSecretKey: "<paste api secret key here>")
}
```
> Add the desired scopes.
```swift
var scopes: [String]
{
    return ["<add scope(s) here>"]
}
```
> Edit the example hosts found in PJCEnvironment.swift.
```swift
static var host: OAuth2Host
{
    switch PJCEnvironment.current
    {
    default: return TwitterOAuth2()
    }
}

var authHost: OAuth2Host { return PJCEnvironment.host }

var tokenHost: OAuth2Host? { return nil) }
```
> Switch the comments for the two legged example in PJCOAuth2ViewController.swift
```swift		   
// self.threeLeggedExample()
self.twoLeggedExample()
```
## Three legged example using Google 
Here's the guide: \
https://developers.google.com/identity/protocols/oauth2/native-app#ios

:warning: Copy & paste ``redirect_uri`` project credential into ``Info.plist -> URL types -> URL Schemes -> Item 0`` making sure to remove any colon on the right side of the string
> Copy & paste GoogleAPIs cedentials into OAuth2AuthorizationCredentials which can be found in PJCAppDelegate.swift.
```swift
var authorizationCredentials: OAuth2AuthorizationCredentials
{
    return OAuth2AuthorizationCredentials("<paste client id here>",
					  redirectUri: "<paste redirect uri here>")
}
```
> Add the desired scopes. APIs/services will need to be enabled for the project using the GoogleAPIs console dashboard.
```swift
var scopes: [String]
{
    return ["<add scope(s) here>"]
}
```
> Edit the example hosts found in PJCEnvironment.swift.
```swift
static var host: OAuth2Host
{
    switch PJCEnvironment.current
    {
    default: return GoogleAccounts()
    }
}

var authHost: OAuth2Host { return PJCEnvironment.host }

var tokenHost: OAuth2Host? { return GoogleOAuth2() }
```
> Switch the comments for the three legged example in PJCOAuth2ViewController.swift
```swift		   
self.threeLeggedExample()
// self.twoLeggedExample()
```
## Three legged example using Spotify
Here's the guide: \
https://developer.spotify.com/documentation/general/guides/authorization-guide

Generally follow the steps for the three legged Google example with the folowing changes:
* Invent a scheme to use for both ```redirect_uri``` and ``Info.plist -> URL types -> URL Schemes -> Item 0``
* Add the optional authorizationCredentials -> client_secret credential
* Return SpotifyAccounts for the environment host, return nil for tokenHost
## Project Information
Xcode 12.1 \
Swift 5 \
Deployment Target 14.1

## Some useful OAuth2 links
https://en.wikipedia.org/wiki/OAuth \
https://oauth.net/2 \
https://aaronparecki.com/oauth-2-simplified \
https://tools.ietf.org/html/rfc6749
