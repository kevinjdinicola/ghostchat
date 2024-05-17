//
//  ExchangeDetails.swift
//  GhostChat
//
//  Created by Kevin Dinicola on 5/10/24.
//

import SwiftUI


struct ExchangeDetails: View {
    
    var exchangeId: WideId;
    
    @StateObject
    var model: ExchangeDetailsDataContext = ExchangeDetailsDataContext()
    
    @State
    var dispatcher: ExchangeDispatcherProtocol?;
    
    @State var composingMessage: String = ""
    @FocusState private var isComposingFieldFocused: Bool
    
    func scrollToBottom(svp: ScrollViewProxy) {
        if (model.messages.count > 0) {
            svp.scrollTo(model.messages[model.messages.count-1].id, anchor: .bottom)
        }
    }
    
    var body: some View {
        VStack {
            ScrollView {
                ScrollViewReader(content: { proxy in
                    VStack(alignment: .leading) {
                        ForEach(model.messages, id: \.id) { message in
                            HStack {
                                message.isSelf ? Spacer() : nil
                                MessageView(message: message)
                                !message.isSelf ? Spacer() : nil
                            }
                        }
                        .onChange(of: model.messages) {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                scrollToBottom(svp: proxy)
                            }
                            
                        }
                        .onAppear(perform: {
                            scrollToBottom(svp: proxy)
                        })
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(10)
                    .onChange(of: isComposingFieldFocused) { _, focused in
                        if focused {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { // 2 seconds delay
                                print("now I GOOOOO")
                                //so hacky, do this after the keyboard shows
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    scrollToBottom(svp: proxy)
                                }
                            }
                        }
                    }
                    
                })
                .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
            HStack {
                TextField("Message", text: $composingMessage)
                    .focused($isComposingFieldFocused)
                Button(action: {
                    // todo change to an emit
                    dispatcher?.emitAction(action: .sendMessage(text: composingMessage))
                    composingMessage = ""
                }, label: {
                    Image(systemName: "arrow.up.circle.fill")
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .frame(maxHeight: 30)
                })
            }
            .padding(10)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.gray, lineWidth: 1)
            )
            .padding(.horizontal, 10)
            .padding(.bottom, 5)
            
        }
        .frame(maxWidth: .infinity)
        .navigationTitle(model.displayName ?? "loading")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack {
                    ConnectionStatusIndicator(connection_count: model.connections)
                    Spacer()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: {
            self.dispatcher = AppHostWrapper.shared.app?.createExchangeContextDispatch(exchangeId: self.exchangeId)
            self.dispatcher?.registerResponder(responder: self.model)
            self.dispatcher?.emitAction(action: .start)
        })

    }
}

#Preview {
    let eddc = ExchangeDetailsDataContext()
    eddc.displayName = "Homer Simpson"
    eddc.connections = 1
    eddc.messages = [
      
        
    ]
    return ExchangeDetails(exchangeId: WideId(p1: 0, p2: 0, p3: 0, p4: 0))
    
}
