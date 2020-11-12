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
> Switch the comments for the two legged example in PJCOAuth2ViewController.swift
```swift		   
// self.threeLeggedExample()
self.twoLeggedExample()
```
## Three legged example using Google 
Currently this is a half working WIP,  receive a 400 response when attempting to exchange a user consented authorization code. On the developer console ther is no credentials client secret available for iOS.

The example will progress no further than this guide step: \
https://developers.google.com/identity/protocols/oauth2/native-app#exchange-authorization-code
> Copy & paste GoogleAPIs cedentials into OAuth2AuthorizationCredentials.
```swift
var  authorizationCredentials: OAuth2AuthorizationCredentials
{
	return  OAuth2AuthorizationCredentials("<paste client id here>",
						redirectUri: "<paste redirect uri here>")
}
```
> **IMPORTANT**
Copy & paste the **redirect_uri** credential into Info.plist -> URL types -> URL Schemes -> Item 0
## Project Information
Xcode 12.1 \
Swift 5 \
Deployment Target 14.1

## Some useful OAuth2 links
https://en.wikipedia.org/wiki/OAuth \
https://oauth.net/2/ \
https://aaronparecki.com/oauth-2-simplified/ \
https://tools.ietf.org/html/rfc6749
