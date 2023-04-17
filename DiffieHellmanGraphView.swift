import SwiftUI

struct DiffieHellmanGraphView: View {
    
    @ObservedObject var viewModel: DiffieHellmanViewModel
    
    @State private var baseShake = 0
    
    var body: some View {
        ZStack {
            if viewModel.pageTwo || viewModel.baseMixable || viewModel.mixedDroppable || viewModel.sharedMixable || viewModel.sharedRevealed || viewModel.secretRevealed {
                VStack {
                    HStack {
                        Text("Your colors").font(.system(.headline)).frame(maxWidth: .infinity)
                        Spacer().frame(maxWidth: 25)
                        Text("Computer colors").font(.system(.headline)).frame(maxWidth: .infinity)
                    }
                    
                    if #available(iOS 16.0, *) {
                        Style.boxify(Text("Base Color"), color: viewModel.baseColor)
                            .draggable("base")
                            .shake(with: baseShake)
                            .onReceive(viewModel.$baseMixable) { bool in
                                if bool {
                                    withAnimation(.shakeSpring()) {
                                        baseShake = 3
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
                                    .dropDestination(for: String.self) { msg, pos in
                                        viewModel.baseMixable = false
                                        viewModel.mixedDroppable = true
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
                    
                    
                    if viewModel.mixedDroppable || viewModel.sharedMixable || viewModel.sharedRevealed || viewModel.secretRevealed {
                        HStack {
                            VStack {
                                Image("arrow_down")
                                    .resizable()
                                    .frame(width: 18, height: 18)
                                    .invertOnDarkTheme()
                                    .transition(.enterFromBottom)
                                
                                // user blended
                                if #available(iOS 16.0, *) {
                                    Style.boxify(Text("User Public Key"), color: viewModel.userBlended.wrappedValue).draggable("mixed").disabled(viewModel.mixedDroppable != true)
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
                                            .draggable("shared")
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
                                            .dropDestination(for: String.self) { _, _ in
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
                                            Style.boxify(Text("User Secret"), color: viewModel.userColor, border: .red).dropDestination(for: String.self) { msg, pos in
                                                viewModel.sharedMixable = false
                                                viewModel.sharedRevealed = true
                                                return true
                                            }.disabled(viewModel.sharedMixable != true)
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
            .animation(.default, value: viewModel.mixedDroppable)
            .animation(.default, value: viewModel.pageFour)
            .animation(.default, value: viewModel.sharedRevealed)
            .animation(.default, value: viewModel.secretRevealed)
    }
}
