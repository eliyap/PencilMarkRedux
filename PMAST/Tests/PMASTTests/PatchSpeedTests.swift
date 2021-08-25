//
//  File.swift
//  
//
//  Created by Secret Asian Man Dev on 25/8/21.
//

import XCTest
@testable import PMAST

class PatchSpeedTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testBaconPatchSpeed() throws {
        let old = """
            Bacon ipsum dolor amet chicken sirloin chuck leberkas. Chislic sirloin shank sausage. Doner burgdoggen ball tip ham hock, short ribs shankle t-bone swine pork belly buffalo ribeye spare ribs hamburger kielbasa. Drumstick ribeye jerky capicola shoulder pork loin kevin, flank pig picanha alcatra.

            Bresaola pork chop sausage shoulder drumstick cupim turkey prosciutto pancetta. Cow bacon venison filet mignon shoulder short loin landjaeger leberkas rump pork chop corned beef. Tri-tip jowl bresaola corned beef. Short loin t-bone spare ribs bacon, biltong landjaeger tenderloin.

            Short loin tri-tip leberkas kevin meatball spare ribs. Turkey pork picanha, andouille sirloin meatloaf salami turducken shoulder leberkas fatback short loin pig strip steak. Pancetta landjaeger alcatra brisket. Ham salami tongue cupim pancetta tri-tip, sausage porchetta boudin rump ham hock ground round. Turkey frankfurter tenderloin chicken. Burgdoggen beef ribs strip steak fatback ham hock picanha biltong ball tip spare ribs short loin shankle cupim landjaeger meatloaf.

            Picanha turducken meatloaf sausage. T-bone salami cupim pork belly, sausage kevin picanha flank jerky. Turducken ham shankle, chicken sausage picanha short loin kevin leberkas jerky alcatra bresaola filet mignon. Spare ribs kevin shank brisket pork chop capicola chislic bresaola tongue meatball flank.

            Pork loin sausage pig, ribeye alcatra shankle chuck biltong corned beef ground round fatback venison. Pastrami sirloin capicola alcatra, tongue kielbasa prosciutto strip steak. Boudin prosciutto short ribs chicken rump meatloaf, shoulder pastrami biltong porchetta sirloin alcatra kielbasa. Doner jerky sirloin buffalo meatloaf tenderloin ribeye. Tri-tip pig hamburger, alcatra shank short ribs shoulder cupim tenderloin corned beef short loin tongue pastrami. Cupim sirloin capicola hamburger. Frankfurter tri-tip bacon pork loin turducken pork chop chicken kielbasa pig strip steak leberkas alcatra porchetta.
            """
        let new = """
            Bacon ipsum dolor amet chicken sirloin chuck leberkas. Chislic sirloin shank sausage. Doner burgdoggen ball tip ham hock, short ribs shankle t-bone swine pork belly buffalo ribeye spare ribs hamburger kielbasa. Drumstick ribeye jerky capicola shoulder pork loin kevin, flank pig picanha alcatra.

            Bresaola pork chop sausage shoulder drumstick cupim turkey prosciutto pancetta. Cow bacon venison filet mignon shoulder short loin landjaeger leberkas rump pork chop corned beef. Tri-tip jowl bresaola corned beef. Short loin t-bone spare ribs bacon, biltong landjaeger tenderloin.

            Short loin tri-tip leberkas kevin meatball spare ribs. Turkey pork picanha, andouille sirloin meatloaf salami turducken shoulder leberkas fatback short loin pig strip steak. Pancetta landjaeger alcatra brisket. Ham salami tongue cupim pancetta tri-tip, sausage porchetta boudin rump ham hock ground round. Turkey frankfurter tenderloin chicken. Burgdoggen beef ribs strip steak fatback ham hock picanha biltong ball tip spare ribs short loin shankle cupim landjaeger meatloaf.

            Picanha turducken meatloaf sausage. T-bone salami cupim pork belly, sausage kevin picanha flank jerky. Turducken ham shankle, chicken sausage picanha short loin kevin leberkas jerky alcatra bresaola filet mignon. Spare ribs kevin shank brisket pork chop capicola chislic bresaola tongue meatball flank.

            Pork loin sausage pig, ribeye alcatra shankle chuck biltong corned beef ground round fatback venison. Pastrami sirloin capicola alcatra, tongue kielbasa prosciutto strip steak. Boudin prosciutto short ribs chicken rump meatloaf, shoulder pastrami biltong porchetta sirloin alcatra kielbasa. Doner jerky sirloin buffalo meatloaf tenderloin ribeye. Tri-tip pig hamburger, alcatra shank short ribs shoulder cupim tenderloin corned beef short loin tongue pastrami. Cupim sirloin capicola hamburger. Frankfurter tri-tip bacon pork loin turducken pork chop chicken kielbasa pig strip steak leberkas alcatra porchetta.
            
            ...Eat your vegetables!
            """
        
        var oldMD = Markdown(old)
        
        measure {
            oldMD.patch(with: new)
        }
    }
    
    func testBaconParseSpeed() throws {
        measure {
            let new = """
            Bacon ipsum dolor amet chicken sirloin chuck leberkas. Chislic sirloin shank sausage. Doner burgdoggen ball tip ham hock, short ribs shankle t-bone swine pork belly buffalo ribeye spare ribs hamburger kielbasa. Drumstick ribeye jerky capicola shoulder pork loin kevin, flank pig picanha alcatra.

            Bresaola pork chop sausage shoulder drumstick cupim turkey prosciutto pancetta. Cow bacon venison filet mignon shoulder short loin landjaeger leberkas rump pork chop corned beef. Tri-tip jowl bresaola corned beef. Short loin t-bone spare ribs bacon, biltong landjaeger tenderloin.

            Short loin tri-tip leberkas kevin meatball spare ribs. Turkey pork picanha, andouille sirloin meatloaf salami turducken shoulder leberkas fatback short loin pig strip steak. Pancetta landjaeger alcatra brisket. Ham salami tongue cupim pancetta tri-tip, sausage porchetta boudin rump ham hock ground round. Turkey frankfurter tenderloin chicken. Burgdoggen beef ribs strip steak fatback ham hock picanha biltong ball tip spare ribs short loin shankle cupim landjaeger meatloaf.

            Picanha turducken meatloaf sausage. T-bone salami cupim pork belly, sausage kevin picanha flank jerky. Turducken ham shankle, chicken sausage picanha short loin kevin leberkas jerky alcatra bresaola filet mignon. Spare ribs kevin shank brisket pork chop capicola chislic bresaola tongue meatball flank.

            Pork loin sausage pig, ribeye alcatra shankle chuck biltong corned beef ground round fatback venison. Pastrami sirloin capicola alcatra, tongue kielbasa prosciutto strip steak. Boudin prosciutto short ribs chicken rump meatloaf, shoulder pastrami biltong porchetta sirloin alcatra kielbasa. Doner jerky sirloin buffalo meatloaf tenderloin ribeye. Tri-tip pig hamburger, alcatra shank short ribs shoulder cupim tenderloin corned beef short loin tongue pastrami. Cupim sirloin capicola hamburger. Frankfurter tri-tip bacon pork loin turducken pork chop chicken kielbasa pig strip steak leberkas alcatra porchetta.
            
            ...Eat your vegetables!
            """
            _ = Markdown(new)
        }
    }
}
