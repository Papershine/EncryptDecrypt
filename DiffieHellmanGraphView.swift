import SwiftUI

struct DiffieHellmanGraphView: View {
    
    @ObservedObject var viewModel: DiffieHellmanViewModel
    
    @State private var baseShake = 0
    @State private var userPublicShake = 0
    @State private var computerPublicShake = 0
    
    @State private var basePulseStart: Bool = false
    @State private var publicKeyPulseStart: Bool = false
    @State private var secretKeyPulseStart: Bool = false
    
    var body: some View {
        
        ZStack {
            if viewModel.pageTwo || viewModel.pageThree || viewModel.baseMixable || viewModel.mixedDroppable || viewModel.sharedMixable || viewModel.sharedRevealed || viewModel.secretRevealed {
                VStack {
                    HStack {
                        Text("Your colors").font(.system(.headline)).frame(maxWidth: .infinity)
                        Spacer().frame(maxWidth: 25)
                        Text("Computer colors").font(.system(.headline)).frame(maxWidth: .infinity)
                    }
                    
                    
                    if #available(iOS 16.0, *) {
                        Style.boxify(Text("Base Color"), color: viewModel.baseColor)
                            .onDrag {
                                basePulseStart = true
                                return NSItemProvider(object: "base" as NSItemProviderWriting)
                            }
                            .shake(with: baseShake)
                            .onReceive(viewModel.$baseMixable) { bool in
                                if bool {
                                    withAnimation(.shakeSpring()) {
                                        baseShake = 3
                                    }
                                    Task {
                                        try? await Task.sleep(nanoseconds: 6 * 1_000_000_000) // 6 seconds
                                        if viewModel.baseMixable {
                                            // shake again 6 seconds later
                                            baseShake = 0
                                            withAnimation(.shakeSpringOnce()) {
                                                baseShake = 3
                                            }
                                        }
                                    }
                                }
                            }
                            .disabled(viewModel.baseMixable == false)
                    } else {
                        Style.boxify(Text("Base Color"), color: viewModel.baseColor)
                    }
                    
                    HStack {
                        VStack {
                            Image("plus")
                                .resizable()
                                .frame(width: 18, height: 18)
                                .invertOnDarkTheme()
                                .transition(.enterFromBottom)
                            
                            // user secret
                            if #available(iOS 16.0, *) {
                                Style.boxify(Text("User Secret"), color: viewModel.userColor, border: .red)
                                    .scaleEffect(basePulseStart ? 1.05 : 1)
                                    .animation(basePulseStart ? .easeInOut.repeatForever(autoreverses: true) : .default, value: basePulseStart)
                                    .dropDestination(for: String.self) { msg, pos in
                                        basePulseStart = false
                                        viewModel.baseMixable = false
                                        return true
                                    }
                                    .disabled(viewModel.baseMixable != true)
                            } else {
                                Style.boxify(Text("User Secret"), color: viewModel.userColor, border: .red)
                            }
                        }
                        Spacer().frame(maxWidth: 25)
                        VStack {
                            Image("plus")
                                .resizable()
                                .frame(width: 18, height: 18)
                                .invertOnDarkTheme()
                                .transition(.enterFromBottom)
                            
                            // computer secret
                            if !viewModel.secretRevealed {
                                Style.boxify(Text("Computer Secret: ??"), color: .gray, border: .red)
                            } else {
                                Style.boxify(Text("Computer Secret"), color: viewModel.computerColor, border: .red).transition(.opacity)
                            }
                        }
                    }
                    
                    
                    if (viewModel.pageThree && !viewModel.baseMixable) || viewModel.mixedDroppable || viewModel.sharedMixable || viewModel.sharedRevealed || viewModel.secretRevealed {
                        HStack {
                            VStack {
                                Image("arrow_down")
                                    .resizable()
                                    .frame(width: 18, height: 18)
                                    .invertOnDarkTheme()
                                    .transition(.enterFromBottom)
                                
                                // user blended
                                if #available(iOS 16.0, *) {
                                    Style.boxify(Text("User Public Key"), color: viewModel.userBlended.wrappedValue)
                                        .onDrag {
                                            publicKeyPulseStart = true
                                            return NSItemProvider(object: "mixed" as NSItemProviderWriting)
                                        }
                                        .shake(with: userPublicShake)
                                        .onReceive(viewModel.$mixedDroppable) { bool in
                                            if bool {
                                                withAnimation(.shakeSpring()) {
                                                    userPublicShake = 3
                                                }
                                                Task {
                                                    try? await Task.sleep(nanoseconds: 6 * 1_000_000_000) // 6 seconds
                                                    if viewModel.mixedDroppable {
                                                        // shake again 6 seconds later
                                                        userPublicShake = 0
                                                        withAnimation(.shakeSpringOnce()) {
                                                            userPublicShake = 3
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        .disabled(viewModel.mixedDroppable == false)
                                } else {
                                    Style.boxify(Text("User Public Key"), color: viewModel.userBlended.wrappedValue)
                                }
                                
                            }
                            Spacer().frame(maxWidth: 25)
                            VStack {
                                Image("arrow_down")
                                    .resizable()
                                    .frame(width: 18, height: 18)
                                    .invertOnDarkTheme()
                                    .transition(.enterFromBottom)
                                
                                // computer mixed
                                Style.boxify(Text("Computer Public Key"), color: viewModel.computerBlended.wrappedValue)
                            }
                        }.transition(.enterFromBottom)
                        
                        if viewModel.pageFour || viewModel.sharedMixable || viewModel.sharedRevealed || viewModel.secretRevealed {
                            Image("arrow_cross").resizable().aspectRatio(contentMode: .fit).frame( height: 25).invertOnDarkTheme().transition(.enterFromBottom)
                            
                            HStack {
                                VStack {
                                    // computer mixed
                                    if #available(iOS 16.0, *) {
                                        Style.boxify(Text("Computer Public Key"), color: viewModel.computerBlended.wrappedValue)
                                            .shake(with: computerPublicShake)
                                            .onReceive(viewModel.$sharedMixable) { bool in
                                                if bool {
                                                    withAnimation(.shakeSpring()) {
                                                        computerPublicShake = 3
                                                    }
                                                    Task {
                                                        try? await Task.sleep(nanoseconds: 6 * 1_000_000_000) // 6 seconds
                                                        if viewModel.sharedMixable {
                                                            // shake again 6 seconds later
                                                            computerPublicShake = 0
                                                            withAnimation(.shakeSpringOnce()) {
                                                                computerPublicShake = 3
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                            .onDrag {
                                                secretKeyPulseStart = true
                                                return NSItemProvider(object: "shared" as NSItemProviderWriting)
                                            }
                                            .disabled(viewModel.sharedMixable != true)
                                    } else {
                                        Style.boxify(Text("Computer Public Key"), color: viewModel.computerBlended.wrappedValue)
                                    }
                                }
                                Spacer().frame(maxWidth: 25)
                                VStack {
                                    // drop area for user mixed
                                    if viewModel.mixedDroppable, #available(iOS 16.0, *) {
                                        Style.boxify(Text("Drop your public key here!"), color: .white, textColor: .black, border: .gray)
                                            .scaleEffect(publicKeyPulseStart ? 1.05 : 1)
                                            .animation(publicKeyPulseStart ? .easeInOut.repeatForever(autoreverses: true) : .default, value: publicKeyPulseStart)
                                            .dropDestination(for: String.self) { _, _ in
                                                publicKeyPulseStart = false
                                                viewModel.pageFour = false
                                                viewModel.pageFive = true
                                                viewModel.mixedDroppable = false
                                                viewModel.sharedMixable = true
                                                return true
                                            }
                                            .disabled(viewModel.mixedDroppable != true)
                                    } else {
                                        Style.boxify(Text("User Public Key"), color: viewModel.userBlended.wrappedValue)
                                    }
                                }
                            }.transition(.enterFromBottom)
                            
                            if viewModel.sharedMixable || viewModel.sharedRevealed || viewModel.secretRevealed {
                                HStack {
                                    VStack {
                                        Image("plus")
                                            .resizable()
                                            .frame(width: 18, height: 18)
                                            .invertOnDarkTheme()
                                            .transition(.enterFromBottom)
                                        
                                        // user secret
                                        if #available(iOS 16.0, *) {
                                            Style.boxify(Text("User Secret"), color: viewModel.userColor, border: .red)
                                                .scaleEffect(secretKeyPulseStart ? 1.05 : 1)
                                                .animation(secretKeyPulseStart ? .easeInOut.repeatForever(autoreverses: true) : .default, value: secretKeyPulseStart)
                                                .dropDestination(for: String.self) { msg, pos in
                                                    secretKeyPulseStart = false
                                                    viewModel.sharedMixable = false
                                                    viewModel.sharedRevealed = true
                                                    return true
                                                }
                                                .disabled(viewModel.sharedMixable == false)
                                        } else {
                                            Style.boxify(Text("User Secret"), color: viewModel.userColor, border: .red)
                                        }
                                        
                                        // shared secret
                                        if viewModel.sharedRevealed {
                                            VStack {
                                                Image("arrow_down")
                                                    .resizable()
                                                    .frame(width: 18, height: 18)
                                                    .invertOnDarkTheme()
                                                Style.boxify(Text("Shared Secret Key"), color: viewModel.sharedBlended.wrappedValue, border: .red)
                                            }.transition(.enterFromBottom)
                                        }
                                    }
                                    Spacer().frame(maxWidth: 25)
                                    VStack {
                                        Image("plus")
                                            .resizable()
                                            .frame(width: 18, height: 18)
                                            .invertOnDarkTheme()
                                            .transition(.enterFromBottom)
                                        
                                        // computer secret
                                        if !viewModel.secretRevealed {
                                            Style.boxify(Text("Computer Secret: ??"), color: .gray, border: .red)
                                        } else {
                                            Style.boxify(Text("Computer Secret"), color: viewModel.computerColor, border: .red).transition(.opacity)
                                        }
                                        
                                        if viewModel.sharedRevealed {
                                            VStack{
                                                Image("arrow_down")
                                                    .resizable()
                                                    .frame(width: 18, height: 18)
                                                    .invertOnDarkTheme()
                                                
                                                // shared secret
                                                if viewModel.secretRevealed {
                                                    Style.boxify(Text("Shared Secret Key"), color: viewModel.sharedBlended.wrappedValue, border: .red).transition(.opacity)
                                                } else {
                                                    Style.boxify(Text("Shared Secret Key: ??"), color: .gray, border: .red)
                                                }
                                            }.transition(.enterFromBottom)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .transition(.enterFromBottom)
                .padding()
            }
        }.animation(.default, value: viewModel.pageTwo)
            .animation(.default, value: viewModel.baseMixable)
            .animation(.default, value: viewModel.mixedDroppable)
            .animation(.default, value: viewModel.pageFour)
            .animation(.default, value: viewModel.sharedRevealed)
            .animation(.default, value: viewModel.secretRevealed)
    }
}
