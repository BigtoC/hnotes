# hnotes

A Flutter notes app with blockchain storage.
> The letter "**h**" stands for **him/her** or **happiness**.  
> Notes(~~NFTs~~) about him/her, or about happiness
 
## Usage guide

### Quick start
1. Download the latest version of this app from the [release page](https://github.com/BigtoC/hnotes/releases) (Android only for now)
2. Open App, set your date

### Blockchain functions
> To use NFT functions, please setup blockchain connection services  
1. Sign up for an Alchemy account ([here](https://auth.alchemyapi.io/signup)) and create an Alchemy key ([tutorial](https://auth.alchemyapi.io/signup))
2. Click the `IMPORT NFT` button on the home page to show NFTs
3. Create a Metamask wallet and connect to Ropsten testnet
4. Use [Pixura beta](https://ropsten-platform.pixura.io/) to publish your NFTs


## Development Stages

### Stage 1
> Basic notes on mobile app developments  
> Target finish before 2020-05-22  
> Finished on 2020-05-08
- [x] Show how many days we've been together
- [x] Switch light/dark themes
- [x] Rich text editor
- [x] Take notes and local storage
- [x] Show notes in an appropriate way
- [x] Search notes
- [x] Set the love start date first for the first time open this app

### Stage 2 (Migration and clean up)
> New blockchain-related developments  
> Target finish before 2022-05-10  
> Finished on 2022-05-06  

- [x] {2.0} Migrate to Flutter 2 and latest Dart version
- [x] {2.0.5} Codes clean up and structure enhancements
- [X] {2.1} Switch to Ropsten (Ethereum testnet), and use Alchemy as a blockchain connection service
- [x] {2.2} Show more blockchain information
- [x] {2.3} Implement DDD Architecture ([reference](https://github.com/ResoCoder/flutter-ddd-firebase-course))

### Stage 3
> Import and present ERC-721  
> Target finish before 2022-05-27 (1000 days)  
> Finished on 2022-05-23  

- [x] {3.0.1} Allow users to import the API key, instead of reading a secret file.
- [x] {3.1} Import and show NFTs on the home page
- [x] {3.2} Show details of an imported NFT from the home page
- [x] {3.3} Navigate to usage the guide webpage from drawer
- [x] {3.4} Swipe right to delete an NFT

### Next Gen (refactor and new blockchain)
> Updated at April 2025
> Check [issues](https://github.com/BigtoC/hnotes/issues)
- [x] Migrate to Flutter 3 and latest Dart version ([What’s new in Flutter 3](https://medium.com/flutter/whats-new-in-flutter-3-8c74a5bc32d0))
- [x] Integrate a new blockchain
- [x] Import crypto wallet
- [ ] Basic functions of the new blockchain (e.g. display balances and send tokens)
- [ ] Interact dApps
- [ ] Biometric authentications (Fingerprint, face unlock)
- [ ] MCP?

## References
* Alchemy: [documents](https://docs.alchemy.com/alchemy/)  
* App interface: [roshanrahman/flutter-notes-app](https://github.com/roshanrahman/flutter-notes-app)
* Draggable buttons: [Flutter实战手势番外篇之可拖拽悬浮组件](https://juejin.im/post/5e4b9c74f265da57127e3f63)
* Flutter App example: [filiph/hn_app](https://github.com/filiph/hn_app)
* Flutter DDD Article: [Beginner’s guide to Flutter with DDD](https://medium.com/@ushimaru/beginners-guide-to-flutter-with-ddd-87d4c476c3cb)
* Flutter DDD Example: [Domain-Driven Design + Firebase Flutter Course](https://github.com/ResoCoder/flutter-ddd-firebase-course)
* More page route transitions: [关于 Flutter 页面路由过渡动画，你所需要知道的一切](https://juejin.im/post/5ceb6179f265da1bc23f55d0)

## Getting Started with Flutter
This project is a starting point for a Flutter application.
A few resources to get you started if this is your first Flutter project:
- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)
For help getting started with Flutter, view the
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
