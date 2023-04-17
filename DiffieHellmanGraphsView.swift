import SwiftUI

struct DiffieHellmanGraphsView: View {
    let g = 5
    let p = 23
    
    @Binding var pageOne: Bool
    @Binding var pageTwo: Bool
    @Binding var pageThree: Bool
    @Binding var pageFour: Bool
    @Binding var correctness: Bool
    
    @Binding var userInt: Int
    @Binding var userPublicKey: Int
    let computerInt: Int
    @Binding var computerPublicKey: Int
    
    @Binding var sharedSecretKey: Int
    
    var body: some View {
        
        VStack {
            if pageTwo || pageThree || pageFour || correctness {
                boxify(Text("Prime base\n") + Style.monospaceBig("g = \(g)"), color: .blue).transition(.enterFromBottom)
                Image("arrow_down").resizable().frame(width: 18, height: 18).invertOnDarkTheme().transition(.enterFromBottom)
                boxify(Text("Prime modulus\n") + Style.monospaceBig("p = \(p)"), color: .blue).transition(.enterFromBottom)
            }
            HStack{
                VStack {
                    if pageTwo || pageThree || pageFour || correctness {
                        Image("arrow_left").resizable().frame(width: 18, height: 18)
                            .invertOnDarkTheme()
                            .transition(.enterFromBottom)
                        boxify(Text("Your Secret\n") + Style.monospaceBig("a = \(userInt)"), color: .red)
                            .transition(.enterFromBottom)
                        if pageThree || pageFour || correctness {
                            Image("arrow_down").resizable().frame(width: 18, height: 18).invertOnDarkTheme().transition(.enterFromBottom)
                        }
                    }
                    if !pageFour {
                        if #available(iOS 16.0, *) {
                            if pageThree {
                                boxify(Text("Your Public Key\n") + Style.monospaceBig("A = \(userPublicKey)"), color: .blue)
                                    .draggable(1)
                                    .transition(.enterFromBottom)
                            }
                        } else {
                            boxify(Text("Your Public Key\n") + Style.monospaceBig("A = \(userPublicKey)"), color: .blue).transition(.enterFromBottom)
                            // MORE FALLBACK
                        }
                    } else {
                        boxify(Text("Your Public Key\n") + Style.monospaceBig("A = \(userPublicKey)"), color: .blue)
                    }
                }
                
                Spacer().frame(maxWidth: 25)
                
                VStack {
                    if pageTwo || pageThree || pageFour {
                        Image("arrow_right").resizable().frame(width: 18, height: 18)
                            .invertOnDarkTheme()
                            .transition(.enterFromBottom)
                        boxify(Text("Computer Secret\n") + Style.monospaceBig("b = ?"), color: .red)
                            .transition(.enterFromBottom)
                        if pageThree || pageFour {
                            Image("arrow_down")
                                .resizable()
                                .frame(width: 18, height: 18)
                                .invertOnDarkTheme()
                                .transition(.enterFromBottom)
                            boxify(Text("Computer Public Key\n") + Style.monospaceBig("B = \(computerPublicKey)"), color: .blue)
                                .transition(.enterFromBottom)
                        }
                    }
                }
            }
            if pageThree || pageFour {
                Image("arrow_cross").resizable().aspectRatio(contentMode: .fit).frame( height: 25).invertOnDarkTheme().transition(.enterFromBottom)
            }
            HStack {
                VStack {
                    if pageThree || pageFour || correctness {
                        boxify(Text("Computer Public Key\n") + Style.monospaceBig("B = \(computerPublicKey)"), color: .blue)
                            .transition(.enterFromBottom)
                    }
                    if correctness {
                        Image("arrow_right").resizable().frame(width: 18, height: 18).invertOnDarkTheme().transition(.enterFromBottom)
                    }
                }
                Spacer().frame(maxWidth: 25)
                VStack {
                    if #available(iOS 16.0, *) {
                        if pageThree {
                            boxify(Text("Drop your public key here!"), color: .white, textColor: .black)
                                .frame(minHeight: 78)
                                .border(.gray)
                                .dropDestination(for: Int.self) { (items, point) in
                                    print("dropped!")
                                    pageThree = false
                                    pageFour = true
                                    return true
                                }
                                .transition(.enterFromBottom)
                        }
                        if pageFour || correctness {
                            boxify(Text("Your Public Key\n") + Style.monospaceBig("A = \(userPublicKey)"), color: .blue)
                        }
                    } else {
                        // Fallback on earlier versions
                    }
                    if correctness {
                        Image("arrow_left").resizable().frame(width: 18, height: 18).invertOnDarkTheme().transition(.enterFromBottom)
                    }
                }
            }
            //boxify(Text("Shared Secret Key \n") + Style.monospaceBig("\(sharedSecretKey)"), color: .purple).showOnBindings($correctness)
            if correctness {
                if #available(iOS 16.0, *) {
                    boxify(Text("Shared Secret Key \n") + Style.monospaceBig("\(sharedSecretKey)"), color: .purple).transition(.enterFromBottom)
                } else {
                    boxify(Text("Shared Secret Key \n") + Style.monospaceBig("\(sharedSecretKey)"), color: .purple)
                }
            }
        }
        .animation(.default, value: pageOne)
        .animation(.default, value: pageTwo)
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
