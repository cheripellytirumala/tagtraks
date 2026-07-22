import SwiftUI
import GoogleMaps
import GooglePlaces

@main
struct iOSApp: App {
    init() {
        GMSServices.provideAPIKey("AIzaSyC1PhVstBZfeWCpN7VUKUNCAcP9lhXf108")
        GMSPlacesClient.provideAPIKey("AIzaSyC1PhVstBZfeWCpN7VUKUNCAcP9lhXf108")
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
