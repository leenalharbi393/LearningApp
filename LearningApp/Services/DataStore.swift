import Foundation

/// Saves and loads AppData on the device, as JSON in UserDefaults.
struct DataStore {
    private let key = "appData"
    private let defaults = UserDefaults.standard

    /// The saved data, or nil if nothing was saved yet (or it couldn't be read).
    func load() -> AppData? {
        guard let data = defaults.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(AppData.self, from: data)
    }

    func save(_ appData: AppData) {
        guard let data = try? JSONEncoder().encode(appData) else { return }
        defaults.set(data, forKey: key)
    }
}
