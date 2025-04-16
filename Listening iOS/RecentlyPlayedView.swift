import SwiftUI
import MusicKit

struct RecentlyPlayedView: View {
    @StateObject private var viewModel = RecentlyPlayedViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                if let error = viewModel.error {
                    VStack {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor(.red)
                        Text(error.localizedDescription)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                } else if viewModel.recentlyPlayedItems.isEmpty {
                    ProgressView()
                } else {
                    List {
                        ForEach(viewModel.recentlyPlayedItems, id: \.self) { collection in
                            ForEach(collection) { track in
                                TrackRow(track: track)
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Recently Played")
            .task {
                await viewModel.requestMusicAuthorization()
            }
        }
    }
}

struct TrackRow: View {
    let track: MusicKit.Track
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: track.artwork?.url(width: 60, height: 60)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(width: 60, height: 60)
            .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(track.title)
                    .font(.headline)
                Text(track.artistName)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
} 
