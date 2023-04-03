import SwiftUI

struct DiffieHellmanView: View {
    
    @State var pageOne = true // only show page one at start
    @State var pageTwo = false
    
    @State var message = ""
    @State var userPrimeIndexDbl = 18.0 // double value of the prime number array index
    
    // array of useable prime numbers
    let primeNumbers = [5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73,79,83,89,97,101,103,107,109,113,127,131,137,139,149,151,157,163,167,173,179,181,191,193,197,199]
    
    var body: some View {
        GeometryReader { geo in
            HStack{
                VStack(spacing: 20) {
                    if pageOne {
                        // display page one text
                        DiffieHellmanTextpageOne()
                        TextField("Type message here...", text: $message)
                            .padding()
                            .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color.gray, style: StrokeStyle(lineWidth: 1.0)))
                        Button("Next") {
                            // hide this page and display next page
                            pageOne = false
                            pageTwo = true
                        }
                        .buttonStyle(BlueButton())
                        .disabled(message == "")
                    }
                    if pageTwo {
                        // display page two text
                        DiffieHellmanTextpageTwo()
                        Slider(value: $userPrimeIndexDbl, in: 0...Double((primeNumbers.count-1)))
                        Text("Your prime number: ") + Text("\(userPrimeIndexDbl)").font(.custom("menlo", size: 30))
                            .foregroundColor(.blue)
                    }
                    Spacer()
                }
                .font(.system(size: 30))
                .frame(maxWidth: geo.size.width*0.333)
                .padding()
                
                Divider()
                
                VStack{
                    Spacer()
                    Text("Spritekit Here")
                    Spacer()
                }.padding()
            }
            .navigationTitle("Diffie Hellman")
            .padding()
        }
    }
}

struct DiffieHellmanTextpageOne: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Diffie Hellman is an algorithm that creates a 'secret' key that is shared between two users.")
            Text("Let's demonstrate this by assuming you want to send something to me encrypted.")
            Text("First, enter a word that you want to send to me.")
        }
    }
}

struct DiffieHellmanTextpageTwo: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Now, I want you to choose a prime number, and I will choose a prime number as well.")
            Text("Then we will exchange our prime numbers.")
        }
    }
}

struct DiffieHellmanView_Previews: PreviewProvider {
    static var previews: some View {
        DiffieHellmanView().previewInterfaceOrientation(.landscapeLeft)
    }
}
