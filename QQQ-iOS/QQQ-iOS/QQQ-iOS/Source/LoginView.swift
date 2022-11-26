//
//  LoginView.swift
//  QQQ-iOS
//
//  Created by Svyatoshenko "Megal" Misha on 2022-11-26.
//

import SwiftUI
import Prism

struct LoginView: View {
	enum Navigation: Hashable {
		case student
		case professor
	}

	@State var prismConfiguration = PrismConfiguration(
		tilt: 0.5,
		size: CGSize(width: 240, height: 80),
		extrusion: 20.0,
		levitation: 0.0,
		shadowColor: .black,
		shadowOpacity: 0.15
	)
	@State private var opacity = 0.35

	var body: some View {
		if #available(iOS 16.0, *) {
			makeModernNavigation()
		} else {
			VStack {
				NavigationLink("Cтудент") { RsvpView() }
				NavigationLink("Преподаватель") { RsvpView() }
			}
		}
	}

	@available(iOS 16.0, *)
	private func makeModernNavigation() -> some View {
		VStack {
			Spacer()
			Text("Войти как\n").font(.largeTitle)
			NavigationLink(destination: RsvpView()) {
				makePrismButton(text: "Cтудент")
			}
			Text("\n")
			NavigationLink(value: Navigation.professor) {
				makePrismButton(text: "Преподаватель")
			}
			Spacer()
		}
		.navigationTitle("Вход")
		.navigationDestination(for: Navigation.self) { destination in
			switch destination {
			case .student:
				RsvpView()
			case .professor:
				RsvpView()
			}
		}
	}

	@available(iOS 16.0, *)
	private func makePrismButton(text: String, action: (() -> Void)? = nil) -> some View {
		let color = Color.accentColor

		return NavigationLink(value: Navigation.professor) {
			PrismView(configuration: prismConfiguration) {
				Text(text)
					.frame(minWidth: 240.0)
					.font(.title2)
					.frame(minHeight: 80.0)
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
//			.onTapGesture(perform: action ?? {})
		}
	}
}

struct LoginView_Previews: PreviewProvider {
	static var previews: some View {
		if #available(iOS 16.0, *) {
			NavigationStack {
				LoginView()
			}
		} else {
			LoginView()
		}
	}
}
