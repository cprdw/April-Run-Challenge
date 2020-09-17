//
//  ContentView.swift
//  April Counter
//
//  Created by Chester de Wolfe on 4/2/20.
//  Copyright © 2020 Chester de Wolfe. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Values.entity(),
                  sortDescriptors: [])
    
    var allVals: FetchedResults<Values>
    var other: String {
        fill()
        return ""
    }
    var daysUntil: DateComponents {
        let startDate = "2020-05-01"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formatedStartDate = dateFormatter.date(from: startDate)
        let currentDate = Date()
        let components = Set<Calendar.Component>([.second, .minute, .hour, .day, .month, .year])
        let differenceOfDate = Calendar.current.dateComponents(components, from: currentDate, to: formatedStartDate!)

        return differenceOfDate
    }
    @State var pushupsDone = 0.0
    @State var runningDone = 0.0
    @State var sitUpsDone = 0.0
    @State var otherDone = 0.0
    var body: some View {
        NavigationView {
                    VStack {
                        Spacer(minLength: 50)
                        ScrollView(.vertical, showsIndicators: false) {
                            Spacer()
                            VStack {
                                Text("Countdown Clock")
                                .bold()
                                    .font(.title)

                                Text("Days Left: \(daysUntil.day! + daysUntil.month! * 30)")
                                .bold()
                                    .font(.title)
                            }

                            Spacer()
                            VStack {
                                Text("Total Progress")
                                    .bold()
                                    .font(.headline)
                                ProgressRing(color1: #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1), color2: #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1), width: 200, height: 200, percent: CGFloat(100 * (self.pushupsDone/100 + self.runningDone  + self.sitUpsDone * 2) / 100 ), colorPercent: true)

                            }
        //                    .frame(width: 350, height: 250)
        //                    .background(Color(#colorLiteral(red: 0.7299331427, green: 0.8136903644, blue: 0.8814209104, alpha: 1)))
        //                    .cornerRadius(10)
                            Spacer()
                            Spacer()
                            CardView1(value: self.$pushupsDone)
                                .padding(.top)
                            CardView2(pushupsEntered: "1", name: "Run", topVal: "100.00", value: $runningDone, index: 1, top: 100)
                            //CardView3(value: $sitUpsDone)
                           // CardView4(value: $otherDone)



                            Spacer()
                        }
                        }
                    //.navigationBarTitle(Text("April Workouts"))
                        .frame(maxWidth: .infinity)
                            .frame(maxHeight: .infinity)
                        .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)), Color(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .edgesIgnoringSafeArea(.all)


                }
        .onAppear {
            self.fill()
            print(self.allVals.first!.milesWalked)

            print("calledAppear")
            //self.pushupsDone = self.allVals.first?.pushups ?? 0
            //self.sitUpsDone = self.allVals.first?.sitUps ?? 0
            self.runningDone = self.allVals.first!.milesRun
            self.pushupsDone = self.allVals.first!.milesBiked
            self.sitUpsDone = self.allVals.first!.milesWalked
            //self.otherDone = self.allVals.first!.sitUps


        }
        
    }

    func fill() {
        
        if allVals.isEmpty {
            print("calledFillWithChange")

            var newVals = Values(context: moc)
            newVals.milesBiked = 0.0
            newVals.milesRun = 0.0
            newVals.pushups = 0
            newVals.sitUps = 0
            newVals.milesWalked = 0.0
            do {
                try self.moc.save()
            } catch {
                return
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// pushups // miles biked
struct CardView1: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Values.entity(),
                  sortDescriptors: [])
    
    var allVals: FetchedResults<Values>
    @State var pushupsEntered = "25"
    var name = "Pushups"
    var topVal = "10,000"
    @Binding var value: Double
    var index = 0
    var top = 10000
    var other = 25
    var val: Int {
        self.pushupsEntered = "\(other)"
        return 1
    }
    var body: some View {
        VStack (alignment: .center){
            Text(name)
            .bold()
            .font(.title)
           HStack {

                ZStack {
                    HStack {

                            ProgressRing(color1: #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1), color2: #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1), width: 100, height: 100, percent: CGFloat(100 * value / Double(top)), colorPercent: true)


                        Spacer()
                        VStack (alignment: .center){
                            Text("\(value, specifier: "%.2f")")
                            Text("/ \(topVal)")
                        }
                        .font(.title)
                    }
                }
                .padding()
                .frame(width: 270, height: 150)
                .background(Color(.white).opacity(0.6))
                .cornerRadius(10)

                VStack {

                    Button(action: {
                        var num = (self.pushupsEntered as NSString).doubleValue
                        var num2 = self.value
                        self.value = num + num2
                        self.allVals.first!.milesBiked = self.value

                        do {
                            try self.moc.save()
                        } catch {
                            return
                        }
                    }) {

                        Image(systemName: "plus")
                            .foregroundColor(.black)

                    }
                    .frame(width: 70, height: 40)
                    .background(Color(.white).opacity(0.6))
                    .cornerRadius(10)

                    //                    Picker(selection: self.$pushupsEntered, label:
                    //                        Text("")
                    //                        , content: {
                    //                            ForEach(1 ..< 26) { num in
                    //                                Text("\(num)").tag(num)
                    //                            }
                    //                    })
                    TextField("", text: self.$pushupsEntered)
                        .frame(height: 50)

                        .background(Color(#colorLiteral(red: 0.7474709153, green: 0.821385324, blue: 0.8763356805, alpha: 1)))
                        .cornerRadius(10)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 70)
                    Button(action: {
                        var num = (self.pushupsEntered as NSString).doubleValue
                        var num2 = self.value
                        self.value -= num
                        self.allVals.first!.milesBiked = self.value
                        do {
                            try self.moc.save()
                        } catch {
                            return
                        }

                    }) {

                        Image(systemName: "minus")
                            .foregroundColor(.black)

                    }
                    .frame(width: 70, height: 40)
                    .background(Color(.white).opacity(0.6))
                    .cornerRadius(10)
                }
            }
        }
    }
}

struct CardView2: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Values.entity(),
                  sortDescriptors: [])
    
    var allVals: FetchedResults<Values>
    @State var pushupsEntered = "25"
    var name = "Pushups"
    var topVal = "10,000"
    @Binding var value: Double
    var index = 0
    var top = 10000
    var other = 25
    var val: Int {
        self.pushupsEntered = "\(other)"
        return 1
    }
    var body: some View {
        VStack (alignment: .center){
            Text(name)
            .bold()
            .font(.title)
           HStack {

                ZStack {
                    HStack {

                            ProgressRing(color1: #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1), color2: #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1), width: 100, height: 100, percent: CGFloat(100 * value / Double(top)), colorPercent: true)


                        Spacer()
                        VStack (alignment: .center){
                            Text("\(value, specifier: "%.2f")")
                            Text("/ 100")
                        }
                        .font(.title)
                    }
                }
                .padding()
                .frame(width: 270, height: 150)
                .background(Color(.white).opacity(0.6))
                .cornerRadius(10)

                VStack {

                    Button(action: {
                        var num = (self.pushupsEntered as NSString).doubleValue
                        var num2 = self.value
                        self.value = num + num2
                        self.allVals.first!.milesRun = self.value
                        do {
                            try self.moc.save()
                        } catch {
                            return
                        }
                    }) {

                        Image(systemName: "plus")
                            .foregroundColor(.black)

                    }
                    .frame(width: 70, height: 40)
                    .background(Color(.white).opacity(0.6))
                    .cornerRadius(10)

                    //                    Picker(selection: self.$pushupsEntered, label:
                    //                        Text("")
                    //                        , content: {
                    //                            ForEach(1 ..< 26) { num in
                    //                                Text("\(num)").tag(num)
                    //                            }
                    //                    })
                    TextField("", text: self.$pushupsEntered)
                        .frame(height: 50)

                        .background(Color(#colorLiteral(red: 0.7474709153, green: 0.821385324, blue: 0.8763356805, alpha: 1)))
                        .cornerRadius(10)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 70)
                    Button(action: {
                        var num = (self.pushupsEntered as NSString).doubleValue
                        var num2 = self.value
                        self.value -= num
                        self.allVals.first!.milesRun = self.value
                        do {
                            try self.moc.save()
                        } catch {
                            return
                        }

                    }) {

                        Image(systemName: "minus")
                            .foregroundColor(.black)

                    }
                    .frame(width: 70, height: 40)
                    .background(Color(.white).opacity(0.6))
                    .cornerRadius(10)
                }
            }
        }
    }
}

struct CardView3: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Values.entity(),
                  sortDescriptors: [])
    
    var allVals: FetchedResults<Values>
    @State var pushupsEntered = "3"
    var name = "Biking"
    var topVal = "300"
    @Binding var value: Double
    var index = 0
    var top = 300
    var other = 25
    var val: Int {
        self.pushupsEntered = "\(other)"
        return 1
    }
    var body: some View {
        VStack (alignment: .center){
            Text(name)
            .bold()
            .font(.title)
           HStack {

                ZStack {
                    HStack {

                            ProgressRing(color1: #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1), color2: #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1), width: 100, height: 100, percent: CGFloat(100 * value / Double(top)), colorPercent: true)


                        Spacer()
                        VStack (alignment: .center){
                            Text("\(value, specifier: "%.2f")")
                            Text("/ \(topVal)")
                        }
                        .font(.title)
                    }
                }
                .padding()
                .frame(width: 270, height: 150)
                .background(Color(.white).opacity(0.6))
                .cornerRadius(10)

                VStack {

                    Button(action: {
                        var num = (self.pushupsEntered as NSString).doubleValue
                        var num2 = self.value
                        self.value = num + num2
                        self.allVals.first!.milesWalked = self.value
                        do {
                            try self.moc.save()
                        } catch {
                            return
                        }
                    }) {

                        Image(systemName: "plus")
                            .foregroundColor(.black)

                    }
                    .frame(width: 70, height: 40)
                    .background(Color(.white).opacity(0.6))
                    .cornerRadius(10)

                    //                    Picker(selection: self.$pushupsEntered, label:
                    //                        Text("")
                    //                        , content: {
                    //                            ForEach(1 ..< 26) { num in
                    //                                Text("\(num)").tag(num)
                    //                            }
                    //                    })
                    TextField("", text: self.$pushupsEntered)
                        .frame(height: 50)

                        .background(Color(#colorLiteral(red: 0.7474709153, green: 0.821385324, blue: 0.8763356805, alpha: 1)))
                        .cornerRadius(10)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 70)
                    Button(action: {
                        var num = (self.pushupsEntered as NSString).doubleValue
                        var num2 = self.value
                        self.value -= num
                        self.allVals.first!.milesWalked = self.value
                        do {
                            try self.moc.save()
                        } catch {
                            return
                        }

                    }) {

                        Image(systemName: "minus")
                            .foregroundColor(.black)

                    }
                    .frame(width: 70, height: 40)
                    .background(Color(.white).opacity(0.6))
                    .cornerRadius(10)
                }
            }
        }
    }
}

//struct CardView4: View {
//    @Environment(\.managedObjectContext) var moc
//    @FetchRequest(entity: Values.entity(),
//                  sortDescriptors: [])
//
//    var allVals: FetchedResults<Values>
//    @State var pushupsEntered = "3"
//    var name = "Pushups"
//    var topVal = "10000"
//    @Binding var value: Double
//    var index = 0
//    var top = 10000
//    var other = 25
//    var val: Int {
//        self.pushupsEntered = "\(other)"
//        return 1
//    }
//    var body: some View {
//        VStack (alignment: .center){
//            Text(name)
//            .bold()
//            .font(.title)
//           HStack {
//
//                ZStack {
//                    HStack {
//
//                            ProgressRing(color1: #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1), color2: #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1), width: 100, height: 100, percent: CGFloat(100 * value / Double(top)), colorPercent: true)
//
//
//                        Spacer()
//                        VStack (alignment: .center){
//                            Text("\(value, specifier: "%.2f")")
//                            Text("/ \(topVal)")
//                        }
//                        .font(.title)
//                    }
//                }
//                .padding()
//                .frame(width: 270, height: 150)
//                .background(Color(.white).opacity(0.6))
//                .cornerRadius(10)
//
//                VStack {
//
//                    Button(action: {
//                        var num = (self.pushupsEntered as NSString).doubleValue
//                        var num2 = self.value
//                        self.value = num + num2
//                        self.allVals.first!.sitUps = self.value
//                        do {
//                            try self.moc.save()
//                        } catch {
//                            return
//                        }
//                    }) {
//
//                        Image(systemName: "plus")
//                            .foregroundColor(.black)
//
//                    }
//                    .frame(width: 70, height: 40)
//                    .background(Color(.white).opacity(0.6))
//                    .cornerRadius(10)
//
//                    //                    Picker(selection: self.$pushupsEntered, label:
//                    //                        Text("")
//                    //                        , content: {
//                    //                            ForEach(1 ..< 26) { num in
//                    //                                Text("\(num)").tag(num)
//                    //                            }
//                    //                    })
//                    TextField("", text: self.$pushupsEntered)
//                        .frame(height: 50)
//
//                        .background(Color(#colorLiteral(red: 0.7474709153, green: 0.821385324, blue: 0.8763356805, alpha: 1)))
//                        .cornerRadius(10)
//                        .multilineTextAlignment(.center)
//                        .frame(maxWidth: 70)
//                    Button(action: {
//                        var num = (self.pushupsEntered as NSString).doubleValue
//                        var num2 = self.value
//                        self.value -= num
//                        self.allVals.first!.sitUps = self.value
//                        do {
//                            try self.moc.save()
//                        } catch {
//                            return
//                        }
//
//                    }) {
//
//                        Image(systemName: "minus")
//                            .foregroundColor(.black)
//
//                    }
//                    .frame(width: 70, height: 40)
//                    .background(Color(.white).opacity(0.6))
//                    .cornerRadius(10)
//                }
//            }
//        }
//    }
//}
//
