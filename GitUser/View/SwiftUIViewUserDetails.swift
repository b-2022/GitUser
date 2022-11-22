//
//  SwiftUIViewUserDetails.swift
//  GitUser
//
//  Created by Boon on 07/11/2022.
//

import SwiftUI

class SwiftUIViewHostingController: UIHostingController<SwiftUIViewUserDetails> {
    var login: String?
    var dataModel: ViewModelUserDetails = ViewModelUserDetails()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: SwiftUIViewUserDetails(textNote: "", dataModal: dataModel))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dataModel.loadData(login: login ?? "")
    }
}

struct SwiftUIViewUserDetails: View {
    @State var textNote: String
    @ObservedObject var dataModal: ViewModelUserDetails
    
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
                Text("\(self.dataModal.user?.detail?.followers ?? 0)")
                Spacer()
                Text("Following")
                Text("\(self.dataModal.user?.detail?.following ?? 0)")
                    .padding(.trailing, 20)
            }
            
            //Info Name
            VStack{
                HStack{
                    Text("Name : ")
                    Text("\(self.dataModal.user?.detail?.name ?? "")")
                    Spacer()
                }
                
                HStack{
                    Text("Company : ")
                    Text("\(self.dataModal.user?.detail?.company ?? "")")
                    Spacer()
                }
                
                HStack{
                    Text("Blog : ")
                    Text("\(self.dataModal.user?.detail?.blog ?? "")")
                    Spacer()
                }
                
            }.padding(.leading, 10)
            .frame(maxWidth: .infinity, maxHeight: 100)
            .border(.black, width: 1)
            .padding(20)
            
                
            Spacer().frame(height: 0)
            
            //Notes
            Text("Notes: \(dataModal.user?.note?.note ?? "Nothing")")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
                .padding(.trailing, 20)
            
            
            TextEditor(text: $dataModal.newUser?.name ?? "")
                .frame(maxWidth: .infinity, maxHeight: 100)
                .border(.black, width: 1)
                .padding(.leading, 20)
                .padding(.trailing, 20)
            
            Spacer().frame(height: 20)
            //Save Button
            Button("Save") {
                print("Button Action : \(dataModal.user?.note?.note ?? "")")
                dataModal.saveNote(textNote)
            }.frame(width: 100, height: 40)
                .cornerRadius(20)
                .background(Color.blue)
                .foregroundColor(Color.white)
                

            Spacer()
        }
        .onAppear {
            textNote = dataModal.user?.note?.note ?? ""
            print("note : \(dataModal.user?.note?.note ?? "")")
        }
    }
}

struct SwiftUIViewUserDetails_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIViewUserDetails(textNote: "", dataModal: ViewModelUserDetails())
    }
}
