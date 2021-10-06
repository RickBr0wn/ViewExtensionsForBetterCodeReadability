//
//  ContentView.swift
//  ViewExtensionsForBetterCodeReadability
//
//  Created by Rick Brown on 06/10/2021.
//

import SwiftUI

// https://swiftui-lab.com/view-extensions-for-better-code-readability/

// Deprecated modifier:
// Text("Hello World").border(Color.black, width: 3, cornerRadius: 5)

// Solution #1
struct MyRoundedBorder<T>: ViewModifier where T : ShapeStyle {
  let shapeStyle: T
  var width: CGFloat = 1
  let cornerRadius: CGFloat
  
  init(_ shapeStyle: T, width: CGFloat, cornerRadius: CGFloat) {
    self.shapeStyle = shapeStyle
    self.width = width
    self.cornerRadius = cornerRadius
  }
  
  func body(content: Content) -> some View {
    return content.overlay(RoundedRectangle(cornerRadius: cornerRadius).strokeBorder(shapeStyle, lineWidth: width))
  }
}
// Solution #2
extension View {
  public func addBorder<T>(_ content: T, width: CGFloat = 1, cornerRadius: CGFloat) -> some View where T : ShapeStyle {
    return overlay(RoundedRectangle(cornerRadius: cornerRadius).strokeBorder(content, lineWidth: width))
  }
}
// Solution #3
extension View {
  // If condition is met, apply modifier, otherwise, leave the view untouched
  public func conditionalModifier<T>(_ condition: Bool, _ modifier: T) -> some View where T: ViewModifier {
    Group {
      if condition {
        self.modifier(modifier)
      } else {
        self
      }
    }
  }
  
  // Apply trueModifier if condition is met, or falseModifier if not.
  public func conditionalModifier<M1, M2>(_ condition: Bool, _ trueModifier: M1, _ falseModifier: M2) -> some View where M1: ViewModifier, M2: ViewModifier {
    Group {
      if condition {
        self.modifier(trueModifier)
      } else {
        self.modifier(falseModifier)
      }
    }
  }
}

struct ContentView: View {
  var body: some View {
    VStack {
      // Solution #1 - works but niave
      Text("Hello World")
        .padding()
        .modifier(MyRoundedBorder(Color.black, width: 3, cornerRadius: 5))
      // Solution #2 - works but won't work in a condtional statement, the following won't work:
      // Text("Hello world").modifier(flag ? ModifierOne() : EmptyModifier())
      // Text("Hello world").modifier(flag ? ModifierOne() : ModifierTwo())
      Text("Hello World")
        .padding()
        .addBorder(Color.blue, width: 3, cornerRadius: 5)
      
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
