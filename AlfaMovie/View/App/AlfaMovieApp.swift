//
//  AlfaMovieApp.swift
//  AlfaMovie
//
//  Created by reyhan muhammad on 2025/7/24.
//

import SwiftUI
import FirebaseRemoteConfig

@main
struct AlfaMovieApp: App {
    
    @ObservedObject var vm = AppViewModel()
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
    var body: some Scene {
        WindowGroup {
            if vm.shouldShowMainView{
                ZStack{
                    NavigationView {
                        HomeView(vm: HomeViewModel(service: HomeUseCase(repository: HomeRepository(executor: NetworkExecutor()))))
                            .navigationViewStyle(.stack)
                    }
                    .navigationViewStyle(.stack)
                    if vm.shouldShowNoInternetConnection{
                        NoInternetView(isPresented: $vm.shouldShowNoInternetConnection, actions: .init(clickReloadButton: {
                            vm.userAskToReload()
                        }, cancel: {
                            return
                        })).transition(.move(edge: .bottom))
                    }
                    if vm.shouldShowSlowInternetView{
                        VStack{
                            Spacer()
                            SlowInternetView(isPresented: $vm.shouldShowSlowInternetView, text: "Your internet seems to be slow, reload?", actions: .init(reload: {
                                vm.userAskToReload()
                            }, cancel: {
                                return
                            }))
                            .transition(.move(edge: .bottom))
                        }
                    }
                    if vm.shouldShowSessionIssue{
                        VStack{
                            Spacer()
                            SlowInternetView(isPresented: $vm.shouldShowSlowInternetView, text: "Something occured, reload?", actions: .init(reload: {
                                vm.userAskToReload()
                            }, cancel: {
                                return
                            }))
                            .transition(.move(edge: .bottom))
                        }
                    }
                }
            }else if vm.showFailedToFetchRemoteConfig{
                VStack{
                    Image(AssetImage.noInternetImage.rawValue).resizable().aspectRatio(contentMode: .fit).padding(.horizontal, 20)
                    HStack{
                        Button {
                            vm.getRemoteConfig()
                        } label: {
                            HStack{
                                Spacer()
                                Text("Retry").bold().foregroundStyle(Color(uiColor: .systemBackground))
                                Spacer()
                            }
                            .frame(height: 60)
                            .background(Color(hex: "38CB7D"))
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                        }
                    }
                }.padding(.horizontal, 20)
            }else{
                SplashView()
            }
        }
    }
}

