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
# 21.06.21
### OMM
Lab Meeting
- [x] Amazon ~~Package~~ o/
MR4 Reading
WRIT revised proposal
Coding

- [ ] Clear email
    - [ ] Rec Sports Form
    - [ ] Aetna SSN
---
### Log
* Coding
* Revised Proposal
* Class
    * lunch done

### Plan
- Shower
- Into Lab
---
Dinner
- [x] (Bonus: Monterey Boot Disk)
Bed
- [x] Shower
- [x] Coding, Upload TestFlight
- [x] Amazon package pickup
- [x] started Monterey Boot Drive Process
- [x] Gym
- [x] Shower, To Lab
– – –
- [x] WRIT  brainstorming
MR4
Lab Work

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

