import SwiftUI

struct ReaderView: View {

    @ObservedObject var model: ReaderModel

    var body: some View {
        VStack {
            VStack(spacing: 10) {
                if model.displayOptions {
                    TextField("Enter Text / Article URL", text: $model.input)
                        .padding(.horizontal)
                        .padding(.vertical, 6)
                        .background(.quaternary)
                        .cornerRadius(8)
                        .padding(.horizontal)
                }

                Image(systemName: "chevron.compact.up")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .rotationEffect(model.displayOptions ? .zero : .degrees(180))
                    .frame(height: 8)
                    .foregroundStyle(.secondary)
                    .onTapGesture {
                        model.displayOptions.toggle()
                    }
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 10)
            .background(.tertiary)
            .animation(.linear, value: model.displayOptions)
            Spacer()
        }
        .navigationBarTitle("Reader", displayMode: .inline)
    }

}
