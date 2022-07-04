import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {

  final List<int> showIndexes = const [0, 1, 2, 3, 4, 5, 6];

  List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, Object>>get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),);
      double totalSum = 0;

      for (var i = 0; i < recentTransactions.length; i++){
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year){
          totalSum += recentTransactions[i].amount;
        }
      }
      print(DateFormat.E().format(weekDay));
      print(totalSum);

      return {'day': DateFormat.E().format(weekDay).substring(0,1),
        'amount':totalSum, 'idx': index
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }

  Widget build(BuildContext context) {

    final lineBarsData = [
      LineChartBarData(
        showingIndicators: showIndexes,
        spots: groupedTransactionValues.map((data){
          int i = 7 - data['idx'];
          return FlSpot(i.toDouble(), data['amount']);
        }).toList(),
        isCurved: true,
        barWidth: 4,
        dotData: FlDotData(show: false),
      ),
    ];

    final tooltipsOnBar = lineBarsData[0];

    return Container(
      padding: const EdgeInsets.all(50),
      width: double.infinity,
      height: 230,
      child: LineChart(
        LineChartData(
            showingTooltipIndicators: showIndexes.map((index) {
              return ShowingTooltipIndicators([
                LineBarSpot(tooltipsOnBar, lineBarsData.indexOf(tooltipsOnBar),
                    tooltipsOnBar.spots[index]),
              ]);
            }).toList(),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta ) {
                  int index = 7 - value.toInt();
                  final weekDay = DateTime.now().subtract(Duration(days: index));
                  final weekStr = DateFormat.E().format(weekDay).substring(0,3);
                  return Text(weekStr);
                }
                ))
            ),
            gridData: FlGridData(show: false),
            lineBarsData: lineBarsData,

          lineTouchData: LineTouchData(
            enabled: false,
            getTouchedSpotIndicator:
                (LineChartBarData barData, List<int> spotIndexes) {
              return spotIndexes.map((index) {
                return TouchedSpotIndicatorData(
                  FlLine(
                    color: Colors.transparent,
                  ),
                  FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) =>
                        FlDotCirclePainter(
                          color: Colors.orangeAccent,
                          radius: 5,
                          strokeWidth: 1,
                          strokeColor: Colors.transparent,
                        ),
                  ),
                );
              }).toList();
            },
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: Colors.transparent,
              tooltipRoundedRadius: 8,
              getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
                return lineBarsSpot.map((lineBarSpot) {
                  return LineTooltipItem(
                    lineBarSpot.y.toStringAsFixed(2),
                    const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }
}




