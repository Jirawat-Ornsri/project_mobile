import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class StaticScreen extends StatefulWidget {
  const StaticScreen({super.key});

  @override
  State<StaticScreen> createState() => _StaticScreenState();
}

class _StaticScreenState extends State<StaticScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Statistics"),
      ),
      body: Center(
        child: SizedBox(
          height: 200,
          child: MyBarGraph(
            // weeklyAmount: weeklyAmount,
          )),
      ),
    );
  }
}

class MyBarGraph extends StatelessWidget {
  const MyBarGraph({super.key});

  @override
  Widget build(BuildContext context) {
    BarData myBarData = BarData(
      sunAmount: weeklyAmount[0], 
      monAmount: weeklyAmount[1], 
      tueAmount: weeklyAmount[2], 
      wedAmount: weeklyAmount[3], 
      thuAmount: weeklyAmount[4], 
      friAmount: weeklyAmount[5], 
      satAmount: weeklyAmount[6]
    );
    myBarData.initializeBarData();

    return BarChart(
      BarChartData(
        maxY: 2000, //กำหนดค่าแกน y
        minY: 0,
        gridData: FlGridData(show: false), //ลบเส้นกริดพื้นหลังกราฟ
        borderData: FlBorderData(show: false), //ลบเส้นขอบกราฟ
        titlesData: FlTitlesData(
          // topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)), /* เอา title ด้านบน, ด้านขวาออก*/
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: xTitles)),
        ),
        barGroups: myBarData.barData
        .map(
          (data) => BarChartGroupData(
            x: data.x, 
            barRods: [
              BarChartRodData(
                toY: data.y,
                color: const Color.fromARGB(255, 127, 199, 217), //ตกแต่งกราฟ
                width: 15,
                borderRadius: BorderRadius.circular(20)
              )
            ]
          )
        )
        .toList(),
      ),
    );
  }
}


Widget xTitles (double value, TitleMeta meta){
  const style = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );


  Widget text;
  switch (value.toInt()) {
    case 0:
      text = const Text('Sun', style: style);
      break;
    case 1:
      text = const Text('Mon', style: style);
      break;
    case 2:
      text = const Text('Tue', style: style);
      break;
    case 3:
      text = const Text('Wed', style: style);
      break;
    case 4:
      text = const Text('Thu', style: style);
      break;
    case 5:
      text = const Text('Fri', style: style);
      break;
    case 6
    :
      text = const Text('Sat', style: style);
      break;
    default:
      text = const Text('', style: style);
      break;
    } 
    return SideTitleWidget(child: text, axisSide: meta.axisSide);
}


class BarGraph {
  final int x;  //แกน x
  final double y; //แกน y

  BarGraph({
    required this.x,
    required this.y,
  });
}

class BarData{
  final double sunAmount;
  final double monAmount;
  final double tueAmount;
  final double wedAmount;
  final double thuAmount;
  final double friAmount;
  final double satAmount;

  BarData({
    required this.sunAmount,
    required this.monAmount,
    required this.tueAmount,
    required this.wedAmount,
    required this.thuAmount,
    required this.friAmount,
    required this.satAmount,
  });

  List<BarGraph> barData = [];

  void initializeBarData(){
    barData = [
      BarGraph(x: 0, y: sunAmount),
      BarGraph(x: 1, y: monAmount),
      BarGraph(x: 2, y: tueAmount),
      BarGraph(x: 3, y: wedAmount),
      BarGraph(x: 4, y: thuAmount),
      BarGraph(x: 5, y: friAmount),
      BarGraph(x: 6, y: satAmount),
    ];
  }
}

List<double> weeklyAmount = [1000,600,850,910,700,1650,1970];

