import SwiftUI

struct QuantumView: View {
    
    @StateObject var viewModel = QuantumViewModel()
    
    @Binding var pageQuantum: Bool
    @Binding var pageFinish: Bool
    
    @Binding var publicKeyColor: Color
    @Binding var secretKeyColor: Color
    
    var body: some View {
        GeometryReader { geo in
            HStack {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Shor's Algorithm")
                        .font(.system(.title))
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .center)
                    Spacer()
                    if viewModel.pageOne {
                        QuantumViewPageOne()
                        Button("Next") {
                            viewModel.pageOne = false
                            viewModel.pageTwo = true
                            viewModel.publicKeyDraggable = true
                        }.buttonStyle(BlueButton())
                    }
                    if viewModel.pageTwo {
                        QuantumViewPageTwo()
                    }
                    if viewModel.pageThree {
                        QuantumViewPageThree()
                        Button("Finish!") {
                            pageQuantum = false
                            pageFinish = true
                        }.buttonStyle(BlueButton())
                    }
                    Spacer()
                }
                .frame(maxWidth: geo.size.width*0.333)
                .padding()
                
                Divider()
                
                VStack {
                    QuantumGraphView(viewModel: viewModel, publicKeyColor: $publicKeyColor, secretKeyColor: $secretKeyColor)
                }
            }
        }
    }
}

class QuantumViewModel: ObservableObject {
    @Published var publicKeyDraggable = false
    
    @Published var pageOne = true
    @Published var pageTwo = false
    @Published var pageThree = false
}

struct QuantumViewPageOne: View {
    var body: some View {
        Text("Note that the Diffie Hellman method assumes that it is very hard to unmix the 'colors' that make up the public key.")
        Text("It is indeed very hard in a normal computer, but this is very easy to do on a quantum computer.")
        Text("This algorithm, which only works on quantum computers, is called 'Shor's Algorithm'.")
    }
}

struct QuantumViewPageTwo: View {
    var body: some View {
        Text("Try running your public key from before through Shor's Algorithm.")
        Text("Drag and drop the mixed public key color onto the quantum computer.")
    }
}

struct QuantumViewPageThree: View {
    var body: some View {
        Text("The quantum computer has unmixed our color. They have revealed our secret from just the public information!")
        Text("Therefore, researchers are desinging new algorithms that cannot be broken by quantum computers.")
        Text("However, since quantum computers are very expensive and hard to make currently, it does not pose too much risk at this moment.")
    }
}

struct QuantumView_Previews: PreviewProvider {
    static var previews: some View {
        QuantumView(pageQuantum: .constant(true), pageFinish: .constant(false), publicKeyColor: .constant(.green), secretKeyColor: .constant(.blue)).previewInterfaceOrientation(.landscapeLeft)
    }
}
