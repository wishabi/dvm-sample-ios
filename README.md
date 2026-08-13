# Flipp Platform SDK Sample App

This README describes how you can integrate with the Flipp Platform SDK.

## Table of Contents

- [About the SDK](#about)
- [Quick Start](#quick-start)
- [How to Integrate the SDK](#how-to)
- [Rendering Options & Advanced Features](#features)
- [Delegate Methods](#delegate-methods)

## About the SDK <a name="about"></a>

The Flipp Platform SDK allows mobile retailer apps to render publications in two
formats: in traditional print form (SFML) or in Digital Visual Merchandising
form (DVM).

The DVM format renders publications in a dynamic way that maintains
responsiveness and merchandising flexibility, while also providing a host of
features to allow users to interact with offers.

> [!NOTE]
>
> The SDK exposes self-contained value types (`Publication`, `Offer`,
> `Promotion`, `OfferPricing`, `RenderingType`, `StrategyResult`). You do not
> need any additional packages to build against it.

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

- Navigate to Package Dependencies > Click '+' to add a package.
- Enter the SDK repository's URL `https://github.com/wishabi/dvm-ios-binaries/`
  as the package URL.
- Select the package when prompted.

2. Initialize the SDK early in your application life cycle by providing a
   `clientToken` key, and an optional `userId`.

```swift
import dvm_sdk

DVMSDK.initialize(clientToken: "your-flipp-provided-key", userId: nil)
```

3. Fetch a list of publications by calling
   `DVMSDK.fetchPublicationsList(...)`. It is `async` and returns an array of
   `Publication` values:

```swift
/// - Parameters:
///   - merchantId: Merchant identifier to retrieve the publications for.
///   - storeCode: Optional store identifier used to filter the results. Pass `nil`
///     to retrieve the merchant's publications without filtering by store (useful
///     when the publication will be rendered by location rather than by store).
///   - language: The 2 character ISO language code.
///   - resultsCount: number of results per page, defaults to 10.
///   - pageToken: token for pagination, needed to fetch subsequent results.
/// - Returns: A list of `Publication`.
public static func fetchPublicationsList(
  merchantId: String,
  storeCode: String? = nil,
  language: String?,
  resultsCount: Int = 10,
  pageToken: String? = nil
) async throws -> [Publication]
```

> [!NOTE]
>
> `merchantId` is always required to list publications; `storeCode` is an optional
> filter. When you intend to render a publication **by location**, you can list
> without a store and provide the postal/country code at render time.

A `Publication` exposes `id`, `merchantId`, `name`, `description`, `imageURL`,
`validFrom`, `validTo`, `language`, `tags`, and `renderingTypes` (`[RenderingType]`,
`.dvm` / `.sfml`) so you can tell which engines a publication supports.

Example from `PublicationsViewController.swift`:

```swift
let publications = try await DVMSDK.fetchPublicationsList(
  merchantId: merchantID,
  storeCode: storeCode,
  language: Locale.preferredLanguageCode() ?? "en")
await MainActor.run { [weak self] in
  self?.publications = publications
  self?.tableView.reloadData()
}
```

4. Once a publication is selected, create an instance of `DVMRendererView` to
   render the publication and set its delegate appropriately:

```swift
/// - Parameters:
///   - publicationId: Publication id to render.
///   - publicationInfo: Location or merchant info for the publication.
///   - renderMode: The rendering mode to use (`.dvm` or `.sfml`).
///   - language: The 2 character ISO language code used to render the publication.
///   - shouldPersistWebsiteDataToDisk: Whether website data should persist to disk (default is false).
///   - disableZoom: Whether pinch-to-zoom should be disabled (default is false).
///   - linkedOfferId: The id of an offer to guarantee is linked into the publication when rendered, nil if none.
public static func createRenderingView(
  publicationId: String,
  publicationInfo: PublicationInfo,
  renderMode: RenderMode,
  language: String?,
  shouldPersistWebsiteDataToDisk: Bool = false,
  disableZoom: Bool = false,
  linkedOfferId: String? = nil
) throws -> DVMRendererView
```

`PublicationInfo` selects how the publication is located:

```swift
public enum PublicationInfo {
  case byLocation(postalCode: String, countryCode: String)
  case byMerchant(merchantId: String, storeCode: String)
}
```

Example from `PublicationViewController.swift`:

```swift
let publicationInfo: PublicationInfo = .byMerchant(merchantId: merchantId, storeCode: storeCode)

if let rendererView = try? DVMSDK.createRenderingView(
  publicationId: publicationID,
  publicationInfo: publicationInfo,
  renderMode: renderingMode,
  language: Locale.preferredLanguageCode() ?? "en",
  shouldPersistWebsiteDataToDisk: false,
  disableZoom: renderOptions.disableZoom,
  linkedOfferId: renderOptions.linkedOfferId
) {
  rendererView.rendererDelegate = self
  rendererView.translatesAutoresizingMaskIntoConstraints = false
  view.addSubview(rendererView)
  self.rendererView = rendererView
}
```

5. When the user taps an item, the delegate is called with the offer details.
   Offers are delivered as the SDK's `Offer` value type:

```swift
func didTap(result: Result<Offer, DVMSDKError>) {
  switch result {
  case .success(let offer):
    self.pushDetailsController(for: offer)
  case .failure(let error):
    Self.logger.error("Error tapping on offer: \(error.localizedDescription)")
  }
}
```

An `Offer` exposes `id`, `merchantId`, `name`, `description`, `imageURLs`,
`pricing` (`OfferPricing`), `saleStory`, `disclaimer`, `prePriceText`,
`postPriceText`, `validFrom`, and `validTo`.

## Rendering Options & Advanced Features <a name="features"></a>

The sample app's initial screen exposes a "Rendering options" section that
demonstrates the newer capabilities. All of these are shown end-to-end in
`InitialViewController.swift` and `PublicationViewController.swift`.

- **Location-based rendering** — provide a postal code + country code and the
  renderer is created with `PublicationInfo.byLocation(postalCode:countryCode:)`
  instead of `.byMerchant(...)`. In this mode a **store code is not required** — only
  the merchant (to list publications) plus the postal/country code are needed.
- **Disable zoom** — pass `disableZoom: true` to `createRenderingView` to turn
  off pinch-to-zoom.
- **Linked offer** — pass `linkedOfferId:` to guarantee a specific offer is
  linked into the publication when it renders. Pair it with
  `didReceiveStrategyResults(_:)` to detect when linking failed:

  ```swift
  func didReceiveStrategyResults(_ results: [StrategyResult]) {
    if let failure = results.first(where: { $0.errorMessage != nil }) {
      // surface failure.errorMessage — e.g. the linked offer could not be loaded
    }
  }
  ```

- **Native content overlay** — `DVMRendererView` exposes `bottomContentInset`
  and `scrollView`. Set `bottomContentInset` to reserve scroll space so your own
  native views (e.g. a footer/banner) can overlay the rendered publication
  without covering content.
- **Promotions** — handle `didTapPromotion(result:)`,
  `publicationScrollToPromotionResponse(_:)`, and
  `publicationPromotionImpression(ids:)`. Promotions are delivered as the
  `Promotion` value type.
- **Through-the-merchant (TTM) links** — handle `didTapTTM(url:)` to open the
  destination URL.
- **Scroll telemetry** — `publicationDidScroll(contentOffset:contentSize:viewportHeight:)`,
  `publicationDidEndDragging(willDecelerate:)`, and
  `publicationDidEndDecelerating()`.

## Delegate Methods <a name="delegate-methods"></a>

The Flipp Platform SDK can send events notifying your app about actions the user
has taken. Most methods have default (empty) implementations, so you only
implement the ones you need.

```swift
public protocol DVMRendererDelegate: AnyObject {
  /// Called when an offer item is tapped.
  func didTap(result: Result<Offer, DVMSDKError>)

  /// Called when a long tap is detected.
  func didLongTap(result: Result<Offer?, DVMSDKError>)

  /// Called when the offer rendering has finished loading successfully.
  func didFinishLoad(legacyMap: [String: String])

  /// Called when the offer rendering failed to load.
  func didFailToLoad(error: Error)

  /// Called when the publication has finished scrolling due to a scroll-to request.
  func publicationScrollToResponse(_ offer: Offer)

  /// Called when the publication has finished scrolling due to user interaction.
  func publicationScrollTo(flyerHeight: Int, viewportBottomOffset: Int)

  /// Called when an impression logic hits on the DVM publication.
  func publicationImpression(ids: [String])

  /// Called when a promotion impression event is received.
  func publicationPromotionImpression(ids: [String])

  /// Called when a TTM (through-the-merchant) link is tapped.
  func didTapTTM(url: URL)

  /// Called when a promotion item is tapped.
  func didTapPromotion(result: Result<Promotion, DVMSDKError>)

  /// Called when the publication has finished scrolling to a promotion.
  func publicationScrollToPromotionResponse(_ promotion: Promotion)

  /// Called when logic for an engaged visit triggers.
  func publicationTriggeredEngagedVisit()

  /// Called when the publication scrolls.
  func publicationDidScroll(contentOffset: CGPoint, contentSize: CGSize, viewportHeight: CGFloat)

  /// Called when the scroll view finishes dragging.
  func publicationDidEndDragging(willDecelerate: Bool)

  /// Called when the scroll view finishes decelerating.
  func publicationDidEndDecelerating()

  /// Called when the publication's hydration returns post-processing strategy results
  /// (e.g. the offer-linking strategy used when a `linkedOfferId` is provided).
  func didReceiveStrategyResults(_ results: [StrategyResult])
}
```
