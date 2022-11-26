//
//  LoginView.swift
//  QQQ-iOS
//
//  Created by Svyatoshenko "Megal" Misha on 2022-11-26.
//

import SwiftUI

struct LoginView: View {
	enum Navigation: Hashable {
		case student
		case professor
	}

	@State private var prismViewBuilder = PrismViewBuilder()

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
			prismViewBuilder.makePrismView {
				Text(text)
			}
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
