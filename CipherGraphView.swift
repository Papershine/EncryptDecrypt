import SwiftUI

struct CipherGraphView: View {
    
    @Binding var message: String
    @Binding var key: Int
    
    let lowercaseLetter = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
    let uppercaseLetter = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    
    var body: some View {
        VStack {
            Spacer()
            if #available(iOS 16.0, *) {
                Text(" \(message) ")
                    .font(.system(size: 50))
                    .dropDestination(for: String.self) { text, _ in
                        if text.first == "enc" {
                            message = encrypt(message, key: key)
                        } else if text.first == "dec" {
                            message = decrypt(message, key: key)
                        } else {
                            print("ERROR: unkown drop origin")
                        }
                        return true
                    }
            } else {
                // Fallback on earlier versions
            }
            Spacer()
            HStack {
                Spacer()
                if #available(iOS 16.0, *) {
                    VStack(spacing: 5) {
                        ZStack {
                            Image("key")
                            Style.monospaceBig("\(key)").offset(x: -30)
                        }
                        Text("Encryption Key")
                    }.draggable("enc")
                } else {
                    // Fallback on earlier versions
                }
                Spacer()
                if #available(iOS 16.0, *) {
                    VStack(spacing: 5) {
                        ZStack {
                            Image("key")
                            Style.monospaceBig("\(key)").offset(x: -30)
                        }
                        Text("Decryption Key")
                    }.draggable("dec")
                } else {
                    // Fallback on earlier versions
                }
                Spacer()
            }
            Spacer()
        }
    }
    
    func encrypt(_ t: String, key: Int) -> String {
        var encrypted = ""
        for letter in t {
            if String(letter) == " " {
                encrypted.append(" ")
                continue
            }
            if letter.isLowercase { // lowercase
                if let oldIndex = lowercaseLetter.firstIndex(of: String(letter)) {
                    let newIndex = (oldIndex + key) % 26
                    encrypted.append(lowercaseLetter[newIndex])
                } else {
                    print("SOME ERROR WITH OPTIONALS")
                }
            } else { // uppercase
                if let oldIndex = uppercaseLetter.firstIndex(of: String(letter)) {
                    let newIndex = (oldIndex + key) % 26
                    encrypted.append(uppercaseLetter[newIndex])
                }
            }
        }
        
        return encrypted
    }
    
    func decrypt(_ t: String, key: Int) -> String {
        var decrypted = ""
        for letter in t {
            if String(letter) == " " {
                decrypted.append(" ")
                continue
            }
            if letter.isLowercase { // lowercase
                if let oldIndex = lowercaseLetter.firstIndex(of: String(letter)) {
                    let newIndex = (oldIndex - key) %% 26
                    decrypted.append(lowercaseLetter[newIndex])
                } else {
                    print("SOME ERROR WITH OPTIONALS")
                }
            } else { // uppercase
                if let oldIndex = uppercaseLetter.firstIndex(of: String(letter)) {
                    let newIndex = (oldIndex - key) %% 26
                    print(newIndex)
                    decrypted.append(uppercaseLetter[newIndex])
                }
            }
        }
        
        return decrypted
    }
}
