import SwiftUI

struct QuantumView: View {
    
    @StateObject var viewModel = QuantumViewModel()
    
    var body: some View {
        GeometryReader { geo in
            HStack {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Shor's Algorithm")
                        .font(.system(.title))
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .center)
                    Spacer()
                    QuantumViewPageOne()
                    Spacer()
                }
                .frame(maxWidth: geo.size.width*0.333)
                .padding()
                
                Divider()
                
                VStack {
                    
                }
            }
        }
    }
}

class QuantumViewModel: ObservableObject {
    
}

struct QuantumViewPageOne: View {
    var body: some View {
        Text("Note that the Diffie Hellman method assumes that it is very hard to unmix the 'colors' that make up the public key.")
        Text("It is indeed very hard in a normal computer, but this is very easy to do on a quantum computer.")
        Text("This algorithm, which only works on a quantum computer, is called 'Shor's Algorithm'.")
    }
}

struct QuantumViewPageTwo: View {
    var body: some View {
        Text("Try running your public key from before through the quantum computer.")
        Text("Drag and drop the mixed public key color onto the quantum computer.")
    }
}

struct QuantumViewPageThree: View {
    var body: some View {
        Text("The quantum computer has unmixed our color. They have revealed our secret just from our public key!")
        Text("Therefore, newer algorithms that cannot be broken by quantum computers are being designed.")
    }
}

struct QuantumView_Previews: PreviewProvider {
    static var previews: some View {
        QuantumView().previewInterfaceOrientation(.landscapeLeft)
    }
}
