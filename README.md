# Flipp Platform SDK Sample App

This README describes how you can integrate with the Flipp Platform SDK. 

> [!WARNING]
> **This sample app uses the alpha version of the Flipp Platform SDK. The features and delegate methods are currently hardcoded.**

## Table of Contents
- [About the SDK](#about)
- [Quick Start](#quick-start)
- [Methods](#methods)
- [Delegate Methods](#delegate-methods)

## About the SDK <a name="about"></a>
The Flipp Platform SDK allows mobile retailer apps to render flyers in two formats: in traditional print form or in a digital publication form. 

The digital publication format renders offers in a dynamic way that maintains responsiveness and merchandising flexibility, while also providing a host of features to allow users to interact with flyer offers.

## Quick Start <a name="quick-start"></a>

1) Add the framework to your project.
   
2) Initialize the SDK early in your application life cycle by providing a key, and an optional userid (currently the key is not used in the alpha).
```
  /// SDK initialization function, provides information necessary to the SDK.
  /// Needs to be called before any other function.
  /// - Parameters:
  ///   - clientToken: Identification token for the client.
  ///   - userId: Value that uniquely identifies the user.
  public static func initialize(clientToken: String, userId: String?) {
    DVMSDK.sdk.token = clientToken
    DVMSDK.sdk.userId = userId
  }
```
Example:

`DVMSDK.initialize(clientToken: "experimental-key-that-is-super-secret-and-secure-prd", userId: nil)`


3) Fetch a list of publications by calling (currently returns hardcoded data):
```
  /// Retrieves a list of publications and invokes the completion handler with the results.
  /// .
  /// If an error occurs during the process the error of the completion will be non nil and the publication list will be empty.
  ///
  /// Note: Currently the list of publications returned is not live, but hardcoded.
  /// - Parameters:
  ///   - merchantId: Merchant identifier to retrieve the publications for.
  ///   - storeCode: Store identifier for the publications.
  ///   - completion: closure that will be called with results.
  ///   - resultsCount: number of results per page, defaults to 10.
  ///   - pageToken: token for pagination, needed to fetch subsequent results.
  ///
  public static func fetchPublicationsList(
    merchantId: String,
    storeCode: String,
    resultsCount: Int = 10,
    pageToken: String? = nil,
    completion: PublicationsListCompletion
  ) {
    return DVMSDK.sdk.fetchPublicationsList(
      merchantId: merchantId,
      storeCode: storeCode,
      resultsCount: resultsCount,
      pageToken: pageToken,
      completion: completion
    )
  }
```

Example from `PublicationsViewController.swift`: 
```
    DVMSDK.fetchPublicationsList(
      merchantId: merchantID,
      storeCode: storeCode) {[weak self] list, error in
        if let error {
          //inform error or add retry logic.
          print(error)
          return
        }
        self?.publications = list.publications
        self?.tableView.reloadData()
        // store next page token for infinite scroll
      }
  }
```

4) Once a publication is selected create an instance of `DVMRenderer` to render the publication, and set its delegate appropiately:

```
    /// Creates and returns a rendering view for the publication with the corresponding id, respecting the requested rendering mode.
    /// .No references are kept within the SDK of this view, it is the responsibility of the caller to prevent deallocation.
    /// A delegate needs to be assigned to the view in order to receive callbacks from its while rendering.
    /// 
    /// Note: Currently a hardcoded publication is rendered.
    /// - Parameters:
    ///   - publicationId: Publication id to render.
    ///   - merchantId: Merchant id for the publication.
    ///   - storeCode: Store code for the publication.
    ///   - renderMode: Store identifier for the publications.
    /// - Throws: DVMSDKError.sdkNotIntialized in case this function is called before initializing the SDK
    public static func createRenderingView(publicationId: String, merchantId: String, storeCode: String, renderMode: dvm_sdk.RenderMode) throws -> dvm_sdk.DVMRendererView
```

