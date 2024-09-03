# Flipp Platform SDK Sample App

This README describes how you can integrate with the Flipp Platform SDK.

## Table of Contents

- [About the SDK](#about)
- [Quick Start](#quick-start)
- [How to Integrate the SDK](#how-to)
- [Delegate Methods](#delegate-methods)

## About the SDK <a name="about"></a>

The Flipp Platform SDK allows mobile retailer apps to render publications in two
formats: in traditional print form (SFML) or in Digital Visual Merchandising
form (DVM).

The DVM format renders publications in a dynamic way that maintains
responsiveness and merchandising flexibility, while also providing a host of
features to allow users to interact with offers.

## Quick Start <a name="quick-start"></a>

1. Clone this repo.

2. Open `dvm-sample.xcodeproj` in Xcode.

3. Insert the SDK key provided by Flipp in `AppDelegate` line 10.
   > [!WARNING]
   >
   > If you run the application without this key, it will crash indicating the
   > issue.

```swift
// This is the key that will be used to initialize the SDK, please replace the value with the key provided by Flipp.
  private let SDKKey = ""
```

4. Build and run the app.

## How to Integrate the SDK <a name="how-to"></a>

1. Add the DVM SDK as a dependency through SPM (Swift Package Manager).

- Navigate to Package Dependecies > Click '+' to add a package.
- Enter the SDK repository's URL `https://github.com/wishabi/dvm-ios-binaries/`
  as the package URL.
- Select the package when prompted.

3. Initialize the SDK early in your application life cycle by providing a
   `clientToken` key, and an optional `userId`.

```swift
  /// SDK initialization function, provides information necessary to the SDK.
  /// Needs to be called before any other function.
  /// - Parameters:
  ///   - clientToken: Identification token for the client.
  ///   - userId: Value that uniquely identifies the user.
  public static func initialize(clientToken: String, userId: String?)
```

Example:

```swift
import dvm_sdk

DVMSDK.initialize(clientToken: "experimental-key-that-is-super-secret-and-secure-prd", userId: nil)
```

3. Fetch a list of publications by calling
   `DVMSDK.fetchPublicationsList(merchantId:storeCode:language:completion:)`:

```swift
/// Retrieves a list of publications and invokes the completion handler with the results.
/// .
/// If an error occurs during the process the error of the completion will be non nil and the publication list will be empty.
///
/// Note: Currently the list of publications returned is not live, but hardcoded.
/// - Parameters:
///   - merchantId: Merchant identifier to retrieve the publications for.
///   - storeCode: Store identifier for the publications.
///   - language: The desired language.
///   - resultsCount: number of results per page, defaults to 10.
///   - pageToken: token for pagination, needed to fetch subsequent results.
///   - completion: closure that will be called with results.
///
public static func fetchPublicationsList(merchantId: String, storeCode: String, language: String, resultsCount: Int = 10, pageToken: String? = nil, completion: @escaping PublicationsListCompletion) throws
```

Example from `PublicationsViewController.swift`:

```swift
let publications = try await DVMSDK.fetchPublicationsList(
  merchantId: merchantID,
  storeCode: storeCode,
  language: Locale.preferredLanguageCode() ?? "en")
await MainActor.run { [weak self] in
  self?.tableView.refreshControl?.endRefreshing()
  self?.publications = publications
  self?.tableView.reloadData()
```

4. Once a publication is selected, create an instance of `DVMRendererView` to
   render the publication and set its delegate appropriately:

```swift
/// Creates and returns a rendering view for the publication with the corresponding id, respecting the requested rendering mode.
/// .No references are kept within the SDK of this view, it is the responsibility of the caller to prevent deallocation.
/// A delegate needs to be assigned to the view in order to receive callbacks from its while rendering.
/// - Parameters:
///   - publicationId: Publication id to render.
///   - merchantId: Merchant id for the publication.
///   - storeCode: Store code for the publication.
///   - renderMode: Store identifier for the publications.
///   - shouldPersistWebsiteDataToDisk: Whether website data should persist to disk (default is false).
/// - Throws: DVMSDKError.sdkNotIntialized in case this function is called before initializing the SDK
/// - Returns: A DVM renderer view.
public static func createRenderingView(
  publicationId: String,
  merchantId: String,
  storeCode: String,
  renderMode: RenderMode,
  shouldPersistWebsiteDataToDisk: Bool = false
) throws -> DVMRendererView
```

Example for using `createRenderingView` within
`PublicationViewController.swift`:

```swift
    if let rendererView = try? DVMSDK.createRenderingView(
      publicationId: publicationID,
      merchantId: merchantId,
      storeCode: storeCode,
      renderMode: renderingMode
    ) {
      rendererView.rendererDelegate = self
      rendererView.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview(rendererView)
      self.rendererView = rendererView
      setupConstraints()
      spinner.stopAnimating()
    }
```

5. When the user taps on an item, the following event is called with the item
   details as the parameter:

```swift
/// Called when an offer item is tapped.
///
/// - Parameter result: The result which contains an `Offer` on success or a
/// `DVMSDKError` on failure.
func didTap(result: Result<dvm_sdk.Offer, dvm_sdk.DVMSDKError>)
```

Example from `PublicationsViewController.swift`:

```swift
func didTap(result: Result<dvm_sdk.Offer, dvm_sdk.DVMSDKError>) {
  switch result {
  case .success(let offer):
    self.pushDetailsController(for: offer)
  case .failure(let error):
    Self.logger.error("Error tapping on offer: \(error.localizedDescription)")
  }
}
```

## Delegate Methods <a name="delegate-methods"></a>

The Flipp Platform SDK can send events notifying your app about actions that the
user has taken. The following events are supported:

```swift
/// The DVMRendererDelegate protocol defines a set of methods to handle interactions and state changes related to the rendering of offers.
/// This protocol is intended to be adopted by a delegate object to handle tap events, successful loading, and failure scenarios from an offer rendering view.
public protocol DVMRendererDelegate : AnyObject {

    /// Called when an offer item is tapped.
    ///
    /// - Parameter result: The result which contains an `Offer` on success or a
    /// `DVMSDKError` on failure.
    func didTap(result: Result<dvm_sdk.Offer, dvm_sdk.DVMSDKError>)

    /// Called when the offer rendering has finished loading successfully.
    func didFinishLoad()

    /// Called when the offer rendering failed to load.
    ///
    /// - Parameter error: The error that occurred during the loading process.
    func didFailToLoad(error: any Error)
}
```
