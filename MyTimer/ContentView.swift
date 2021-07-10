//
//  ContentView.swift
//  MyTimer
//
//  Created by terada enishi on 2021/07/10.
//

import SwiftUI

struct ContentView: View {
    //タイマー
    @State var timerHandler : Timer?
    
    //一秒ごとに加算
    @State var count = 0
    
    //秒数設定(UserDefaults)
    @AppStorage("timer_value") var timerValue = 10
    
    @State var showAlert = false
    var body: some View {
        NavigationView{
            ZStack {
                Image("backgroundTimer")
                    .resizable()
                    .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                VStack(spacing: 30.0){
                    Text("残り\(timerValue - count)秒")
                        .font(.largeTitle)
                    HStack {
                        Button(action:{
                            startTimer()
                        }) {
                            Text("スタート")
                                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                                .foregroundColor(.white)
                                .frame(width: 140.0, height: 140.0)
                                .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color("StartColor")/*@END_MENU_TOKEN@*/)
                                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                        }
                        
                        Button(action:{
                            if let unwrapedTimerHandler = timerHandler{
                                if unwrapedTimerHandler.isValid == true{
                                    unwrapedTimerHandler.invalidate()
                                }
                            }
                        }) {
                            Text("ストップ")
                                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                                .foregroundColor(.white)
                                .frame(width: 140.0, height: 140.0)
                                .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color("StopColor")/*@END_MENU_TOKEN@*/)
                                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                        }
                    }
                }
            }
            .onAppear{
                count = 0
            }
            
            .navigationBarItems(trailing: NavigationLink(destination: SettingView()){
                Text("秒数設定")
                }
            )
            
            .alert(isPresented: $showAlert){
                Alert(title: Text("終了"),
                      message: Text("タイマー終了時間です"),
                      dismissButton: .default(Text("OK")))
            }
        }
    }
    
    func countDownTimer(){
        count += 1
        
        if timerValue - count <= 0{
            timerHandler?.invalidate()
            
            showAlert = true
        }
    }
    
    func startTimer(){
        
        if let unwrapedTimerHandler = timerHandler{
            if unwrapedTimerHandler.isValid == true{
                return
            }
        }
        
        if timerValue - count <= 0{
            count = 0
        }
        
        timerHandler = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){_ in
            countDownTimer()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
