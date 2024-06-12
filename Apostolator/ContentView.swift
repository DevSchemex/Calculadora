//
//  ContentView.swift
//  Apostolator
//
//  Created by Alex.personal on 18/5/24.
//

import SwiftUI
import Engine
import DesignSystem

struct ContentView: View {
    @ObservedObject var viewModel: ApostolatorViewModel
    @StateObject private var orientationManager = OrientationManager()

    var body: some View {
        
            if orientationManager.orientation == .portrait {
                VStack(alignment: .center) {
                    MainContent(viewModel: viewModel)
                }
                  
            } else {
                Spacer()
                HStack {
                    VStack(alignment: .trailing) {
                        MainContent(viewModel: viewModel)
                    }
                        
                }.frame(maxWidth: .infinity, alignment: .trailing)
            }
       
    }
}

struct MainContent: View {
    @ObservedObject var viewModel: ApostolatorViewModel
    
    var body: some View {
     
            VStack(alignment: .trailing) {
                ScrollViewReader { scrollViewProxy in
                    List(viewModel.engine.results) { result in
                        HStack {
                            
                            Text("\(result.firstValue) \(result.sign) \(result.lastValue) = \(result.total)")
                                .foregroundStyle(.customLightGray)
                                .opacity(0.5)
                                .multilineTextAlignment(.trailing)
                        }
                    }
                    .listStyle(.plain)
                    .listRowSeparator(.hidden)
                    .onChange(of: viewModel.engine.results) { _ in
                        if let lastResult = viewModel.engine.results.last {
                            withAnimation {
                                scrollViewProxy.scrollTo(lastResult.id, anchor: .bottom)
                            }
                        }
                    }
                }
            }.padding(.top)
            
            HStack {
                Text(viewModel.engine.text)
                    .multilineTextAlignment(.trailing)
                    .font(.system(size: 40))
                    .foregroundColor(.white)
            }.frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 40)
            
            VStack {
                ForEach(viewModel.buttons.indices, id: \.self) { rowIndex in
                    HStack(spacing: 20) {
                        ForEach(viewModel.buttons[rowIndex]) { button in
                            StandardButton(model: button, isSelected: viewModel.selectedButtonId == button.id, action: {
                                viewModel.selectButton(id: button.id)
                                button.action()
                            })
                        }
                    }
                }
            }
        }
}

#Preview {
    ContentView(viewModel: ApostolatorViewModel(engine: Engine()))
}


extension Color {
    var customLightGray: Color {
        Color("CustomcustomLightGray")
    }
}
