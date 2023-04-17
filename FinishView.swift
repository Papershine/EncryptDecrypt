import SwiftUI

struct FinishView: View {
    var body: some View {
        Spacer()
        HStack {
            Spacer()
            VStack(spacing: 15) {
                Text("That is a simple overview of some encryption and decryption methods.")
                Text("Thank You!").fontWeight(.bold)
            }
            .multilineTextAlignment(.center)
            .font(.system(.largeTitle))
            Spacer()
        }
        Spacer()
    }
}

struct FinishView_Previews: PreviewProvider {
    static var previews: some View {
        FinishView()
    }
}
