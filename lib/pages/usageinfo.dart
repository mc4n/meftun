import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:math';

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

  @override
  Widget build(BuildContext context) {
    // --------------------
    final firstDSet = <List<double>>[
      [1, 4],
      [3, 6],
      [5, 2],
      [4, 2],
      [2, 1],
      [0, 0],
      [0, 0]
    ];
    final secondDSet = <List<double>>[
      [5, 3],
      [13, 7],
      [55, 32],
      [63, 76],
      [65, 23],
      [33, 56],
      [0, 0],
      [0, 0],
      [0, 0],
      [0, 0],
      [0, 0],
      [0, 0]
    ];
    // --------------------
    return Column(children: [
      Row(children: [
        Container(width: 20, height: 20, color: Colors.yellowAccent),
        Text(' : messages received    '),
        Container(width: 20, height: 20, color: Colors.lightBlueAccent),
        Text(' : messages sent')
      ]),
      Padding(padding: EdgeInsets.symmetric(vertical: 4)),
      Text('Weekly:'),
      Container(
          child: _barChart(firstDSet.map((m) => m.reduce(max)).reduce(max) + 10,
              _titleData(_dayWeekLabels), _barGrps(firstDSet).toList())),
      Padding(padding: EdgeInsets.symmetric(vertical: 5)),
      Text('Monthly:'),
      Container(
          child: _barChart(
              secondDSet.map((m) => m.reduce(max)).reduce(max) + 10,
              _titleData(_monthLabels),
              _barGrps(secondDSet).toList()))
    ]);
  }
}
