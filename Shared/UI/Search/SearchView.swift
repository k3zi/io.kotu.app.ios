import SwiftUI

struct SearchView: View {

    @ObservedObject var model: SearchModel
    @EnvironmentObject var service: AppService

    var body: some View {
        NavigationView {
            VStack {
                Picker(selection: $model.request.type, label: Text("Type")) {
                    ForEach(SearchType.allCases, id: \.self) {
                        Text($0.displayValue)
                    }
                }
                .pickerStyle(.segmented)

                if model.isLoading {
                    VStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                } else {
                    results
                }
            }
            .padding(.horizontal)
            .searchable(text: $model.request.query, prompt: "日本語を入力してください")
            .navigationTitle("Search")
        }
        #if os(iOS)
        .navigationViewStyle(.stack)
        #endif
    }

    @ViewBuilder
    var results: some View {
        VStack(spacing: 0) {
            List {
                ForEach(model.results, id: \.stringID) { result in
                    body(for: result)
                }

                if model.canLoadNextPage {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                    .onAppear {
                        model.loadNextPage()
                    }
                }
            }
            .listStyle(.plain)

            Divider()
                .padding(.bottom, 8)

            HStack {
                Spacer()
                Text("**Total Results**: \(model.totalResults)")
                Spacer()
            }
            .padding(.bottom, 8)
        }
    }

    @ViewBuilder
    func body(for result: SearchResult) -> some View {
        if let result = result as? SearchWordResult {
            NavigationLink {
                DictionaryEntryView(model: .init(service: service, headword: .searchWordResult(result)))
                    .navigationBarTitle("", displayMode: .inline)
            } label: {
                SearchWordResultView(result: result, model: model)
            }
        }

        if let result = result as? SearchVideoResult {
            SearchVideoResultView(result: result)
        }

        if let result = result as? SearchOtherResult {
            SearchOtherResultView(result: result)
        }
    }

}

struct SearchWordResultView: View {

    let result: SearchWordResult
    @ObservedObject var model: SearchModel
    @EnvironmentObject var service: AppService

    var body: some View {
        HStack {
            AsyncImage(url: model.dictionaryIcon(for: result), loader: service) { image in
                image
                    .resizable()
                    .cornerRadius(4)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 50, height: 50)
            .padding(.vertical, 4)
            .padding(.trailing)

            VStack(alignment: .leading, spacing: 6) {
                Text(result.headline)
                    .lineLimit(nil)

                if !result.tags.isEmpty {
                    HStack {
                        ForEach(result.tags, id: \.self) {
                            TagView($0)
                                .font(.caption)
                        }
                    }
                }
            }
        }
    }

}

struct SearchVideoResultView: View {

    let result: SearchVideoResult

    @EnvironmentObject var audioService: AudioService
    @EnvironmentObject var service: AppService

    var body: some View {
        HStack {
            AsyncImage(url: result.video.thumbnailURL, loader: service) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(4)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 50, height: 50)
            .padding(.vertical, 4)
            .padding(.trailing)

            VStack(alignment: .leading, spacing: 4) {
                Text(result.text)
                    .lineLimit(nil)

                HStack {
                    Text(result.video.title)
                        .font(.caption)
                        .lineLimit(1)
                }
            }
        }
    }

}

struct SearchOtherResultView: View {

    let result: SearchOtherResult

    @EnvironmentObject var audioService: AudioService

    var body: some View {
        Button {
            try? audioService.play(endpoint: "media/external/audio/\(result.externalFile.id)")
        } label: {
            VStack(alignment: .leading, spacing: 4) {
                Text(result.text)
                    .lineLimit(nil)

                HStack {
                    Text(result.video.title)
                        .font(.caption)
                        .lineLimit(1)
                    ForEach(result.video.tags, id: \.self) {
                        TagView($0)
                            .font(.caption)
                    }
                }
            }
        }
    }

}
