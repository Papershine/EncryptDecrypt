import SwiftUI
import Combine

struct DiffieHellmanView: View {
    
    let p = 23
    let g = 5
    
    @State var pageOne = true // only show page one at start
    @State var pageTwo = false
    @State var pageThree = false
    @State var pageFour = false
    
    @State var message = ""
    
    // the user chosen prime secret
    @State var userPrimeIndexDbl = 18.0 // double value of the prime number array index
    var primeNumSecret: Int {
        primeNumbers[Int(round(userPrimeIndexDbl))]
    } // computed prime number
    
    // the agreed integer
    @State var integerIndexDbl = 125.0
    var userInt: Binding<Int> { Binding(
            get: { Int(round(integerIndexDbl)) },
            set: { _ in }
        )
    }
    
    // array of useable prime numbers
    let primeNumbers = [5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73,79,83,89,97,101,103,107,109,113,127,131,137,139,149,151,157,163,167,173,179,181,191,193,197,199]
    
    // the computed integer
    let generatedInt: Int = Int.random(in: 1...250)
    
    var userShared: Binding<Int> { Binding(
        get: { g ^ userInt.wrappedValue % p },
        set: { _ in }
    )}
    
    var computerShared: Binding<Int> { Binding(
        get: { g ^ generatedInt % p },
        set: { _ in }
    )}
    
    var sharedSecret: Binding<Int> { Binding(
        get: { userShared.wrappedValue ^ generatedInt },
        set: { _ in }
    )}
    
    @State var calculatedKey: String = "0"
    var correctness: String {
        Int(calculatedKey) == sharedSecret.wrappedValue ? "Correct!" : "Wrong number!"
    }
    
    var body: some View {
        GeometryReader { geo in
            HStack{
                VStack(spacing: 20) {
                    if pageOne {
                        // display page one text
                        DiffieHellmanTextOne()
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
                        DiffieHellmanTextTwo()
                        Slider(value: $integerIndexDbl, in: 1...250)
                        Text("Your integer number: ") + Text("\(userInt.wrappedValue)").font(.custom("menlo", size: 30))
                            .foregroundColor(.blue)
                        Button("Next") {
                            // hide this page and display next page
                            pageTwo = false
                            pageThree = true
                        }
                        .buttonStyle(BlueButton())
                    }
                    if pageThree {
                        // display page three text
                        DiffieHellmanTextThree(computerShared: computerShared.wrappedValue)
                    }
                    if pageFour {
                        // display page four text
                        DiffieHellmanTextFour(userInt: userInt.wrappedValue, computerShared: computerShared.wrappedValue, sharedSecret: sharedSecret.wrappedValue)
                        TextField("Type calculated number here...", text: $calculatedKey)
                            .keyboardType(.numberPad)
                            .onReceive(Just(calculatedKey)) { newValue in
                                let filtered = newValue.filter { "0123456789".contains($0) }
                                if filtered != newValue {
                                    self.calculatedKey = filtered
                                }
                            }
                            .padding()
                            .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color.gray, style: StrokeStyle(lineWidth: 1.0)))
                        Text("\(correctness)")
                        if correctness == "Correct!" {
                            CorrectText()
                        }
                    }
                    Spacer()
                }
                .frame(maxWidth: geo.size.width*0.333)
                .padding()
                
                Divider()
                
                VStack{
                    Spacer()
                    DiffieHellmanGraphView(pageOne: $pageOne, pageTwo: $pageTwo, pageThree: $pageThree, userInt: userInt, userPublicKey: userShared, computerPublicKey: computerShared, sharedSecretKey: sharedSecret)
                    Spacer()
                }.padding()
            }
            .minimumScaleFactor(0.75)
            .navigationTitle("Diffie Hellman")
            .padding()
        }
    }
}

struct DiffieHellmanTextOne: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Diffie Hellman is an algorithm that creates a 'secret' key that is shared between two users.")
            Text("Let's demonstrate this by assuming you want to send something to me encrypted.")
            Text("First, enter a word that you want to send to me.")
        }
    }
}

