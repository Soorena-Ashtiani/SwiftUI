//
//  CardView.swift
//  Mobile_App_Two_Project
//
//  Created by Ali Osati on 3/26/23.
//

import SwiftUI

extension Shape {
    func fill(using offset: CGSize) -> some View {
        if offset.width == 0 {
            return self.fill(.white)
        } else if offset.width < 0 {
            return self.fill(.red)
        } else {
             return self.fill(.green)
        }
    }
}

struct CardView: View {
    let card: Card
    var removal: ((Bool) -> Void)? = nil

    @State private var feedback = UINotificationFeedbackGenerator()

    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled
    @State private var isShowingAnswer = false
    @State private var offset = CGSize.zero

    var body: some View {
        ZStack {
            
           
            
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(
                    differentiateWithoutColor
                    ? .purple
                    : .purple.opacity(1 - Double(abs(offset.width / 50)))
                )
                .background(
                    differentiateWithoutColor
                    ? nil
                    : RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .fill(
                            offset.width == 0 ? .purple
                            : offset.width > 0 ? .green : .red)
                )
                .shadow(radius: 10)
            

            VStack {
                if voiceOverEnabled {
                    Text(isShowingAnswer ? card.answer : card.prompt)
                        .font(.largeTitle)
                        .foregroundColor(.black)
                } else {
                    Text(card.prompt)
                        .font(.largeTitle)
                        .foregroundColor(.black)

                    if isShowingAnswer {
                        Text(card.answer)
                            .font(.title)
                            .foregroundColor(.green)
                    }
                }
            }
            .padding()
            .multilineTextAlignment(.center)
        }
        .frame(width: 450, height: 250)
        .rotationEffect(.degrees(Double(offset.width / 5)))
        .offset(x: offset.width * 5, y: 0)
        .opacity(2 - Double(abs(offset.width / 50)))
        .accessibilityAddTraits(.isButton)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation
                    feedback.prepare()
                }
                .onEnded { _ in
                    if abs(offset.width) > 100 {
                        if offset.width > 0 {
                            removal?(false)
                            feedback.notificationOccurred(.success)
                           
                        } else {
                            feedback.notificationOccurred(.error)
                            removal?(true)
                            offset = .zero
                        }

                        
                    } else {
                        offset = .zero
                    }
                }
        )
        .onTapGesture {
            isShowingAnswer.toggle()
        }
        .animation(.spring(), value: offset)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card.example)
    }
}
