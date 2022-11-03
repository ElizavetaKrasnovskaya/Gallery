import Foundation

final class StorageService {
    
    static let shared = StorageService()
    private let storage = UserDefaults.standard
    
    var isFirstLaunch: Bool {
        get {
            !storage.bool(forKey: UserDefaultsConstants.FIRST_LAUNCH_KEY)
        }
        set {
            storage.set(!newValue, forKey: UserDefaultsConstants.FIRST_LAUNCH_KEY)
        }
    }
    
    var pinCode: String {
        get {
            storage.string(forKey: UserDefaultsConstants.PIN_CODE_KEY) ?? ""
        }
        set {
            storage.set(newValue, forKey: UserDefaultsConstants.PIN_CODE_KEY)
        }
    }
}
