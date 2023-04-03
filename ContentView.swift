//
//  ContentView.swift
//  Mobile_App_Two_Project
//
//  Created by Ali Osati on 3/26/23.
//

import SwiftUI
import AVKit

struct RandomModel: Identifiable {
    let id =  UUID().uuidString
    let title: String
}

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        return self.offset(x: 0, y: offset * 10)
    }
}

struct ContentView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    
    @State var selectedModel: RandomModel? = nil
    
    
//    @State private var player = AVPlayer()
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled
    @State private var cards = DataManager.load()

    @State private var timeRemaining = 120
//    @State private var manual = "Manual"
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    @Environment(\.scenePhase) var scenePhase
    @State private var isActive = true

    @State private var showingEditScreen = false

    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .ignoresSafeArea()
            
                

            VStack {
//                VideoPlayer(player: AVPlayer(url: Bundle.main.url(forResource: "video", withExtension: "MOV")!))
               
                HStack{
                    
                   
//
//                    Text(" \(manual)")
//                        .font(.largeTitle)
//                        .foregroundColor(.white)
//                        .padding(.horizontal,10)
//                        .padding(.vertical, 5)
//                        .background(.black.opacity(0.75))
//                        .clipShape(Capsule())
                    
                   
                    
                    Button {
//                        showingEditScreen = true
                        selectedModel = RandomModel(title: "")
                    } label: {
                        Image(systemName: "play.circle")
                            .padding()
                            .background(.black.opacity(0.7))
                            .clipShape(Capsule())
                            
                    }

                    .sheet(item: $selectedModel) { model in
                     NextScreen(selectedModel: model)
                    }

                    
                    
                    

                
                    
                Text("Time: \(timeRemaining)")
                    .font(.largeTitle)
                    .foregroundColor(.red)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .background(.black.opacity(0.75))
                    .clipShape(Capsule())
                
        
                 
                
               
                }
                
                ZStack {
                    ForEach(Array(cards.enumerated()), id: \.element) { item in
//                        let index = cards.firstIndex(of: card)!
                        CardView(card: item.element) { reinsert in
                            withAnimation {
                                removeCard(at: item.offset, reinsert: reinsert)
                            }
                        }
                        .stacked(at: item.offset, in: cards.count)
                        .allowsHitTesting(item.offset == cards.count - 1)
                        .accessibilityHidden(item.offset < cards.count - 1)
                    }
                }
                .allowsHitTesting(timeRemaining > 0)

                if cards.isEmpty {
                    Button("Start Again", action: resetCards)
                        .padding()
                        .background(.yellow)
                        .foregroundColor(.black)
                        .clipShape(Capsule())
                }
                
                if timeRemaining == 0 {
                    Button("Start Again", action: resetCards)
                        .padding()
                        .background(.yellow)
                        .foregroundColor(.black)
                        .clipShape(Capsule())
                }
            }
            
        

            VStack {
                
              
                
                
                HStack {
                    
                  
                    
                    Spacer()
                    
                

                    Button {
                        showingEditScreen = true
                    } label: {
                        Image(systemName: "plus.circle")
                            .padding()
                            .background(.black.opacity(0.7))
                            .clipShape(Circle())
                    }
                }
                
             

                Spacer()
                
                
            }
            
//
//            VStack {
//                HStack {
//                    Spacer()
//
//                    Button {
//                        showingEditScreen = true
//                    } label: {
//                        Image(systemName: "plus.circle")
//                            .padding()
//                            .background(.black.opacity(0.7))
//                            .clipShape(Circle())
//                    }
//                }
//
//                Spacer()
//            }
            
            
            
            
            .foregroundColor(.white)
            .font(.largeTitle)
            .padding()

            if differentiateWithoutColor || voiceOverEnabled {
                VStack {
                    Spacer()

                    HStack {
                        Button {
                            withAnimation {
                                removeCard(at: cards.count - 1, reinsert: true)
                            }
                        } label: {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibilityLabel("Wrong")
                        .accessibilityHint("Mark your answer as being incorrect")
                       
                        Spacer()

                        Button {
                            withAnimation {
                                removeCard(at: cards.count - 1, reinsert: false)
                            }
                        } label: {
                            Image(systemName: "checkmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibilityLabel("Correct")
                        .accessibilityHint("Mark your answer is being correct.")
                    }
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding()
                }
            }
        }
        .onReceive(timer) { time in
            guard isActive else { return }

            if timeRemaining > 0 {
                timeRemaining -= 1
            }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                if cards.isEmpty == false {
                    isActive = true
                }
            } else {
                isActive = false
            }
        }
        .sheet(isPresented: $showingEditScreen, onDismiss: resetCards, content: EditCards.init)
        .onAppear(perform: resetCards)
    }

  
    func removeCard(at index: Int, reinsert: Bool) {
        guard index >= 0 else { return }
        
        if reinsert{
            cards.move(fromOffsets: IndexSet(integer: index), toOffset: 0)
        }else{
//            cards.remove(at: index)
        }
        cards.remove(at: index)

        if cards.isEmpty {
            isActive = false
        }
    }

    func resetCards() {
        timeRemaining = 120
        isActive = true
        cards = DataManager.load()
    }
}

struct NextScreen: View {
    @State private var player = AVPlayer()
    @Environment(\.dismiss) var dismiss
    let selectedModel: RandomModel
    var body: some View{
        VideoPlayer(player: AVPlayer(url: Bundle.main.url(forResource: "video", withExtension: "mov")!))
        Button("Done", action: done)
        
//        Text(selectedModel.title)
//            .font(.largeTitle)
    }
  
    func done() {
        dismiss()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
    
}



