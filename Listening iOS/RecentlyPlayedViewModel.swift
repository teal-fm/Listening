import Foundation
import MusicKit

@MainActor
class RecentlyPlayedViewModel: ObservableObject {
    @Published var recentlyPlayedItems: [MusicItemCollection<MusicKit.Track>] = []
    @Published var error: Error?
    
    func requestMusicAuthorization() async {
        let status = await MusicAuthorization.request()
        switch status {
        case .authorized:
            await fetchRecentlyPlayed()
        default:
            error = NSError(domain: "MusicKit", code: 0, userInfo: [NSLocalizedDescriptionKey: "Music access not authorized"])
        }
    }
    
    func fetchRecentlyPlayed() async {
        do {
            var request = MusicLibraryRequest<MusicKit.Track>()
            request.limit = 25
            
            let response = try await request.response()
            recentlyPlayedItems = [response.items]
        } catch {
            self.error = error
        }
    }
} 