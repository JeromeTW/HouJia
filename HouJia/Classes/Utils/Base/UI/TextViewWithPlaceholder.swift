//
//  TextViewWithPlaceholder.swift
//  HouJia
//
//  Created by JEROME on 2019/12/6.
//

import UIKit

@IBDesignable public class TextViewWithPlaceholder: UITextView {
  
  override public var text: String! { // Ensures that the placeholder text is never returned as the field's text
    get {
      if showingPlaceholder {
        return "" // When showing the placeholder, there's no real text to return
      } else { return super.text }
    }
    set { super.text = newValue }
  }
  @IBInspectable public var placeholderText: String = ""
  @IBInspectable public var placeholderTextColor: UIColor = UIColor(red: 0.78, green: 0.78, blue: 0.80, alpha: 1.0) // Standard iOS placeholder color (#C7C7CD). See https://stackoverflow.com/questions/31057746/whats-the-default-color-for-placeholder-text-in-uitextfield
  @IBInspectable public var normalTextColor: UIColor = .orange
  public var showingPlaceholder: Bool = true // Keeps track of whether the field is currently showing a placeholder
  
  override public func didMoveToWindow() {
    super.didMoveToWindow()
    if text.isEmpty {
      showPlaceholderText() // Load up the placeholder text when first appearing, but not if coming back to a view where text was already entered
    }
  }
  
  override public func becomeFirstResponder() -> Bool {
    // If the current text is the placeholder, remove it
    if showingPlaceholder {
      text = nil
      textColor = normalTextColor // Put the text back to the default, unmodified color
      showingPlaceholder = false
    }
    return super.becomeFirstResponder()
  }
  
  override public func resignFirstResponder() -> Bool {
    // If there's no text, put the placeholder back
    if text.isEmpty {
      showPlaceholderText()
    }
    return super.resignFirstResponder()
  }
  
  public func showPlaceholderText() {
    showingPlaceholder = true
    textColor = placeholderTextColor
    text = placeholderText
  }
  
  public func showNormalText(text: String) {
    showingPlaceholder = false
    textColor = normalTextColor
    self.text = text
  }
}
