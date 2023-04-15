import SwiftUI

struct DiffieHellmanGraphView: View {
    let g = 5
    let p = 23
    
    @Binding var pageOne: Bool
    @Binding var pageTwo: Bool
    @Binding var pageThree: Bool
    @Binding var pageFour: Bool
    @Binding var correctness: Bool
    
    @Binding var userInt: Int
    @Binding var userPublicKey: Int
    @Binding var computerPublicKey: Int
    
    @Binding var sharedSecretKey: Int
    
    var body: some View {
        VStack {
            boxify(Text("Prime base\n") + Style.monospaceBig("g = \(g)"), color: .blue).showOnBindings($pageTwo, $pageThree, $pageFour)
            Image("arrow_down").resizable().frame(width: 18, height: 18).showOnBindings($pageTwo, $pageThree, $pageFour).invertOnDarkTheme()
            boxify(Text("Prime modulus\n") + Style.monospaceBig("p = \(p)"), color: .blue).showOnBindings($pageTwo, $pageThree, $pageFour)
            HStack{
                VStack {
                    Image("arrow_left").resizable().frame(width: 18, height: 18).showOnBindings($pageTwo, $pageThree, $pageFour).invertOnDarkTheme()
                    boxify(Text("Your Secret\n") + Style.monospaceBig("a = \(userInt)"), color: .red).showOnBindings($pageTwo, $pageThree, $pageFour)
                    Image("arrow_down").resizable().frame(width: 18, height: 18).showOnBindings($pageThree, $pageFour).invertOnDarkTheme()
                    if !pageFour {
                        if #available(iOS 16.0, *) {
                            boxify(Text("Your Public Key\n") + Style.monospaceBig("A = \(userPublicKey)"), color: .blue).draggable(1).showOnBindings($pageThree)
                        } else {
                            boxify(Text("Your Public Key\n") + Style.monospaceBig("A = \(userPublicKey)"), color: .blue)
                            // MORE FALLBACK
                        }
                    } else {
                        boxify(Text("Your Public Key\n") + Style.monospaceBig("A = \(userPublicKey)"), color: .blue)
                    }
                }
                Spacer().frame(maxWidth: 25)
                VStack {
                    Image("arrow_right").resizable().frame(width: 18, height: 18).showOnBindings($pageTwo, $pageThree, $pageFour).invertOnDarkTheme()
                    boxify(Text("Computer Secret\n") + Style.monospaceBig("b = ?"), color: .red).showOnBindings($pageTwo, $pageThree, $pageFour)
                    Image("arrow_down").resizable().frame(width: 18, height: 18).showOnBindings($pageThree, $pageFour).invertOnDarkTheme()
                    boxify(Text("Computer Public Key\n") + Style.monospaceBig("B = \(computerPublicKey)"), color: .blue).showOnBindings($pageThree, $pageFour)
                }
            }
            Image("arrow_cross").resizable().aspectRatio(contentMode: .fit).frame( height: 25).showOnBindings($pageThree, $pageFour).invertOnDarkTheme()
            HStack {
                VStack {
                    boxify(Text("Computer Public Key\n") + Style.monospaceBig("B = \(computerPublicKey)"), color: .blue).showOnBindings( $pageThree, $pageFour)
                    Image("arrow_right").resizable().frame(width: 18, height: 18).showOnBindings($correctness).invertOnDarkTheme()
                }
                Spacer().frame(maxWidth: 25)
                VStack {
                    if #available(iOS 16.0, *) {
                        if !pageFour {
                            boxify(Text("Drop your public key here!"), color: .white, textColor: .black).frame(minHeight: 78).border(.gray).showOnBindings($pageThree, $pageFour)
                                .dropDestination(for: Int.self) { (items, point) in
                                    print("dropped!")
                                    pageThree = false
                                    pageFour = true
                                    return true
                                }
                        } else {
                            boxify(Text("Your Public Key\n") + Style.monospaceBig("A = \(userPublicKey)"), color: .blue)
                        }
                    } else {
                        // Fallback on earlier versions
                    }
                    Image("arrow_left").resizable().frame(width: 18, height: 18).showOnBindings($correctness).invertOnDarkTheme()
                }
            }
            //boxify(Text("Shared Secret Key \n") + Style.monospaceBig("\(sharedSecretKey)"), color: .purple).showOnBindings($correctness)
            if correctness {
                if #available(iOS 16.0, *) {
                    boxify(Text("Shared Secret Key \n") + Style.monospaceBig("\(sharedSecretKey)"), color: .purple).transition(.moveAndFade)
                } else {
                    boxify(Text("Shared Secret Key \n") + Style.monospaceBig("\(sharedSecretKey)"), color: .purple)
                }
            }
        }
        .animation(.default, value: correctness)
        .padding()
        .multilineTextAlignment(.center)
    }
    
    func boxify(_ t: Text, color: Color, textColor: Color = .white) -> some View {
        if #available(iOS 16.0, *) {
            return t.padding().frame(maxWidth: .infinity).foregroundColor(textColor).background(color).transition(.push(from: .bottom))
        } else {
            return t.padding().frame(maxWidth: .infinity).foregroundColor(textColor).background(color)
        }
    }
}

@available(iOS 16.0, *)
extension Int: Transferable {
    public static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(for: Int.self, contentType: .data)
    }
}
