import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
class BarChartSample2 extends StatefulWidget {
  const BarChartSample2({Key? key , required this.graphdata , required this.classdata}) : super(key: key);
  final Map graphdata;
  final Map classdata;
  @override
  State<StatefulWidget> createState() => BarChartSample2State();
}

class BarChartSample2State extends State<BarChartSample2> {
  // final Color leftBarColor = const Color(0xff53fdd7);
  final Color leftBarColor = Colors.purple;
  final Color rightBarColor = const Color(0xffff5182);
  final double width = 7;

  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;
  late Map graphdata;
  late Map classdata;
  List<String> titles = ["Mn", "Te", "Wd", "Tu", "Fr", "St", "Su"];
  int touchedGroupIndex = -1;
List<BarChartGroupData> items = [];
  @override
  void initState() {
    graphdata = widget.graphdata;
    classdata = widget.classdata;
    print('$graphdata $classdata');

    super.initState();

    if(graphdata['Attendance_report']==null) {
      nullassign();
    }
    else{
      additems();
    }
  }
  void nullassign(){
    titles = ["Mn", "Te", "Wd", "Tu", "Fr", "St", "Su"];
    final barGroup1 = makeGroupData(0, 0, 0);
    final barGroup2 = makeGroupData(1, 0, 0);
    final barGroup3 = makeGroupData(2, 0, 0);
    final barGroup4 = makeGroupData(3, 0, 0);
    final barGroup5 = makeGroupData(4, 0, 0);
    final barGroup6 = makeGroupData(5, 0, 0);
    final barGroup7 = makeGroupData(6, 0, 0);

    items = [
      barGroup1,
      barGroup2,
      barGroup3,
      barGroup4,
      barGroup5,
      barGroup6,
      barGroup7,
    ];
    rawBarGroups = items;

    showingBarGroups = rawBarGroups;
  }
  void additems(){
    titles.clear();
      var classreport = graphdata['Attendance_report'];
      var pastweek = DateTime.now().subtract(Duration(days: 7));
      var i =0;
      var year = pastweek.year.toString();
      var month = pastweek.month.toString();
      try {
        if (classreport[year] != null) {
          if (classreport[year][month] != null) {
            Map classdetails = classreport[year][month];
            List datakey = classdetails.keys.toList()
              ..sort();
            List datas = datakey.reversed.take(7).toList();
            datas.forEach((element) {
              double present = 0;
              double absent = 0;
              String days = DateFormat('EEEE').format(
                   DateFormat('yyyy-MM-dd').parse('$year-8-$element'));
              titles.add('$element');
              Map classperiod = classdetails[element.toString()];

              classperiod.forEach((key, value) {
                value['data'][classdata['registernumber']]['present'] == true ?
                present += 2 : absent += 2;
              });
              items.add(makeGroupData(i, present, absent));

              i++;
            });
            if (items.length >= 7) {
              rawBarGroups = items;
              showingBarGroups = rawBarGroups;
            }
            else {
              var Daylist = ['1', '2', '3', '4', '5', '6'];
              var dyle = 7 - items.length;
              for (int y = 0; y < dyle; y += 1) {
                titles.add(Daylist[y]);
                items.add(makeGroupData(i, 1, 1));
                rawBarGroups = items;
                showingBarGroups = rawBarGroups;
                i += 1;
              }
            }
          }
          else {
            nullassign();
          }
        }
        else {
          nullassign();
        }
      }
      catch(e){
        nullassign();
      }
  }
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        // color: const Color(0xFFD500F9),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[

                    const Text(
                      'Weekly Analysis',
                      style: TextStyle(color: Colors.black, fontSize: 22 , fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                     Text(
                      '${graphdata['subjectname']}',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    const SizedBox(
                      width: 100,
                    ),
                    makeTransactionsIcon(),

                  ],
                ),
              ),
              const SizedBox(
                height: 38,
              ),
              Expanded(
                child: BarChart(
                  BarChartData(
                    maxY: 20,
                    barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          tooltipBgColor: Colors.grey,
                          getTooltipItem: (_a, _b, _c, _d) => null,
                        ),
                        touchCallback: (FlTouchEvent event, response) {
                          if (response == null || response.spot == null) {
                            setState(() {
                              touchedGroupIndex = -1;
                              showingBarGroups = List.of(rawBarGroups);
                            });
                            return;
                          }

                          touchedGroupIndex =
                              response.spot!.touchedBarGroupIndex;

                          setState(() {
                            if (!event.isInterestedForInteractions) {
                              touchedGroupIndex = -1;
                              showingBarGroups = List.of(rawBarGroups);
                              return;
                            }
                            showingBarGroups = List.of(rawBarGroups);
                            if (touchedGroupIndex != -1) {
                              var sum = 0.0;
                              for (var rod
                              in showingBarGroups[touchedGroupIndex]
                                  .barRods) {
                                sum += rod.toY;
                              }
                              final avg = sum /
                                  showingBarGroups[touchedGroupIndex]
                                      .barRods
                                      .length;

                              showingBarGroups[touchedGroupIndex] =
                                  showingBarGroups[touchedGroupIndex].copyWith(
                                    barRods: showingBarGroups[touchedGroupIndex]
                                        .barRods
                                        .map((rod) {
                                      return rod.copyWith(toY: avg);
                                    }).toList(),
                                  );
                            }
                          });
                        }),
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: bottomTitles,
                          reservedSize: 42,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                          interval: 1,
                          getTitlesWidget: leftTitles,
                        ),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    barGroups: showingBarGroups,
                    gridData: FlGridData(show: false),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    if (value == 0) {
      text = '0';
    } else if (value == 4) {
      text = '2';
    }else if (value == 8) {
      text = '4';
    }else if (value == 12) {
      text = '6';
    } else if (value == 16) {
      text = '8';
    }  else if (value == 20) {
      text = '10';
    } else {
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(text, style: style),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {


    Widget text = Text(
      titles[value.toInt()],
      style: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16, //margin top
      child: text,
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(barsSpace: 4, x: x, barRods: [
      BarChartRodData(
        toY: y1,
        color: leftBarColor,
        width: width,
      ),
      BarChartRodData(
        toY: y2,
        color: rightBarColor,
        width: width,
      ),
    ]);
  }

  Widget makeTransactionsIcon() {
    const width = 4.5;
    const space = 3.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: width,
          height: 10,
          color: Colors.black.withOpacity(0.4),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.black.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 42,
          color: Colors.black.withOpacity(1),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.black.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 10,
          color: Colors.black.withOpacity(0.4),
        ),
      ],
    );
  }
}