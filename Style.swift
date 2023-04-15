import SwiftUI

struct Style {
    
    static func monospace(_ t: String, color: Color = .blue) -> Text {
        return Text(t).font(.custom("menlo", size: 18, relativeTo: .body)).foregroundColor(color)
    }
    
    static func superscript(_ t: String, color: Color = .blue) -> Text {
        return Text(t).font(.custom("menlo", size: 10)).baselineOffset(5.0).foregroundColor(color)
    }
    
    static func monospaceBig(_ t: String) -> Text {
        return Text(t).font(.custom("menlo", size: 21, relativeTo: .body))
    }
    
    static func superscriptBig(_ t: String) -> Text {
        return Text(t).font(.custom("menlo", size: 18)).baselineOffset(7.0).foregroundColor(.blue)
    }
    
    static func monospaceVeryBig(_ t: String, color: Color = .blue) -> Text {
        return Text(t).font(.custom("menlo", size: 30, relativeTo: .body)).foregroundColor(color)
    }
}

extension AnyTransition {
    static var moveAndFade: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .scale.combined(with: .opacity)
        )
    }
}

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
