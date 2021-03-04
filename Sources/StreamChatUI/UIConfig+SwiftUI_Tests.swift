//
//  UIConfig+SwiftUI_Tests.swift
//  StreamChatUITests
//
//  Created by Vojta on 04/03/2021.
//  Copyright © 2021 Stream.io Inc. All rights reserved.
//

import Foundation
@testable import StreamChatUI
import XCTest
import SwiftUI

@available(iOS 13, *)
class UIConfig_SwiftUI_Tests: iOS13TestCase {

    func test_correctInstanceIsUsed() {
        class TestView: UIView {}

        var referenceConfig = UIConfig()
        referenceConfig.channelList.channelListItemSubviews.onlineIndicator = TestView.self

        var usedConfig: UIConfig.ObservableObject?

        struct UIConfigSpyView: View {
            @EnvironmentObject var uiConfig: UIConfig.ObservableObject
            let uiConfigCallback: (UIConfig.ObservableObject) -> Void
            var body: some View {
                uiConfigCallback(uiConfig)
                return Text("I am your father!")
            }
        }

        // Simulate the view is used
        let view = UIConfigSpyView { usedConfig = $0 }
            .setUpStreamChatUIConfig(referenceConfig)
        view.simulateViewAddedToHierarchy()

        // Assert the correct UIConfig is used
        AssertAsync.willBeTrue(usedConfig?.channelList.channelListItemSubviews.onlineIndicator is TestView.Type)
    }
}

@available(iOS 13.0, *)
extension View {
    /// Simulates the View was added to the view hierarchy and shown on the screen
    func simulateViewAddedToHierarchy() {
        let hostingVC = UIHostingController(rootView: self)
        let window = UIWindow()
        window.rootViewController = hostingVC
        window.layoutIfNeeded()
        window.isHidden = false
    }
}
