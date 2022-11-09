//
//  SwiftUIViewUserDetails.swift
//  GitUser
//
//  Created by Boon on 07/11/2022.
//

import SwiftUI

class SwiftUIViewHostingController: UIHostingController<SwiftUIViewUserDetails> {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: SwiftUIViewUserDetails())
    }
}

struct SwiftUIViewUserDetails: View {
    
    @State private var textNote: String = ""
    
    var body: some View {
        VStack {
            HStack{
                Image("user")
            }
            .frame(maxWidth: .infinity, maxHeight: 250)
            .background(Color(UIColor.lightGray))
            
            Spacer().frame(height: 20)
            
            //Follower & Following
            HStack{
                Text("Followers : ")
                    .padding(.leading, 20)
                Text("12345")
                Spacer()
                Text("Following")
                Text("1234")
                    .padding(.trailing, 20)
            }
            
            //Info Name
            VStack{
                HStack{
                    Text("Name : ")
                    Text("John")
                    Spacer()
                }
                
                HStack{
                    Text("Company : ")
                    Text("Apple")
                    Spacer()
                }
                
                HStack{
                    Text("Blog : ")
                    Text("www.comape.com")
                    Spacer()
                }
                
            }.padding(.leading, 10)
            .frame(maxWidth: .infinity, maxHeight: 100)
            .border(.black, width: 1)
            .padding(20)
            
                
            Spacer().frame(height: 0)
            
            //Notes
            Text("Notes:")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
                .padding(.trailing, 20)
            
            TextEditor(text: $textNote)
                .frame(maxWidth: .infinity, maxHeight: 100)
                .border(.black, width: 1)
                .padding(.leading, 20)
                .padding(.trailing, 20)
            
            Spacer().frame(height: 20)
            //Save Button
            Button("Save") {
                print("Button Action")
            }.frame(width: 100, height: 40)
                .cornerRadius(20)
                .background(Color.blue)
                .foregroundColor(Color.white)
                

            
            Spacer()
        }
            
        
    }
}

struct SwiftUIViewUserDetails_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIViewUserDetails()
    }
}
