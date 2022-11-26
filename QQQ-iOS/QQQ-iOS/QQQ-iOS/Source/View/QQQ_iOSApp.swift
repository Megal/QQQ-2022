//
//  QQQ_iOSApp.swift
//  QQQ-iOS
//
//  Created by Svyatoshenko "Megal" Misha on 2022-11-25.
//

import SwiftUI

@main
struct QQQ_iOSApp: App {
	var body: some Scene {
		WindowGroup {
			if #available(iOS 16.0, *) {
				NavigationStack {
					LoginView()
				}
			} else {
				NavigationView {
					LoginView()
				}
				.navigationViewStyle(StackNavigationViewStyle())
			}
		}
	}
}
