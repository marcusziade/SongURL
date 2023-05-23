import SwiftUI

struct MainView: View {

    @StateObject var model = ViewModel(service: SongLinkService())

    var body: some View {
        VStack(spacing: 16) {
            #if os(iOS)
            Spacer()
            #endif
            
            TextField("Link", text: $model.searchURL)
                .multilineTextAlignment(.center)
            Button {
                Task { try await model.generate() }
            } label: {
                Text("Generate Song.link URL")
            }

            switch model.state {
            case .loading:
                ProgressView()
#if os(macOS)
                    .progressViewStyle(.linear)
                    .frame(width: 150)
#endif
                Text(model.state.title)

            case .error(let message):
                Text(message)
                    .foregroundColor(.red)

            case .result(let link, let message):
                ScrollView {
                    VStack(spacing: 24) {
                        ResultView(link: link, message: message)
                        
#if os(macOS)
                        let columnCount = 4
#else
                        let columnCount = 2
#endif
                        let columns: [GridItem] = Array(repeating: .init(.flexible()), count: columnCount)
                        
                        LazyVGrid(columns: columns, alignment: .leading) {
                            ForEach(Array(zip(link.availablePlatformTitles, link.availablePlatformUrls)), id: \.0) { platformTitle, platformURL in
                                Button {
                                    // TODO: Copy platform url to clipboard with model method.
                                } label: {
                                    Text(platformTitle)
                                }
                            }
                        }
                    }
                }

            case .idle:
                EmptyView()
            }

            Spacer()
        }
        #if os(macOS)
        .frame(width: 600, height: model.state.isSuccess ? 600 : 150)
        #endif
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
