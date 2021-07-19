//
//  PhrasingTests.swift
//  PencilMarkReduxTests
//
//  Created by Secret Asian Man Dev on 13/7/21.
//

import XCTest
@testable import PencilMarkRedux

class PhrasingTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    /// make sure zero length ranges are rejected
    func testZeroRange() throws {
        var document = StyledMarkdown()
        
        document = StyledMarkdown(text: "aaa")
        document.apply(lineStyle: Delete.self, to: NSMakeRange(1, 0))
        XCTAssertEqual(document.text, "aaa")
    }

    /// Formats through the middle of a line
    func testMid() throws {
        var document = StyledMarkdown()
        
        /// ~~DELETE~~
        document = StyledMarkdown(text: "aSTRIKEa")
        document.apply(lineStyle: Delete.self, to: NSMakeRange(1, 6))
        XCTAssertEqual(document.text, "a~~STRIKE~~a")
        
        /// **STRONG**
        document = StyledMarkdown(text: "aSTRIKEa")
        document.apply(lineStyle: Strong.self, to: NSMakeRange(1, 6))
        XCTAssertTrue(document.text == "a**STRIKE**a" || document.text == "a__STRIKE__a")
        
        /// *EMPHASIS*
        document = StyledMarkdown(text: "aSTRIKEa")
        document.apply(lineStyle: Emphasis.self, to: NSMakeRange(1, 6))
        XCTAssertTrue(document.text == "a*STRIKE*a" || document.text == "a_STRIKE_a")
    }
    
    /// Strikes an entire phrasing element and its surroundings
    func testEnclosing() throws {
        var document = StyledMarkdown()
        
        /// ~~DELETE~~
        document = StyledMarkdown(text: "aS _SSS_ Sa")
        document.apply(lineStyle: Delete.self, to: NSMakeRange(1, 9))
        XCTAssertEqual(document.text, "a~~S _SSS_ S~~a")
        
        /// **STRONG**
        document = StyledMarkdown(text: "aS _SSS_ Sa")
        document.apply(lineStyle: Strong.self, to: NSMakeRange(1, 9))
        XCTAssertTrue(document.text == "a**S _SSS_ S**a" || document.text == "a__S _SSS_ S__a")
        
        /// *EMPHASIS*
        document = StyledMarkdown(text: "aS **SSS** Sa")
        document.apply(lineStyle: Emphasis.self, to: NSMakeRange(1, 11))
        XCTAssertTrue(document.text == "a*S **SSS** S*a" || document.text == "a_S **SSS** S_a")
    }
    
    /// Strikes partly inside, partly outside a phrasing block
    func testPartial() throws {
        var document = StyledMarkdown()
        
        document = StyledMarkdown(text: "_aaBB_ BBaa")
        document.apply(lineStyle: Delete.self, to: NSMakeRange(3, 6))
        XCTAssertEqual(document.text, "_aa~~BB~~_ ~~BB~~aa") /// note ejection of leading whitespace
        
        #warning("TODO: add other phasing content")
    }
    
    /// test whether leading whitespace is ejected correctly
    func testEjectLeadingWhitespace() throws {
        var document = StyledMarkdown()
        
        document = StyledMarkdown(text: "AAA BBB")
        document.apply(lineStyle: Delete.self, to: NSMakeRange(3, 4)) /// target ' BBB'
        XCTAssertEqual(document.text, "AAA ~~BBB~~")
        
        document = StyledMarkdown(text: "AAA *BBB*")
        document.apply(lineStyle: Delete.self, to: NSMakeRange(3, 5)) /// target ' *BBB'
        XCTAssertEqual(document.text, "AAA *~~BBB~~*")
    }
    
    /// test whether trailing whitespace is ejected correctly
    func testEjectTrailingWhitespace() throws {
        var document = StyledMarkdown()
        
        document = StyledMarkdown(text: "AAA BBB")
        document.apply(lineStyle: Delete.self, to: NSMakeRange(0, 4)) /// target 'AAA '
        XCTAssertEqual(document.text, "~~AAA~~ BBB")
        
        document = StyledMarkdown(text: "*AAA* BBB")
        document.apply(lineStyle: Delete.self, to: NSMakeRange(1, 5)) /// target 'AAA* '
        XCTAssertEqual(document.text, "*~~AAA~~* BBB")
    }
    
    /// Strikes through a block enclosing a `delete` already.
    /// Expect it to unwrap that enclosed block.
    func testUnwrap() throws {
        var document = StyledMarkdown()
        
        document = StyledMarkdown(text: "aS _~~SSS~~_ Sa")
        document.apply(lineStyle: Delete.self, to: NSMakeRange(1, 13))
        XCTAssertEqual(document.text, "a~~S _SSS_ S~~a")
        
        #warning("TODO: add other phasing content")
    }
    
    func testExtensionLeading() throws {
        var document = StyledMarkdown()
        
        document = StyledMarkdown(text: "~~AAA BBB~~ CCC")
        document.apply(lineStyle: Delete.self, to: NSMakeRange(6, 9)) /// strike `BBB~~ CCC`
        XCTAssertEqual(document.text, "~~AAA BBB CCC~~")
    }
    
    func testExtensionTrailing() throws {
        var document = StyledMarkdown()
        
        document = StyledMarkdown(text: "AAA ~~BBB CCC~~")
        document.apply(lineStyle: Delete.self, to: NSMakeRange(0, 9)) /// strike `AAA ~~BBB`
        XCTAssertEqual(document.text, "~~AAA BBB CCC~~")
    }
}
