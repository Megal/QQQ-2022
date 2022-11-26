//
//  PrismViewBuilder.swift
//  QQQ-iOS
//
//  Created by Svyatoshenko "Megal" Misha on 2022-11-26.
//

import SwiftUI
import Prism

struct PrismViewBuilder {
	var configuration = PrismConfiguration(
		tilt: 0.5,
		size: CGSize(width: 240, height: 80),
		extrusion: 20.0,
		levitation: 0.0,
		shadowColor: .black,
		shadowOpacity: 0.15
	)
	var opacity = 0.35

	func makePrismView<Content: View>(@ViewBuilder content: () -> Content) -> some View {
		let color = Color.accentColor

		return PrismView(configuration: configuration) {
			content()
				.frame(minWidth: 240.0)
				.font(.title)
				.frame(minHeight: 80.0)
				.background(.ultraThinMaterial)
				.background(color.opacity(opacity - 0.3))
		} left: {
			color.brightness(-0.1)
				.opacity(opacity - 0.1)
		} right: {
			color.brightness(-0.3)
				.opacity(opacity)
		}
	}

}
