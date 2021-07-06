import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/gestures.dart';
import 'dart:math';
import 'package:me_flutting/main.dart';

class UsageInfoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UsageInfoPageState();
}

class _UsageInfoPageState extends State<UsageInfoPage> {
  static const _monthLabels = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  static const _dayWeekLabels = ['Mn', 'Te', 'Wd', 'Tu', 'Fr', 'St', 'Sn'];

  @override
  Widget build(BuildContext context) {
    List<List<double>> zeroedSample(int len, [double zero = 0]) => () sync* {
          for (int i = 0; i < len; i++) yield <double>[zero, zero];
        }()
            .toList();

    final futBuilder = ([bool isWeekly = false]) =>
        FutureBuilder<List<List<double>>>(
            future: isWeekly ? _initS1() : _initS2(),
            builder: (_, snap) => _makeChart(
                snap.hasData ? snap.data : zeroedSample(isWeekly ? 7 : 12),
                isWeekly ? 4 : 9,
                isWeekly ? _dayWeekLabels : _monthLabels));

    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: TabBar(
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              tabs: [Tab(text: 'Weekly'), Tab(text: 'Monthly')]),
          body: TabBarView(children: [futBuilder(true), futBuilder()])),
    );
  }

  Future<List<List<double>>> _fillCounts(
      DateTime start, int rangeCoeff, int iterLen) async {
    var lsToReturn = <List<double>>[];
    final stEpo = start.millisecondsSinceEpoch;
    for (int i = 0; i < iterLen; i++) {
      final drange = rangeCoeff * Duration(days: 1).inMilliseconds;
      final re = await storage.messageTable.countMessages(
          stEpo + i * drange, stEpo + (i + 1) * drange, meSession);
      lsToReturn.add([re[0], re[1]]);
    }
    return lsToReturn;
  }

  Future<List<List<double>>> _initS1() async {
    final no = DateTime.now();
    return _fillCounts(no.subtract(Duration(days: no.weekday)), 1, no.weekday);
  }

  Future<List<List<double>>> _initS2() async {
    final no = DateTime.now();
    return _fillCounts(DateTime(no.year, 1, 1, 0, 0), 30, no.month);
  }

  Widget _makeChart(
          List<List<double>> _data, int topSpace, List<String> labelSource) =>
      Column(children: [
        _barChart(_data.map((m) => m.reduce(max)).reduce(max) + topSpace,
            _titleData(labelSource), _barGrps(_data).toList()),
        Padding(padding: EdgeInsets.symmetric(vertical: 4)),
        Row(children: [
          Container(width: 20, height: 20, color: Colors.lightBlueAccent),
          Text(' : messages sent    '),
          Container(width: 20, height: 20, color: Colors.yellowAccent),
          Text(' : messages received')
        ]),
      ]);

  Iterable<BarChartGroupData> _barGrps(List<List<double>> yAxisVals) sync* {
    _(int _x, double _y1, _y2) => BarChartGroupData(
          x: _x,
          barRods: [
            BarChartRodData(
                y: _y1, colors: [Colors.lightBlueAccent, Colors.greenAccent]),
            BarChartRodData(
                y: _y2, colors: [Colors.yellowAccent, Colors.redAccent])
          ],
          //showingTooltipIndicators: [0, 1],
        );
    for (int i = 0; i < yAxisVals.length; i++)
      yield _(i, yAxisVals[i][0], yAxisVals[i][1]);
  }

  Widget _barChart(
          double maxYValue, FlTitlesData td, List<BarChartGroupData> bg) =>
      AspectRatio(
          aspectRatio: 1.7,
          child: Card(
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            color: const Color(0xff2c4260),
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxYValue,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colors.transparent,
                      tooltipPadding: const EdgeInsets.all(0),
                      tooltipMargin: 8,
                      getTooltipItem: _toolt),
                ),
                titlesData: td,
                borderData: FlBorderData(
                  show: false,
                ),
                barGroups: bg,
              ),
            ),
          ));

  FlTitlesData _titleData(List<String> labelList) => FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
              color: Color(0xff7589a2),
              fontWeight: FontWeight.bold,
              fontSize: 14),
          margin: 20,
          getTitles: (double value) => labelList[value as int],
        ),
        leftTitles: SideTitles(showTitles: false),
      );

  BarTooltipItem _toolt(
    BarChartGroupData group,
    int groupIndex,
    BarChartRodData rod,
    int rodIndex,
  ) {
    return BarTooltipItem(
      rod.y.toString(),
      TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
