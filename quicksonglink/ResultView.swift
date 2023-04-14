import SwiftUI

struct ResultView: View {

    let link: LinksResponse
    let message: String

    var body: some View {
        VStack(spacing: 8) {
            Text(message)
                .foregroundColor(.green)

            AsyncImage(url: link.thumbnailURL) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(height: 220)
                    .cornerRadius(8)
                    .shadow(color: .black, radius: 5, x: 2, y: 2)
            } placeholder: {
                ProgressView()
            }
            .padding(.top, 24)
            .padding(.bottom, 16)

            Text(link.artist.capitalized)
                .font(.largeTitle)
            Text(link.title.capitalized)
                .font(.title)
            Label(link.type.rawValue.capitalized, systemImage: link.type.icon)
        }
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ResultView(link: LinksResponse.mock, message: "Song.link URL copied to the clipboard")
                .frame(width: 400, height: 400)
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark mode")

            ResultView(link: LinksResponse.mock, message: "Song.link URL copied to the clipboard")
                .frame(width: 400, height: 400)
                .preferredColorScheme(.light)
                .previewDisplayName("Light mode")
        }
    }
}
