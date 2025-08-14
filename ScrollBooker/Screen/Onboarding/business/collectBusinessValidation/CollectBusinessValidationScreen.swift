//
//  CollectBusinessValidationScreen.swift
//  ScrollBooker
//
//  Created by Raducu Balgiu on 14.08.2025.
//

import SwiftUI

struct CollectBusinessValidationScreen: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Image(systemName: "checkmark.circle")
                    .font(.system(size: 50))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.primarySB)
                    .padding(.bottom, .xl)
                
                Text("Felicitari! Ai finalizat inregistrarea")
                    .font(.largeTitle.bold())
                    .padding(.bottom, .xs)
                
                Text("Am primit toate detaliile despre business-ul tau. In scurt timp, echipa noastra va revizui aplicatia si te vom anunta imediat ce contul tau este aprobat.")
                    .font(.system(size: 19))
                    .foregroundColor(.gray)

                
                HStack {
                    Image(systemName: "clock")
                        .foregroundColor(.gray)
                    Text("De obicei raspundem in cateva minute")
                        .foregroundColor(.gray)
                }
                .padding(.vertical, .base)
                
                Text("Iata ce trebuie sa mai stii:")
                    .font(.title.bold())
                    .padding(.bottom, .xs)
                
                Text("Dupa ce iti vom valida detaliile locatiei, va fi necesar sa iti adaugi angajatii pentru a putea primi programari. Procesul este urmatorul:")
                    .foregroundColor(.gray)
                    .padding(.bottom, .base)
                
                BulletListItem(
                    text: "Angajatul va trebui sa isi creeze un cont in aplicatie ca user obisnuit",
                    color: .gray
                )
                
                BulletListItem(
                    text: "Dupa ce angajatul si-a creat contul, ii vei trimite o cerere de angajare",
                    color: Color.gray
                )
                
                BulletListItem(
                    text: "Angajatul va primi cererea ta si va fi necesar sa o accepte. Cand o va accepta il vom cupla la business-ul tau si va primi access la propriul calendar, va gestiona propriile produse in cadrul locatiei tale",
                    color: Color.gray
                )
                .padding(.bottom, .base)
                
                Text("Nu iti face griji, procesul este unul foarte simplu. Vei gasi inclusiv un ghid video dupa ce te vei loga in aplicatie.")
                    .fontWeight(.semibold)
                    .foregroundColor(.onBackgroundSB)
                    .padding(.bottom, .base)
            }
            .padding(.xl)
        }
    }
}

#Preview("Light") {
    CollectBusinessValidationScreen()
}

#Preview("Dark") {
    CollectBusinessValidationScreen()
        .preferredColorScheme(.dark)
}
