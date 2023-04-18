import SwiftUI
import Combine

struct DiffieHellmanView: View {
    
    @StateObject var viewModel = DiffieHellmanViewModel()
    
    @Binding var pageDiffie: Bool
    @Binding var pageQuantum: Bool
    @Binding var publicKeyColor: Color
    @Binding var secretKeyColor: Color
    
    var body: some View {
        GeometryReader { geo in
            HStack{
                VStack(alignment: .leading, spacing: 25) {
                    Text("Diffie Hellman Key Exchange").font(.system(.title)).fontWeight(.bold).frame(maxWidth: .infinity, alignment: .leading)
                    if viewModel.pageOne {
                        // display page one text
                        VStack {
                            DiffieHellmanTextOne()
                            Button("Next >") {
                                // hide this page and display next page
                                viewModel.pageOne = false
                                viewModel.pageTwo = true
                            }
                            .buttonStyle(BlueButton())
                        }.frame(maxWidth: .infinity).transition(.pushFromBottom)
                    }
                    if viewModel.pageTwo {
                        // display page two text
                        VStack(alignment: .leading, spacing: 25) {
                            DiffieHellmanTextTwo()
                            Picker("Pick your secret color", selection: $viewModel.userColor) {
                                Text("Green").tag(Color.green)
                                Text("Cyan").tag(Color.cyan)
                                Text("Teal").tag(Color.teal)
                                Text("Mint").tag(Color.mint)
                            }
                            .padding(2)
                            .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color.gray, style: StrokeStyle(lineWidth: 1.0)))
                            Button("Next >") {
                                // hide this page and display next page
                                viewModel.pageTwo = false
                                viewModel.pageThree = true
                                viewModel.baseMixable = true
                            }
                            .buttonStyle(BlueButton())
                        }.frame(maxWidth: .infinity).transition(.pushFromBottom)
                    }
                    if viewModel.pageThree {
                        // display page three text
                        VStack(alignment: .leading, spacing: 25) {
                            DiffieHellmanTextThree()
                            Button("Next >") {
                                // hide this page and display next page
                                viewModel.pageThree = false
                                viewModel.pageFour = true
                                viewModel.mixedDroppable = true
                            }
                            .disabled(viewModel.baseMixable == true)
                            .buttonStyle(BlueButton())
                        }
                        .frame(maxWidth: .infinity)
                        .transition(.pushFromBottom)
                    }
                    if viewModel.pageFour {
                        // display page four text
                        DiffieHellmanTextFour().frame(maxWidth: .infinity).transition(.pushFromBottom)
                    }
                    if viewModel.pageFive {
                        VStack(alignment: .leading, spacing: 25) {
                            DiffieHellmanTextFive()
                            Button("Next >") {
                                // hide this page and display next page
                                viewModel.pageFive = false
                                viewModel.pageSix = true
                            }
                            .buttonStyle(BlueButton())
                            .disabled(viewModel.sharedRevealed == false)
                        }.frame(maxWidth: .infinity).transition(.pushFromBottom)
                    }
                    if viewModel.pageSix && !viewModel.secretRevealed {
                        VStack(alignment: .leading, spacing: 25) {
                            DiffieHellmanTextSix()
                            
                            Button("Reveal Computer Secret Colors") {
                                viewModel.secretRevealed = true
                            }
                            .buttonStyle(BlueButton())
                            .disabled(viewModel.secretRevealed == true)
                        }.frame(maxWidth: .infinity).transition(.pushFromBottom)
                    }
                    if viewModel.secretRevealed {
                        VStack {
                            DiffieHellmanTextSixSub()
                            Button("Next Chapter >") {
                                // update data needed for next chapter
                                publicKeyColor = viewModel.userBlended.wrappedValue
                                secretKeyColor = viewModel.userColor
                                // go to next chapter
                                pageDiffie = false
                                pageQuantum = true
                            }
                            .buttonStyle(IndigoButton())
                            .disabled(viewModel.secretRevealed == false)
                        }.frame(maxWidth: .infinity).transition(.enterFromBottom)
                    }
                    Spacer()
                }
                .frame(maxWidth: geo.size.width*0.333)
                .animation(.default, value: viewModel.pageOne)
                .animation(.default, value: viewModel.pageTwo)
                .animation(.default, value: viewModel.pageThree)
                .animation(.default, value: viewModel.pageFour)
                .animation(.default, value: viewModel.pageFive)
                .animation(.default, value: viewModel.pageSix)
                .animation(.default, value: viewModel.secretRevealed)
                .padding()
                
                Divider()
                
                VStack{
                    Spacer()
                    DiffieHellmanGraphView(viewModel: viewModel)
                    Spacer()
                }.padding()
            }
            .minimumScaleFactor(0.75)
            .padding()
        }
    }
}

