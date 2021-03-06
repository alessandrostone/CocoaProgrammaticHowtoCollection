//
//  ExampleApplicationController.swift
//  CustomNSTextViewWithNSTextStorage
//
//  Created by Hoon H. on 2014/12/26.
//  Copyright (c) 2014 Eonil. All rights reserved.
//

import Cocoa







/////////////////////////////////////////////////////////////////////////////
//
//	Minimal example to customise `NSTextView` with custom `NSTextStorage`.
//
/////////////////////////////////////////////////////////////////////////////




class CustomTextView: NSTextView {

	//	If you use non-default text-storage, 
	//	the storage must be retained by something else
	//	because `NSTextView` will not retain it.
	//	As a consequence, your app will be crashed.
	//
	//	Cited from manual:
	//
	//	>	There are two standard ways to create an object web of the
	//	>	four principal classes of the text system to handle text 
	//	>	editing, layout, and display: in one case, the text view
	//	>	creates and owns the other objects; in the other case, you
	//	>	create all the objects explicitly and the text storage owns 
	//	>	them.
	//
	var	s:CustomTextStorage?
	
//	init() {
//		super.init(frame: NSRect.zeroRect, textContainer: nil)
//	}
	
	override init(frame frameRect: NSRect, textContainer container: NSTextContainer?) {
		super.init(frame: frameRect, textContainer: container)
		s	=	CustomTextStorage()
		layoutManager!.replaceTextStorage(s!)
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		s	=	CustomTextStorage()
		layoutManager!.replaceTextStorage(s!)
	}
}




class CustomTextStorage: NSTextStorage {
	var	s	=	""
	
	override var string:String {
		get {
			return	s
		}
	}
	
	override func attributesAtIndex(location: Int, effectiveRange range: NSRangePointer) -> [NSObject : AnyObject] {
		
		//
		//	`range` is an output parameter! You must set it to a proper value.
		//
		if range != nil {
			range.memory	=	NSRange(location: 0, length: self.length)
		}
		
		return	[NSFontAttributeName: NSFont.systemFontOfSize(24)]
	}
	
	override func replaceCharactersInRange(range: NSRange, withString str: String) {
		s	=	(s as NSString).stringByReplacingCharactersInRange(range, withString: str)
		
		//
		//	Changes must be notified!
		//
		let	d	=	(str as NSString).length - range.length
		self.edited(Int(NSTextStorageEditedOptions.Characters.rawValue), range: range, changeInLength: d)	//	`d` must be delta. Keep the sign.
	}
	override func setAttributes(attrs: [NSObject : AnyObject]?, range: NSRange) {
		
		//
		//	Changes must be notified!
		//
		self.edited(Int(NSTextStorageEditedOptions.Attributes.rawValue), range: range, changeInLength: 0)
	}
}















class ExampleApplicationController: NSObject, NSApplicationDelegate {
	let	window1	=	NSWindow()
	
	func applicationDidFinishLaunching(aNotification: NSNotification) {
		window1.styleMask		|=	NSResizableWindowMask | NSClosableWindowMask | NSResizableWindowMask | NSMiniaturizableWindowMask
		window1.setFrame(CGRect(x: 400, y: 400, width: 400, height: 500), display: true)
		window1.makeKeyAndOrderFront(self)
		
		////
		
		let	s	=	NSScrollView()
		let	t	=	CustomTextView()
		
		t.string				=	"ABC"
		t.verticallyResizable	=	true
		t.horizontallyResizable	=	true
		
		s.documentView			=	t
		s.hasVerticalScroller	=	true
		s.hasHorizontalScroller	=	true
		window1.contentView		=	s
	}
}











