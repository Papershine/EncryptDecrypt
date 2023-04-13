import SwiftUI

struct Style {
    static func monospaceBig(_ t: String) -> Text {
        return Text(t).font(.custom("menlo", size: 23, relativeTo: .body))
    }
    
    static func superscript(_ t: String) -> Text {
        return Text(t).font(.custom("menlo", size: 18)).baselineOffset(7.0).foregroundColor(.blue)
    }
}