struct DiffieHellmanTextOne: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Diffie Hellman is an algorithm that creates a 'secret' key that is shared between two users.")
            Text("We will simplify this by using colors instead of numbers. Let's create a shared color key, but only between me and you.")
        }
    }
}

struct DiffieHellmanTextTwo: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("We start with a publicly shared base color. Let's chose red.")
            Text("Then we each choose a secret color. This is not public, so we don't share this with each other.")
            Text("Choose your secret color below!")
        }
    }
}

struct DiffieHellmanTextThree: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Mix the red color with your secret color.")
            Text("Do so by dragging and dropping the red color onto your secret color.")
            Text("This will create a mixed color, which we can call our individual 'public key'. Unlike the secret color, this is shared publicly to the other person.")
        }
    }
}

struct DiffieHellmanTextFour: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Let's exchange our public keys.")
            Text("I just sent you my public key, which is orange.")
            Text("Send me your public key by dragging and dropping your mixed color into my box.")
        }
    }
}

struct DiffieHellmanTextFive: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("The last step is to mix the other person's 'public key' with your own secret color. That mixed color is our 'shared secret key'.")
            Text("Drag and drop my public key onto your secret color.")
        }
    }
}

struct DiffieHellmanTextSix: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Great job! You have created your 'shared secret key' color.")
            Text("For demonstration purposes, press the button below to reveal my secret colors.")
            Text("In an actual situation you won't know my secret color.")
        }
    }
}
struct DiffieHellmanTextSixSub: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Notice that we got the same 'shared secret key' color!")
            Text("To an outsider that only sees the 'public keys', they cannot guess the 'shared secret key' color. This is because it is hard to unmix colors (the public keys). Without one of the secret colors, outsiders cannot know our 'shared secret key' color.")
            Text("However, if somebody somehow knows one of the two secret colors, they can guess the 'shared secret key' color very easily.")
        }
    }
}

@MainActor class DiffieHellmanViewModel: ObservableObject {
    
    let baseColor: Color = .red
    @Published var userColor: Color = .green
    let computerColor: Color = .yellow
    
    var userBlended: Binding<Color> { Binding(
        get: { self.baseColor.blend(color: self.userColor) },
        set: {_ in})
    }
    var computerBlended: Binding<Color> { Binding(
        get: { self.baseColor.blend(color: self.computerColor) },
        set: {_ in})
    }
    var sharedBlended: Binding<Color> { Binding(
        get: { self.userBlended.wrappedValue.blend(color: self.computerColor) },
        set: {_ in})
    }
    
    @Published var pageOne = true // only show page one at start
    @Published var pageTwo = false
    @Published var pageThree = false
    @Published var pageFour = false
    @Published var pageFive = false
    @Published var pageSix = false
    
    @Published var baseMixable: Bool = false
    @Published var mixedDroppable: Bool = false
    @Published var sharedRevealed: Bool = false
    @Published var secretRevealed: Bool = false
    @Published var sharedMixable: Bool = false
    
}

struct DiffieHellmanView_Previews: PreviewProvider {
    static var previews: some View {
        DiffieHellmanView(pageDiffie: .constant(true), pageQuantum: .constant(false), publicKeyColor: .constant(.green), secretKeyColor: .constant(.blue)).previewInterfaceOrientation(.landscapeLeft)
    }
}
