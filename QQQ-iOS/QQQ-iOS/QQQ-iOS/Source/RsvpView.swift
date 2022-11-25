//
//  RsvpView.swift
//  QQQ-iOS
//
//  Created by Svyatoshenko "Megal" Misha on 2022-11-25.
//

import SwiftUI
import Prism

struct RsvpView: View {
	@State var prismConfiguration = PrismConfiguration(
		tilt: 0.5,
		size: CGSize(width: 240, height: 240),
		extrusion: 20.0,
		levitation: 0.0,
		shadowColor: .black,
		shadowOpacity: 0.15
	)
	@State private var opacity = 0.35

	private func makePrismView() -> some View {
		let color = Color.accentColor

		return PrismView(configuration: prismConfiguration) {
				Text("Я участвую")
				.frame(minWidth: 240.0)
				.font(.title)
				.frame(minHeight: 240.0)
				.background(.ultraThinMaterial)
				.background(color.opacity(opacity - 0.3))
		} left: {
			color.brightness(-0.1)
				.opacity(opacity - 0.1)
//					.background(.thinMaterial)
		} right: {
			color.brightness(-0.3)
				.opacity(opacity)
//					.background(.thinMaterial)
		}
		.onTapGesture(perform: reactRsvpButton)
	}

	private func reactRsvpButton() {
		prismConfiguration.extrusion = 20.0 - prismConfiguration.extrusion 
	}

	var body: some View {
		makePrismView()
	}
}

struct RsvpView_Previews: PreviewProvider {
	static var previews: some View {
		RsvpView()
	}
}
