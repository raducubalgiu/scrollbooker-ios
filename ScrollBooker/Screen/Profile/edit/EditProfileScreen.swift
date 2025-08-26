//
//  EditProfileScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 26.08.2025.
//

import SwiftUI

struct EditProfileScreen: View {
    var onNavigate: (Route) -> Void
    
    var body: some View {
        VStack {
            Header(title: "Editeaza profilul")
            
            VStack(alignment: .leading) {
                Text("Despre tine")
                    .font(.headline.bold())
                    .foregroundColor(.gray)
                    .padding(.top, .base)
                
                Button {
                    onNavigate(.editFullName)
                } label: {
                    HStack {
                        Text("Nume")
                            .font(.headline.bold())
                            .foregroundColor(.onBackgroundSB)
                        
                        Spacer()
                        
                        HStack {
                            Text("Radu Ion")
                                .font(.subheadline.bold())
                                .foregroundColor(.gray)
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, .m)
                }
                
                Button {
                    onNavigate(.editUsername)
                } label: {
                    HStack {
                        Text("Utilizator")
                            .font(.headline.bold())
                            .foregroundColor(.onBackgroundSB)
                        
                        Spacer()
                        
                        HStack {
                            Text("@radu_ion")
                                .font(.subheadline.bold())
                                .foregroundColor(.gray)
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, .m)
                }
                
                Button {
                    onNavigate(.editGender)
                } label: {
                    HStack {
                        Text("Gen")
                            .font(.headline.bold())
                            .foregroundColor(.onBackgroundSB)
                        
                        Spacer()
                        
                        HStack {
                            Text("Prefer sa nu spun")
                                .font(.subheadline.bold())
                                .foregroundColor(.gray)
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, .m)
                }
                
                Button {
                    onNavigate(.editProfession)
                } label: {
                    HStack {
                        Text("Profesie")
                            .font(.headline.bold())
                            .foregroundColor(.onBackgroundSB)
                        
                        Spacer()
                        
                        HStack {
                            Text("Stylist")
                                .font(.subheadline.bold())
                                .foregroundColor(.gray)
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, .m)
                }
                
                Spacer()
            }
            .padding(.horizontal)
        }
    }
}

#Preview("Light") {
    EditProfileScreen { _ in }
}

#Preview("Dark") {
    EditProfileScreen { _ in }
        .preferredColorScheme(.dark)
}
