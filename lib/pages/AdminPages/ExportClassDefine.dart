
import 'dart:io';
import 'package:attendance/pages/AppBar.dart';
import 'package:attendance/services/adminDataService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart' as Path;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';
class ExportClassDefine extends StatefulWidget {
  const ExportClassDefine({Key? key , required this.users , required this.classdata}) : super(key: key);
  final User users;
  final Map classdata;
  @override
  State<ExportClassDefine> createState() => _ExportClassDefineState();
}

class _ExportClassDefineState extends State<ExportClassDefine>{

  bool isCallGoogle=true;
  bool isload = false;
  late User user_info;
  late Map classdata;
  DateTime date = DateTime.now();
  late String dropyear = date.year.toString();
  late String dropmonth = date.month.toString();
  late List<Map<dynamic,dynamic>> Lesson;
  late Map datas;
  late Map DayList;
  late Directory directory;
  late String drivepath;
  List datalist = [];
  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  List year = [];
  @override
  void initState() {

    user_info = widget.users;
    classdata = widget.classdata;
    // print("class$classdata");
    datas = classdata['Attendance_report'];
    if(classdata['date'] != null) {
      date = DateFormat('dd-MM-yyyy').parse(classdata['date']);
      classdata['year'] = date.year.toString();
      classdata['month'] = date.month.toString();
      classdata['day'] = date.day.toString();
    }

    GetAttendance();
    if(datas == null) {
      GetClassDrop();
    }
    CreateDirectory();
    super.initState();
  }
  GetClassDrop()async{
    setState(() {
      isCallGoogle = true;
    });
    classdata = await AdminService.GetClassMap(classdata: classdata) as Map;
    setState(() {
      classdata = classdata;
      datas = classdata['Attendance_report'];
      isCallGoogle = false;
    });
  }
  GetAttendance()async{
    setState(() {
      isCallGoogle = true;
    });
    datalist.clear();
    DayList = await AdminService.GetClassMonth(classdata: classdata  , year: dropyear) as Map<dynamic , dynamic>;
    if(DayList == null){
      dropyear = year.reduce((curr, next) => curr > next? curr: next).toString();
      DayList = await AdminService.GetClassMonth(classdata: classdata  , year: dropyear) as Map<dynamic , dynamic>;
      makecards( lesson: DayList);
    }
    else {
      makecards(lesson: DayList);
    }
    setState(() {
      isCallGoogle =false;
    });
    // print('hello$DayList');


  }
  CreateDirectory()async{
    final directory = await getExternalStorageDirectory();
    print(directory?.path);
    final path = Directory("/storage/emulated/0/Documents/Attendace$dropyear");
    var status = await Permission.storage.status;
    print(status.isGranted);
    if (!status.isGranted) {
      await Permission.storage.request();
    // await Permission.manageExternalStorage.request();
    }
    print(await path.exists());
    if (await path.exists()) {
      return path.path;
    } else {
      print('path created');
      await path.create();
      return path.path;
    }
  }
  changestate({required String month}) async {
    setState(() {
      isload = !isload;
      datalist.clear();
      makecards( lesson: DayList);
    });
    String monthStr = months[int.parse(month)-1];
    Map Exceldata = classdata['Attendance_report']['$dropyear'][month];
    Map StudentsData = classdata['students'];
    List Keystu = StudentsData.keys.toList()..sort();
    List Keyscell = Exceldata.keys.toList()..sort();
    // var excel = Excel.createExcel();
    // Sheet sheetObject = excel['Sheet1'];
    // CellStyle cellStyle = CellStyle(fontFamily : getFontFamily(FontFamily.Calibri));
    // var cell = sheetObject.cell(CellIndex.indexByString("A1"));
    // cell.value = 8; // dynamic values support provided;
    // cell.cellStyle = cellStyle;
    // excel.rename('Sheet1', '${classdata['subjectname']}-Month$month');
    // // excel.delete('Sheet1');
    // // printing cell-type
    // print("CellType: "+ cell.toString() + cell.value.toString());
    ByteData data = await rootBundle.load("assets/AttendanceRegister.xlsx");
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var excel = Excel.decodeBytes(bytes);

    var cell = excel.tables['Sheet1']?.cell(CellIndex.indexByColumnRow(columnIndex: 3,rowIndex: 1));
    cell?.value = "Monthly Analysis - ${classdata['classname']}";
    cell?.cellStyle = CellStyle(horizontalAlign: HorizontalAlign.Center,bold: true);
    var cell1 = excel.tables['Sheet1']?.cell(CellIndex.indexByColumnRow(columnIndex: 3,rowIndex: 2));
    cell1?.value = "$monthStr $dropyear - ${classdata['subjectname']}";
    cell1?.cellStyle = CellStyle(horizontalAlign: HorizontalAlign.Center , bold: true);
    excel.tables['Sheet1']?.merge(CellIndex.indexByColumnRow(columnIndex: 2,rowIndex: 0), CellIndex.indexByColumnRow(columnIndex: 20,rowIndex: 0) ,customValue: "Attendance Report");
    excel.tables['Sheet1']?.merge(CellIndex.indexByColumnRow(columnIndex: 2,rowIndex: 1), CellIndex.indexByColumnRow(columnIndex: 20,rowIndex: 1),customValue: "Monthly Analysis - ${classdata['classname']}");
    excel.tables['Sheet1']?.merge(CellIndex.indexByColumnRow(columnIndex: 2,rowIndex: 2), CellIndex.indexByColumnRow(columnIndex: 20,rowIndex: 2),customValue: "$monthStr $dropyear - ${classdata['subjectname']}");
    var col = 4;
    // for column allocation
    Keyscell.forEach((element) {
      Exceldata[element].keys.forEach((period) {
      excel.tables['Sheet1']?.cell(CellIndex.indexByColumnRow(columnIndex: col,rowIndex: 3)).value = monthStr.substring(0,3);
      excel.tables['Sheet1']?.cell(CellIndex.indexByColumnRow(columnIndex: col,rowIndex: 3)).cellStyle = CellStyle(horizontalAlign: HorizontalAlign.Center , bold: true);
      excel.tables['Sheet1']?.cell(CellIndex.indexByColumnRow(columnIndex: col,rowIndex: 4)).value = int.parse(element);
      excel.tables['Sheet1']?.cell(CellIndex.indexByColumnRow(columnIndex: col,rowIndex: 4)).cellStyle = CellStyle(horizontalAlign: HorizontalAlign.Center);
      excel.tables['Sheet1']?.cell(CellIndex.indexByColumnRow(columnIndex: col,rowIndex: 5)).value = int.parse(period);
      excel.tables['Sheet1']?.cell(CellIndex.indexByColumnRow(columnIndex: col,rowIndex: 5)).cellStyle = CellStyle(horizontalAlign: HorizontalAlign.Center);
      col+=1;
      });
    });
    //for row allocation
    var row = 7;
    var i=1;
    excel.tables['Sheet1']?.cell(CellIndex.indexByColumnRow(columnIndex: col,rowIndex: 5)).value = "P|d";
    excel.tables['Sheet1']?.cell(CellIndex.indexByColumnRow(columnIndex: col,rowIndex: 5)).cellStyle = CellStyle(horizontalAlign: HorizontalAlign.Center);
    excel.tables['Sheet1']?.cell(CellIndex.indexByColumnRow(columnIndex: col+1,rowIndex: 5)).value = "W|d";
    excel.tables['Sheet1']?.cell(CellIndex.indexByColumnRow(columnIndex: col+1,rowIndex: 5)).cellStyle = CellStyle(horizontalAlign: HorizontalAlign.Center);
    excel.tables['Sheet1']?.cell(CellIndex.indexByColumnRow(columnIndex: col+2,rowIndex: 5)).value = "Per";
    excel.tables['Sheet1']?.cell(CellIndex.indexByColumnRow(columnIndex: col+2,rowIndex: 5)).cellStyle = CellStyle(horizontalAlign: HorizontalAlign.Center);
    Keystu.forEach((regno) {
    var totalDays = 0;
    var presentDays = 0;

    List studentdata = [];
    studentdata.add(i);
    studentdata.add(StudentsData[regno]['name']);
    studentdata.add(StudentsData[regno]['registernumber']);
    studentdata.add(" ");
    Keyscell.forEach((element) {
      var calculate = 0;
      var divide = 0;
      Exceldata[element].keys.forEach((period) {
        if(Exceldata[element][period]['data']==null) {
          studentdata.add('A');
          calculate += 0;
          divide += 1;
        }
         else if (Exceldata[element][period]['data'][regno] == null) {
            studentdata.add('A');
            calculate += 0;
            divide += 1;
          } else {
            studentdata.add(
                Exceldata[element][period]['data'][regno]['present']
                    ? 'P'
                    : 'A');
            calculate +=
            Exceldata[element][period]['data'][regno]['present'] ? 1 : 0;
            divide += 1;
          }


      });
            presentDays += (calculate/divide)>=(0.5)?1:0;
            totalDays +=1;
    });
    studentdata.add(presentDays);
    studentdata.add(totalDays);
    studentdata.add((presentDays/totalDays)*100);

    excel.tables['Sheet1']?.insertRowIterables(studentdata, row);
    row+=1;
    i+=1;
    });
    var ex = await excel.encode();

    var devicepath =  '/storage/emulated/0/Documents/Attendace$dropyear/${classdata['subjectname']}-$monthStr.xlsx';
    var dir = File(devicepath);
    var direc = '/storage/emulated/0/Documents/Attendace$dropyear/${classdata['subjectname']}-$monthStr.xlsx';
    print(await dir.exists());
    if(await dir.exists()){
        var val = await Overrite();
        if(val){
          File(dir.path)
            ..createSync(recursive: true)
            ..writeAsBytesSync(ex!);
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('File Overrite at DeviceStorage/Documents/Attendance$dropyear')));
        }
        else{
          var append = 1;
          for(append; append<10000 ; append++ ){
            devicepath = '/storage/emulated/0/Documents/Attendace$dropyear/${classdata['subjectname']}-$monthStr ($append).xlsx';
            dir = File(devicepath);
            if(await dir.exists()){
              continue;
            }
            else{
              File(dir.path)
                ..createSync(recursive: true)
                ..writeAsBytesSync(ex!);
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('File Created Attendance$dropyear/${classdata['subjectname']}-$monthStr ($append).xlsx')));
              break;
            }
          }

        }
    }
    else{
      try {
        File(direc)
          ..createSync(recursive: true)
          ..writeAsBytesSync(ex!);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(
            'File Created at DeviceStorage/Documents/Attendance$dropyear')));
      }
      catch(e){
        var append = 1;
        for(append; append<10000 ; append++ ){
          devicepath = '/storage/emulated/0/Documents/Attendace$dropyear/${classdata['subjectname']}-$monthStr ($append).xlsx';
          dir = File(devicepath);
          if(await dir.exists()){
            continue;
          }
          else{
            try {
              File(dir.path)
                ..createSync(recursive: true)
                ..writeAsBytesSync(ex!);
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(
                  'File Created Attendance$dropyear/${classdata['subjectname']}-$monthStr ($append).xlsx')));
            }
            catch(e){
              append+=1;
              continue;
            }
            break;
          }
        }
      }

    }
    setState(() {
      isload = !isload;
      datalist.clear();
      makecards( lesson: DayList);
    });

  }

  List<DropdownMenuItem<String>> get yeardropdownItems{
    if(datas!=null) {
      List<DropdownMenuItem<String>> yearit = [];
      datas.forEach((key, value) {
        year.add(int.parse(key));
        yearit.add(DropdownMenuItem(child: Text(key.toString(),
          style: const TextStyle(
              fontSize: 18,
              color: Colors.purple
          ),
        ), value: key.toString()));
      });
      List<DropdownMenuItem<String>> ymenuItems = yearit.toList();
      print(ymenuItems);
      return ymenuItems;
    }else{return [];}
  }
  Future<bool> Overrite()async{
    bool overrite = false;
    await showDialog(
        context: context, builder: (context) {
      return AlertDialog(
        title: const Text('File already Exists..!'),
        actions: [
          RaisedButton(
              elevation: 2.0,
              color: Colors.purple,
              onPressed: () {
                overrite = true;
                Navigator.pop(context);
              },
              child: const Text('Overrite' , style: TextStyle(color: Colors.white),)),
          TextButton(
            onPressed: (){
              overrite = false;
              Navigator.pop(context);
            },
            child: const Text('New', style: TextStyle(color: Colors.purple),) ,)
        ],
      );
    });
    return overrite;
  }
  ListTile makeListTile({required String listdata}) => ListTile(
    contentPadding:
    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
    leading: Container(
        padding: const EdgeInsets.only(right: 12.0),
        decoration: const BoxDecoration(
            border: Border(
                right: BorderSide(width: 1.0, color: Colors.black26))),
        // child: Icon(Icons, color: Colors.black),

        child:const FaIcon(FontAwesomeIcons.solidFileExcel, color: Colors.green,)

    ),
    title: Text(
      'Month $listdata',
      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    ),


    subtitle: Row(
      children: <Widget>[
        Expanded(
          flex: 4,
          child: Padding(
              padding: const EdgeInsets.only(left: 0.0),
              child: isload?SpinKitWave(color: Colors.green,size: 15,):Text('Export as Excel ',
                  style: const TextStyle(color: Colors.black))),
        )
      ],
    ),
    trailing:
    InkWell(
        onTap: ()async{
          await changestate(month: listdata);

        },
        child: const Icon(Icons.download, color: Colors.black, size: 30.0)
    ),
    onTap: () {
      // print(classdata['Attendance_report']['$dropyear'][listdata]);
      Map st = classdata['Attendance_report']['$dropyear'][listdata];
      for (final String key in st.keys) {
        print("$key : ${st[key]}");
      }
      print(st.keys.toList()..sort());
      print(months[int.parse(listdata)-1]);
       },
  );
  void makecards({required Map<dynamic,dynamic> lesson}){

    lesson.forEach((key, value) {

      datalist.add(makeCard(lesson: key));
    });
  }
  Card makeCard({required String lesson}) {

    return Card(
      elevation: 8.0,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: makeListTile(  listdata: lesson),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBars(),
      body: datas!=null?SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text('Filters',
                        style: TextStyle(
                          color: Colors.purple,
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      DropdownButton(
                        items: yeardropdownItems,
                        onChanged: (value) {
                          setState(() {
                            dropyear = value.toString();
                            GetAttendance();
                          });
                        },
                        value: dropyear,
                      ),
                      IconButton(
                        onPressed: () async {
                          setState(() {
                            isCallGoogle = true;
                          });
                          classdata = await AdminService.GetClassMap(classdata: classdata) as Map;
                          print(classdata);
                          setState(() {
                            classdata = classdata;
                            datas = classdata['Attendance_report'];
                            isCallGoogle = false;
                            GetAttendance();
                          });
                        },
                        icon: const Icon(Icons.autorenew),
                        iconSize: 30.0,
                        color: Colors.purple,
                      )
                    ],
                  ),
                  isCallGoogle?
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
                    child: SpinKitWave(
                      color: Colors.purple,
                      size: 50,
                    ),

                  ):
                  Container(
                    height: MediaQuery.of(context).size.height * 0.82,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: datalist.length,
                        itemBuilder: (context, index) {
                          // return makeCard(DayList[index]); //{01: {01: {period: 01, session: false}}}
                          return datalist[index];
                        }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ):SizedBox(),
    );
  }

}

