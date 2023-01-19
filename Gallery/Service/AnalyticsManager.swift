import Foundation
import FirebaseAnalytics

final class AnalyticsManager {
    
    static let shared = AnalyticsManager()
    
    func addImage(_ imageId: String) {
        Analytics.logEvent("add_image", parameters: [
            "full_text": imageId as NSObject,
        ])
    }
    
    //TODO replace with userId
    func createPasscode(_ passcode: String) {
        Analytics.logEvent("create_passcode", parameters: [
            "full_text": passcode as NSObject
        ])
    }
    
    func enterPasscode(_ passcode: String) {
        Analytics.logEvent("enter_passcode", parameters: [
            "full_text": passcode as NSObject
        ])
    }
    
    private init() {}
}
