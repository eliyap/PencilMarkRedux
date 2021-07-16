//
//  ContentView.swift
//  PencilMarkRedux
//
//  Created by Secret Asian Man Dev on 11/7/21.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var strokeC = StrokeConduit()
    @State var document = StyledMarkdown(text: """
ATX 1
=====

ATX 2
-----

# Heading ~~Nested~~
### Heading ***Nested***
Plain Text
**Strong** *emphasis* ~~delete~~
nesting *emphasis **strong ~~delete~~***

- list item
    - sub list item
1. numbered
    1. sub numbered
- [x] task done
- [ ] task todo

> block quote
>
> with blank space
> > nested quote

[a link](www.example.com)
![an image](www.example.com)

a claim[^1]

a break

---

`some code`

```swift
func moreCode() -> Void { /* some comments */ }
```
[^1]: a footnote reference
""")
    var body: some View {
        ZStack {
            KeyboardEditorView(strokeC: strokeC, document: $document)
                .border(Color.red)
            CanvasView(strokeC: strokeC)
                .border(Color.red)
        }
    }
}