struct DiffieHellmanTextTwo: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("First, we will publicly agree on two shared numbers. The first integer must be a prime number, which we call the 'modulus', or 'p'. Let's choose p = 23.")
            Text("Next, we have to choose an integer that has to be a primitive root modulo p, called the 'base' or 'g'. Let's choose g = 5.")
            Text("Now, I want you to choose an integer, and I will choose an integer as well.")
            Text("Let's call your secret prime number a, and my secret prime number b.")
            Text("However, we have to keep these integers secret and not share it with each other.")
        }
    }
}

struct DiffieHellmanTextThree: View {
    var computerShared: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Great! Now, we will share the value of ") + Text("g").font(.custom("menlo", size: 30)).foregroundColor(.blue) + Text("secret").font(.custom("menlo", size: 18)).baselineOffset(7.0).foregroundColor(.blue) + Text(" mod p").font(.custom("menlo", size: 30)).foregroundColor(.blue)
            Text("I have sent you my value, which I calculated to be ") + Text("\(computerShared)").font(.custom("menlo", size: 30)).foregroundColor(.blue) + Text(".")
            Text("Please drag the value of your (thing) to the box to share your value to me.")
        }
    }
}

struct DiffieHellmanTextFour: View {
    var userInt: Int
    var computerShared: Int
    var sharedSecret: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Now, you will calculate your key, the value the value that I sent you raised to the power of your secret, and I will do so to.")
            
            Text("Using the number you sent me, I calculated my key to be ") + Text("\(sharedSecret)") + Text(".")
            
            Text("You can calculate your key too. What is the value I sent you, \(computerShared), raised to the power of the your secret, \(userInt)? (You can use a calculator)")
        }
    }
}

struct DiffieHellmanTextFive: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Great!")
        }
    }
}

struct CorrectText: View {
    var body: some View {
        Text("So we have generated the same shared key that is kept secret! This is the case because you calculated") + monospace("(") + gComputerSecret() + monospace(")") + superscript(" your secret ") + Text(" , and I calculated ") + monospace("(") + gYourSecret() + monospace(")") + superscript(" computer secret ") + Text(", which are just the same number.")
        Text("Since the modulo operator is distributive, both of these calculations are") + monospace("g") + superscript("your secret * computer secret") + monospace(" mod p ") + Text(".")
        Text("Therefore if we choose big enough numbers, it becomes too hard to calculate the secrets that make up both ") + gYourSecret() + Text(" and ") + gComputerSecret() + Text(", even though people can publicly see ") + monospace("p") + Text(",") + monospace("g") + Text(",") + gYourSecret() + Text(" and ") + gComputerSecret() + Text(", without knowing the actual secret integers.")
        Text("So the keys cannot be guessed nor used by anybody else except the people who have either secret integer.")
    }
    
    func gYourSecret() -> Text {
        return Text("g").font(.custom("menlo", size: 30)).foregroundColor(.blue) + Text(" your secret").font(.custom("menlo", size: 18)).baselineOffset(7.0).foregroundColor(.blue) + Text(" mod p").font(.custom("menlo", size: 30)).foregroundColor(.blue)
    }
    
    func gComputerSecret() -> Text {
        return Text("g").font(.custom("menlo", size: 30)).foregroundColor(.blue) + Text("computer secret").font(.custom("menlo", size: 18)).baselineOffset(7.0).foregroundColor(.blue) + Text(" mod p").font(.custom("menlo", size: 30)).foregroundColor(.blue)
    }
    
    func superscript(_ t: String) -> Text {
        return monospace(t).baselineOffset(7.0).foregroundColor(.blue)
    }
    
    func monospace(_ t: String) -> Text {
        return Text(t).font(.custom("menlo", size: 18))
    }
}

struct DiffieHellmanView_Previews: PreviewProvider {
    static var previews: some View {
        DiffieHellmanView().previewInterfaceOrientation(.landscapeLeft)
    }
}
