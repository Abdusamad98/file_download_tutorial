import 'package:flutter/material.dart';
import 'package:flutter_charts/flutter_charts.dart';

class ChartExampleScreen extends StatefulWidget {
  const ChartExampleScreen({Key? key}) : super(key: key);

  @override
  State<ChartExampleScreen> createState() => _ChartExampleScreenState();
}

class _ChartExampleScreenState extends State<ChartExampleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chart Example"),
      ),
      body: SizedBox(height: 300, width: double.infinity, child: chartToRun()),
    );
  }

  Widget chartToRun() {
    LabelLayoutStrategy? xContainerLabelLayoutStrategy;
    ChartData chartData;
    ChartOptions chartOptions = const ChartOptions();
    // Example shows a mix of positive and negative data values.
    chartData = ChartData(
      dataRowsColors: [Colors.red,Colors.blue,Colors.black45,Colors.pink],
      dataRows: const [
        [2000.0, 1800.0, 2200.0, 2300.0, 1700.0, 2390.0,],
        [1100.0, 1000.0, 1200.0, 800.0, 700.0, 800.0],
        [0.0, 100.0, -200.0, 150.0, -100.0, -150.0],
        [-800.0, -400.0, -300.0, -400.0, -200.0, 250.0],
      ],
      xUserLabels: const ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
      dataRowsLegends: const [
        'Big Corp',
        'Medium Corp',
        'Print Shop',
        'Bar',
      ],
      chartOptions: chartOptions,
    );
    var lineChartContainer = LineChartTopContainer(
      chartData: chartData,
      xContainerLabelLayoutStrategy: xContainerLabelLayoutStrategy,
    );


    var lineChart = LineChart(
      painter: LineChartPainter(
        lineChartContainer: lineChartContainer,
      ),
    );
    return lineChart;
  }
}
