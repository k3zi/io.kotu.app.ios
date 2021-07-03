import SwiftUI

struct TagView: View {

    let string: String

    init(_ s: String) {
        self.string = s
    }

    var body: some View {
        Text(string)
            .bold()
            .foregroundColor(.white)
            .padding(.vertical, 2)
            .padding(.horizontal, 6)
            .background(.gray)
            .cornerRadius(4)
    }

}
