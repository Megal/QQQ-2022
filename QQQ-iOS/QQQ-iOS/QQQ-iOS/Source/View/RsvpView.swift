//
//  RsvpView.swift
//  QQQ-iOS
//
//  Created by Svyatoshenko "Megal" Misha on 2022-11-25.
//

import SwiftUI
import Prism

struct RsvpViewModel {
	enum State: String {
		case firstLoad
		case failedToLoad
		case loaded
		case waitingForResponse

		var descriptuion: String {
			"\(self)"
		}
	}

	var state = State.firstLoad
	var lessonName = "Computer Science 101"
	var start = ISO8601DateFormatter().date(from: "2022-11-27T15:00:00+03:00")
	var end = ISO8601DateFormatter().date(from: "2022-11-27T16:30:00+03:00")
	var professorName = "Читающий Нам Лекторович"
	var onlineUrl: URL? = URL(string: "https://google.com")
	var response = ""

	mutating func load() async {
		self.state = .waitingForResponse
		self.response = ""

		do {
			let current = try await API.Request.current()

			self.lessonName = current.lessonName ?? "Лекция"
			self.start = current.from
			self.end = current.to
			self.onlineUrl = URL(string: current.url ?? "")
			self.professorName = current.professorName ?? ""

			self.state = .loaded
		} catch {
			self.response = error.localizedDescription

			self.state = .failedToLoad
		}
	}

	mutating func participate() async {
		self.response = ""
		self.state = .waitingForResponse

		do {
			try await API.Request.participate()
			self.state = .loaded
		} catch {
			self.response = error.localizedDescription
			self.state = .failedToLoad
		}
	}

}

extension RsvpView {
	enum Navigation {
		case qrCode
	}
}

struct RsvpView: View {

	@State private var vm = RsvpViewModel()

	@State private var prismViewBuilder = PrismViewBuilder()
	private func makePrismView() -> some View {
		prismViewBuilder.makePrismView {
			Text("Подтвердить участие")
		}
//		.onTapGesture(perform: reactRsvpButton)
	}

	private func reactRsvpButton() {
		withAnimation {
			prismViewBuilder.configuration.extrusion = 0.0
		}

		Task {
			await vm.participate()
			prismViewBuilder.configuration.extrusion = 20.0
		}
	}

	private func makeTimeTitleString() -> String {
		let dt = DateFormatter()
		dt.dateStyle = .none
		dt.timeStyle = .short

		let start = dt.string(from: self.vm.start ?? .now)
		let end = dt.string(from: self.vm.end ?? .now)

		return "\(start) - \(end)"
	}

	private func makeOnlineLink() -> AnyView {
		if let onlineUrl = vm.onlineUrl {
			return AnyView(erasing: Link("Онлайн", destination: onlineUrl))
		} else {
			return AnyView(erasing: Text("Аудитория"))
		}
	}

	private func makeInfoSection() -> some View {
		return VStack {
			Text(vm.lessonName).font(.title)
			Text(makeTimeTitleString()).font(.subheadline)
			Text("")
			Text("Преподаватель")
			Text(vm.professorName).font(.title2)
			Text("")
			Text("Где проходит").font(.title2)
			makeOnlineLink()
		}
	}

	private func makeStatusLabel() -> some View {
		Text("State: \(vm.state.rawValue)\n").font(.headline).foregroundColor(.gray)

	}

	private func makeResonse() -> some View {
		Text(vm.response)
	}

	private func makeLoadingView() -> some View {
		VStack {
			makeStatusLabel()
			Text("Загружаем данные\nПожалуйста подождите")
			ProgressView()
		}
	}

	private func makeFailedView() -> some View {
		VStack {
			makeStatusLabel()
			Text("Произошла ошибка")
			Button("Обновить") {
				Task { await vm.load() }
			}
			ScrollView {
				makeResonse()
			}
		}
	}

	@available(iOS 16.0, *)
	private func makeLoadedView() -> some View {
		VStack {
			Spacer()
			makeStatusLabel()
			makeInfoSection()
			Spacer()
			if vm.state == .loaded {
				NavigationLink(value: Navigation.qrCode) {
					makePrismView()
				}
			} else {
				ProgressView()
			}
			Spacer()
		}
		.navigationDestination(for: Navigation.self) { destination in
			switch destination {
			case .qrCode:
				QrCodeView()
			}
		}
	}

	@ViewBuilder @MainActor
	var stateDefinedView: some View {
		switch vm.state {
		case .firstLoad:
			makeLoadingView()
				.onAppear { Task { await vm.load() } }
		case .loaded:
			if #available(iOS 16.0, *) {
				makeLoadedView()
			} else {
				Text("unavailable in iOS < 16.0")
			}
		case .failedToLoad:
			makeFailedView()
		case .waitingForResponse:
			makeLoadingView()
		}
	}


	var body: some View {
		stateDefinedView
			.navigationTitle("Текущая Лекция")
	}

}

@available(iOS 16.0, *)
struct RsvpView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationStack {
			RsvpView()
		}
	}
}
