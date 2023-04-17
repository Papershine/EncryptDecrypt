import SwiftUI

struct Style {
    
    // font shortcuts
    static func monospace(_ t: String, color: Color = .blue) -> Text {
        return Text(t).font(.custom("menlo", size: 18, relativeTo: .body)).foregroundColor(color)
    }
    
    static func superscript(_ t: String, color: Color = .blue) -> Text {
        return Text(t).font(.custom("menlo", size: 11)).baselineOffset(5.5).foregroundColor(color)
    }
    
    static func monospaceBig(_ t: String) -> Text {
        return Text(t).font(.custom("menlo", size: 20, relativeTo: .body))
    }
    
    static func superscriptBig(_ t: String) -> Text {
        return Text(t).font(.custom("menlo", size: 18)).baselineOffset(7.0).foregroundColor(.blue)
    }
    
    static func monospaceVeryBig(_ t: String, color: Color = .blue) -> Text {
        return Text(t).font(.custom("menlo", size: 30, relativeTo: .body)).foregroundColor(color)
    }
    
    // create a colored box
    static func boxify(_ t: Text = Text(" "), color: Color, textColor: Color = .white, border: Color = .clear) -> some View {
        return t
            .padding()
            .frame(maxWidth: .infinity, minHeight: 78)
            .foregroundColor(textColor)
            .background(color)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(border, lineWidth: 4))
            //.border(border, width: 2)
    }
}

// blue rounded button, gray when disabled
struct BlueButton: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding([.horizontal], 25)
            .padding([.vertical], 10)
            .foregroundColor(.white)
            .background(isEnabled ? .blue : .gray)
            .clipShape(Capsule())
            .frame(maxWidth: .infinity, alignment: .center)
    }
}

// indigo rounded button, gray when disabled
struct IndigoButton: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding([.horizontal], 25)
            .padding([.vertical], 10)
            .foregroundColor(.white)
            .background(isEnabled ? .indigo : .gray)
            .clipShape(Capsule())
            .frame(maxWidth: .infinity, alignment: .center)
    }
}

// custom transitions
extension AnyTransition {
    static var enterFromBottom: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .bottom).combined(with: .opacity),
            removal: .offset(x: 0, y: 0)
        )
    }
    
    static var pushFromBottom: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .bottom).combined(with: .opacity),
            removal: .move(edge: .top).combined(with: .opacity))
    }
    
    static var pushFromRight: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .trailing),
            removal: .move(edge: .leading))
    }
    
    static var pushForEnding: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .trailing),
            removal: .move(edge: .trailing))
    }
    
    static var pushForStart: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .leading),
            removal: .move(edge: .leading))
    }
}

// invert on dark mode
struct ColorAdaptive: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        if colorScheme == .dark {
            content.colorInvert()
        } else {
            content
        }
    }
}

extension View {
    @ViewBuilder func showOnBindings(_ bools: Binding<Bool>...) -> some View {
        if bools.contains(where: { $0.wrappedValue == true }) {
            self
        } else {
            self.hidden()
        }
    }
    
    @ViewBuilder func invertOnDarkTheme() -> some View {
        modifier(ColorAdaptive())
    }
}


// blend two colors together
extension Color {
    func blend(color: Color) -> Color {
        var r1: CGFloat = 0.0
        var r2: CGFloat = 0.0
        var g1: CGFloat = 0.0
        var g2: CGFloat = 0.0
        var b1: CGFloat = 0.0
        var b2: CGFloat = 0.0
        
        UIColor(self).getRed(&r1, green: &g1, blue: &b1, alpha: nil)
        UIColor(color).getRed(&r2, green: &g2, blue: &b2, alpha: nil)
        
        return Color(red: min(0.5 * r1 + 0.5 * r2, 1), green: min(0.5 * g1 + 0.5 * g2, 1), blue: min(0.5 * b1 + 0.5 * b2, 1))
    }
}


// vibrating animation
struct Shake: AnimatableModifier {
    var shakes: CGFloat = 0
    
    var animatableData: CGFloat {
        get {
            shakes
        } set {
            shakes = newValue
        }
    }
    
    func body(content: Content) -> some View {
        content.offset(x: sin(shakes * .pi * 2) * 5)
    }
}

extension View {
    func shake(with shakes: Int) -> some View {
        modifier(Shake(shakes: CGFloat(shakes)))
    }
}

extension Animation {
    static func shakeSpring() -> Animation {
        return .spring(response: 0.2, dampingFraction: 0.2, blendDuration: 0.2).repeatCount(2).delay(2)
    }
    
    static func shakeSpringFast() -> Animation {
        return .spring(response: 0.2, dampingFraction: 0.2, blendDuration: 0.2).repeatCount(2).delay(1)
    }
}


 // Modulus operator that produces positive results
infix operator %%

extension Int {
    static func %% (_ left: Int, _ right: Int) -> Int {
        precondition(right > 0, "The modulus must be positive")
        if left >= 0 { return left % right }
        if left >= -right { return (left + right) }
        return ((left % right) + right) % right
    }
}
 
/*
 // exponentiation operator
 precedencegroup ExponentiationPrecedence {
 associativity: right
 higherThan: MultiplicationPrecedence
 }
 
 infix operator ^^ : ExponentiationPrecedence
 infix operator ^^^: ExponentiationPrecedence
 
 // regular exponentiation
 func ^^ (_ base: Int, _ exp: Int) -> Int {
 return Int(pow(Double(base), Double(exp)))
 }
 
 // very large exponentiation
 func ^^^ (_ base: Int, _ exp: Int) -> UInt64 {
 return UInt64(pow(Double(base), Double(exp)))
 }
 */
