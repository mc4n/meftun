import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/gestures.dart';
import 'dart:math';
import '../main.dart';

class UsageInfoPage extends StatelessWidget {
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

  Future<List<List<double>>> _initS1() async {
    var lsToReturn = <List<double>>[];
    final no = DateTime.now();
    final weekd = no.weekday;
    final start = no.subtract(Duration(days: weekd));
    for (int i = 0; i < _dayWeekLabels.length; i++) {
      final drange = Duration(days: 1).inMilliseconds;
      final stEpo = start.millisecondsSinceEpoch;
      final re = await messageTable.countMessages(
          stEpo + i * drange, stEpo + (i + 1) * drange, meSession);
      lsToReturn.add([re[0], re[1]]);
    }
    return lsToReturn;
  }

  Future<List<List<double>>> _initS2() async {
    var lsToReturn = <List<double>>[];
    final start = DateTime(DateTime.now().year, 1, 1, 0, 0);
    for (int i = 0; i < _monthLabels.length; i++) {
      final mrange = 30 * Duration(days: 1).inMilliseconds;
      final stEpo = start.millisecondsSinceEpoch;
      final re = await messageTable.countMessages(
          stEpo + i * mrange, stEpo + (i + 1) * mrange, meSession);
      lsToReturn.add([re[0], re[1]]);
    }
    return lsToReturn;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(children: [
        Container(width: 20, height: 20, color: Colors.lightBlueAccent),
        Text(' : messages sent    '),
        Container(width: 20, height: 20, color: Colors.yellowAccent),
        Text(' : messages received')
      ]),
      Padding(padding: EdgeInsets.symmetric(vertical: 4)),
      Text('Weekly:'),
      Container(
          child: FutureBuilder<List<List<double>>>(
        future: _initS1(),
        builder: (bc, snap) {
          if (snap.hasData)
            return _barChart(
                snap.data.map((m) => m.reduce(max)).reduce(max) + 4,
                _titleData(_dayWeekLabels),
                _barGrps(snap.data).toList());
          else
            return Row();
        },
      )),
      Padding(padding: EdgeInsets.symmetric(vertical: 5)),
      Text('Monthly:'),
      Container(
          child: FutureBuilder<List<List<double>>>(
        future: _initS2(),
        builder: (bc, snap) {
          if (snap.hasData)
            return _barChart(
                snap.data.map((m) => m.reduce(max)).reduce(max) + 12,
                _titleData(_monthLabels),
                _barGrps(snap.data).toList());
          else
            return Row();
        },
      ))
    ]);
  }

  Iterable<BarChartGroupData> _barGrps(List<List<double>> yAxisVals) sync* {
    _(int _x, double _y1, _y2) => BarChartGroupData(
          x: _x,
          barRods: [
            BarChartRodData(
                y: _y1, colors: [Colors.lightBlueAccent, Colors.greenAccent]),
            BarChartRodData(
                y: _y2, colors: [Colors.yellowAccent, Colors.redAccent])
          ],
          showingTooltipIndicators: [0, 1],
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          color: const Color(0xff2c4260),
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: maxYValue,
              barTouchData: BarTouchData(
                enabled: false,
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
        ),
      );

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
