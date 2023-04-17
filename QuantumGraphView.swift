import SwiftUI

// 'quantum_computer' vector image modified from https://publicdomainvectors.org/en/free-clipart/Image-of-scheme-of-an-atom-in-black-and-white/35163.html by 'OpenClipart' licensed under a public domain license

struct QuantumGraphView: View {
    
    @ObservedObject var viewModel: QuantumViewModel
    
    @Binding var publicKeyColor: Color
    @Binding var secretKeyColor: Color
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                Spacer()
                
                // Public Key from prev
                if #available(iOS 16.0, *) {
                    Style.boxify(Text("Your public key"), color: publicKeyColor)
                        .frame(maxWidth: geo.size.width*0.5)
                        .draggable("key")
                        .disabled(viewModel.publicKeyDraggable == false)
                } else {
                    Style.boxify(Text("Your public key"), color: publicKeyColor)
                        .frame(maxWidth: geo.size.width*0.5)
                }
                Image("arrow_down")
                    .resizable()
                    .frame(width: 18, height: 18)
                    .invertOnDarkTheme()
                    .transition(.enterFromBottom)
                
                // Quantum Computer with Shor's Algorithm
                if #available(iOS 16.0, *) {
                    Image("quantum_computer")
                        .dropDestination(for: String.self) { _, _ in
                            viewModel.publicKeyDraggable = false
                            viewModel.pageTwo = false
                            viewModel.pageThree = true
                            return true
                        }
                }
                Text("Quantum Computer running Shor's Algorithm")
                
                if viewModel.pageThree {
                    // Unmixed colors
                    HStack {
                        // your secret
                        VStack {
                            Image("arrow_left")
                                .resizable()
                                .frame(width: 18, height: 18)
                                .invertOnDarkTheme()
                                .transition(.enterFromBottom)
                            Style.boxify(Text("User Secret"), color: secretKeyColor)
                                .frame(maxWidth: geo.size.width*0.5)
                        }
                        Spacer().frame(maxWidth: 25)
                        // base color
                        VStack {
                            Image("arrow_right")
                                .resizable()
                                .frame(width: 18, height: 18)
                                .invertOnDarkTheme()
                                .transition(.enterFromBottom)
                            Style.boxify(Text("Base Color"), color: .red)
                                .frame(maxWidth: geo.size.width*0.5)
                        }
                    }.transition(.enterFromBottom)
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .animation(.default, value: viewModel.pageThree)
        }
    }
}
