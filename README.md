# Insane iOS App *(Info)* Converter

A script to convert App ID's and Bundle ID's in bulk.

(Name suggestions welcome)

## Available Conversions

Appstore link --> App ID

App ID --> Bundle ID

## Extracting App ID's from webpages

Useful for extracting the App ID's from a [webpage like this.](https://ios-compatible.com/us/iphone-ios6/games/all/free/1/#content) That contains https://apps.apple.com/ links.

For example a webpage containing links to: 
* Clumsy Ninja
* Smash Hit
* Escape Challenge

Would output: 
* 561416817
* 603527166
* 603652689

Which can then be converted to their respective Bundle ID's: 
* com.naturalmotion.clumsyninja
* com.mediocre.smashhit
* com.klgamesllc.escapechallenge

## Bulk Purchasing Apps

Finally, apps can be added to your purchased list in bulk using another script I've made, [Insane iOS App Purchaser](https://github.com/disfordottie/insaneAppPurchaser).
