//
//  DiffieHellmanGraphView.swift
//  EncryptDecrypt
//
//  Created by Hilary Lau on 2023-04-13.
//

import SwiftUI

struct DiffieHellmanGraphView: View {
    let g = 5
    let p = 23
    
    @Binding var pageOne: Bool
    @Binding var pageTwo: Bool
    @Binding var pageThree: Bool
    
    @Binding var userInt: Int
    @Binding var userPublicKey: Int
    @Binding var computerPublicKey: Int
    
    @Binding var sharedSecretKey: Int
    
    var body: some View {
        VStack(spacing: 20) {
            boxify(Text("Prime base\n") + Style.monospaceBig("g = \(g)"), color: .blue)
            boxify(Text("Prime modulus\n") + Style.monospaceBig("p = \(p)"), color: .blue)
            HStack{
                VStack(spacing: 20) {
                    boxify(Text("Your Secret\n") + Style.monospaceBig("\(userInt)"), color: .red)
                    if #available(iOS 16.0, *) {
                        VStack {
                            boxify(Text("Your Public Key\n") + Style.monospaceBig("\(userPublicKey)"), color: .blue).draggable(1)
                        }.draggable(1)
                    } else {
                        // Fallback on earlier versions
                    }
                    boxify(Text("Computer Public Key\n") + Style.monospaceBig("\(computerPublicKey)"), color: .blue)
                }
                Spacer().frame(maxWidth: 25)
                VStack(spacing: 25) {
                    boxify(Text("Computer Secret\n") + Style.monospaceBig("?"), color: .red)
                    boxify(Text("Computer Public Key\n") + Style.monospaceBig("\(computerPublicKey)"), color: .blue)
                    if #available(iOS 16.0, *) {
                        boxify(Text("Your Public Key\n") + Style.monospaceBig("\(userPublicKey)"), color: .blue)
                            .dropDestination(for: Int.self) { (items, point) in
                                print("dropped!")
                                return true
                            }
                    } else {
                        // Fallback on earlier versions
                    }
                }
            }
            boxify(Text("Shared Secret Key \n") + Style.monospaceBig("\(sharedSecretKey)"), color: .red)
        }
        .padding()
        .multilineTextAlignment(.center)
    }
    
    func boxify(_ t: Text, color: Color) -> some View {
        return t.padding().frame(maxWidth: .infinity).foregroundColor(.white).background(color)
    }
}

@available(iOS 16.0, *)
extension Int: Transferable {
    public static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(for: Int.self, contentType: .data)
    }
}
