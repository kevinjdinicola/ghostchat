//
//  ExchangeList.swift
//  GhostChat
//
//  Created by Kevin Dinicola on 5/10/24.
//

import SwiftUI


struct ExchangeList: View {
    
    @EnvironmentObject
    var global: GlobalDataContext;
    
    @State
    var dispatch: GlobalAppDispatcher?;
    
    @State
    var showingConnect: Bool = false
    
    @State
    var showingIdentity: Bool = false
    
    func printId() {
        let i = global.assumedIdentity!;
        print("you are \(i.name) at (\(i.publicKey)")
    }
    
    func delete(at offsets: IndexSet) {
        for index in offsets {
            let item = global.exchanges[index]
            dispatch?.emitAction(action: .deleteExchange(item.id))
        }
    }
    
    var body: some View {
        NavigationSplitView {
            VStack {    
                if global.exchanges.isEmpty {
                    Spacer()
                    Text("No chats")
                        .font(.title2)
                        .foregroundStyle(.gray)
                        .padding()

                    Spacer()
                } else {
                    List {
                        ForEach(global.exchanges, id: \.id) { ex in
                            NavigationLink(destination: {
                                ExchangeDetails(exchangeId: ex.id)
                            }, label: {
                                ExchangeRow(data: ex)
                            })
                        }
                        .onDelete(perform: delete)
                    }
                    .listStyle(.inset)
                }
            }
            .navigationTitle("GhostChat")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        print("refreshing all...")
                        AppHostWrapper.shared.app?.globalDispatch().emitAction(action: .wakeFromSleep);
                    } label: {
                        Label("Identification", systemImage: "arrow.clockwise")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingIdentity = true
                    } label: {
                        Label("Debug", systemImage: "person.circle")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        self.global.debug_showing = true
                        print("set global data to true")
                    } label: {
                        Label("Debug", systemImage: "ladybug")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        self.showingConnect = true
                    } label: {
                        Label("Connect", systemImage: "plus.bubble")
                    }
                }
                
            })
            
        } detail: {
            Text("Nothing selected")
        }
        .sheet(isPresented: $showingConnect, content: {
            EstablishConnectionView(showingInSheet: $showingConnect)
        })
        .sheet(isPresented: $showingIdentity, content: {
            IdentityDetails()
        })
        .onAppear(perform: {
            self.dispatch = AppHostWrapper.shared.app?.globalDispatch();
        })
    }
}

#Preview {
    let gdc = GlobalDataContext();
    gdc.exchanges = [
        ExchangeListItem(id: WideId(1), label: "hi", pic: nil,  connections: 1)
    ]

    return ExchangeList()
        .environmentObject(gdc)
}
