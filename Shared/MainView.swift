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
                ResultView(link: link, message: message)

            case .idle:
                EmptyView()
            }

            Spacer()
        }
        #if os(macOS)
        .frame(width: 600, height: model.state.isSuccess ? 490 : 150)
        #endif
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
