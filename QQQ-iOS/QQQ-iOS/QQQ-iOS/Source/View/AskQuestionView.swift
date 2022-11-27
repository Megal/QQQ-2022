//
//  AskQuestionView.swift
//  QQQ-iOS
//
//  Created by Svyatoshenko "Megal" Misha on 2022-11-27.
//

import SwiftUI

struct IdentifiableQuestion: Identifiable {
	let id: Int
	let question: String
}

struct AskQuestionView: View {
	private let questions: [IdentifiableQuestion] = [
		.init(id: 1, question: "Загадка на логику"),
		.init(id: 2, question: "Перекличка!"),
		.init(id: 3, question: "Загадка на счет"),
		.init(id: 7, question: "Опрос"),
		.init(id: 8, question: "Отзыв о лекции"),
	]

	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

	var body: some View {
		List(questions) { item in
			Button(item.question) { back() }
		}
		.navigationTitle("Задать вопрос")
	}

	private func back() {
		if presentationMode.wrappedValue.isPresented {
			presentationMode.wrappedValue.dismiss()
		}
	}

}

@available(iOS 16.0, *)
struct AskQuestionView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationStack {
			AskQuestionView()
				.navigationTitle("Задать вопрос")
		}
	}
}