Example in `PublicationViewController.swift`:
```
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
    }
```

5) When the user taps on an item, the following event is called, with the item details as the parameter:
```
    /// Called when an offer item is tapped.
    ///
    /// - Parameter item: The offer that was tapped.
    func didTap(item: dvm_sdk.Offer)
```
Example from publicationsViewController: 
```
  func didTap(item: Offer) {
    self.pushDetailsController(for: item)
  }
```

## Methods <a name="methods"></a>
The Flipp Platform SDK currently provides the following features:

### initialize
> [!WARNING]
> Currently any string will work as a key.

```
    /// SDK initialization function, provides information necessary to the SDK.
    /// Needs to be called before any other function.
    /// - Parameters:
    ///   - clientToken: Identification token for the client.
    ///   - userId: Value that uniquely identifies the user.
    public static func initialize(clientToken: String, userId: String?)
```

### fetchPublicationsList
> [!WARNING]
> Response is currently hardcoded and parameters are not used by the SDK.
```
    /// Retrieves a list of publications and invokes the completion handler with the results.
    /// .
    /// If an error occurs during the process the error of the completion will be non nil and the publication list will be empty.
    ///
    /// Note: Currently the list of publications returned is not live, but hardcoded.
    /// - Parameters:
    ///   - merchantId: Merchant identifier to retrieve the publications for.
    ///   - storeCode: Store identifier for the publications.
    ///   - resultsCount: number of results per page, defaults to 10.
    ///   - pageToken: token for pagination, needed to fetch subsequent results.
    ///   - completion: closure that will be called with results.
    ///
    public static func fetchPublicationsList(merchantId: String, storeCode: String, resultsCount: Int = 10, pageToken: String? = nil, completion: (dvm_sdk.PublicationsList, (Error)?) -> Void)
```
### createRenderingView
> [!WARNING]
> Currently, the only parameter considered by the SDK is the `renderMode` it will always return the same publication.
```
    /// Creates and returns a rendering view for the publication with the corresponding id, respecting the requested rendering mode.
    /// .No references are kept within the SDK of this view, it is the responsibility of the caller to prevent deallocation.
    /// A delegate needs to be assigned to the view in order to receive callbacks from its while rendering.
    /// 
    /// Note: Currently a hardcoded publication is rendered.
    /// - Parameters:
    ///   - publicationId: Publication id to render.
    ///   - merchantId: Merchant id for the publication.
    ///   - storeCode: Store code for the publication.
    ///   - renderMode: Store identifier for the publications.
    /// - Throws: DVMSDKError.sdkNotIntialized in case this function is called before initializing the SDK
    public static func createRenderingView(publicationId: String, merchantId: String, storeCode: String, renderMode: dvm_sdk.RenderMode) throws -> dvm_sdk.DVMRendererView
```

### updateUserId
> [!WARNING]
> Not used currently.
```
    /// Updates the user identification within the SDK.
    /// - Parameters:
    ///   - userId: Value that uniquely identifies the user.
    public static func updateUserId(_ userId: String)
```

## Delegate Methods <a name="delegate-methods"></a>
The Flipp Platform SDK can send events notifying your app about actions that the user has taken. 
The following events are supported:

```
/// The DVMRendererDelegate protocol defines a set of methods to handle interactions and state changes related to the rendering of offers.
/// This protocol is intended to be adopted by a delegate object to handle tap events, successful loading, and failure scenarios from an offer rendering view.
public protocol DVMRendererDelegate : AnyObject {

    /// Called when an offer item is tapped.
    ///
    /// - Parameter item: The offer that was tapped.
    func didTap(item: dvm_sdk.Offer)

    /// Called when the publication rendering has finished loading successfully.
    func didFinishLoad()

    /// Called when the publication rendering failed to load.
    ///
    /// - Parameter error: The error that occurred during the loading process.
    func didFailToLoad(error: Error)
}
```

