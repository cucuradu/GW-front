import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

/// Interactive chart with zoom, pan, and touch interactions
class InteractiveChart extends StatefulWidget {
  final List<ChartDataPoint> data;
  final String title;
  final Color primaryColor;
  final Color? secondaryColor;
  final bool showSecondaryLine;
  final Function(ChartDataPoint)? onPointTap;

  const InteractiveChart({
    Key? key,
    required this.data,
    required this.title,
    this.primaryColor = const Color(0xFF8EAC50),
    this.secondaryColor,
    this.showSecondaryLine = false,
    this.onPointTap,
  }) : super(key: key);

  @override
  State<InteractiveChart> createState() => _InteractiveChartState();
}

class _InteractiveChartState extends State<InteractiveChart> {
  int? touchedIndex;
  double _minX = 0;
  double _maxX = 7;

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return Center(
        child: Text(
          'No data available',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Padding(
          padding: EdgeInsets.only(bottom: 15),
          child: Text(
            widget.title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
        ),

        // Chart
        Expanded(
          child: GestureDetector(
            onScaleUpdate: (details) {
              // Handle zoom and pan
              if (details.scale != 1.0) {
                setState(() {
                  final range = _maxX - _minX;
                  final newRange = range / details.scale;
                  final center = (_maxX + _minX) / 2;

                  _minX =
                      (center - newRange / 2).clamp(0, widget.data.length - 1);
                  _maxX = (center + newRange / 2)
                      .clamp(_minX + 1, widget.data.length.toDouble());
                });
              }
            },
            child: LineChart(
              LineChartData(
                minX: _minX,
                maxX: _maxX,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 20,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.2),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 20,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < widget.data.length) {
                          return Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Text(
                              widget.data[index].label,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 10,
                              ),
                            ),
                          );
                        }
                        return Text('');
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchCallback: (event, response) {
                    if (response?.lineBarSpots != null &&
                        response!.lineBarSpots!.isNotEmpty) {
                      setState(() {
                        touchedIndex = response.lineBarSpots!.first.spotIndex;
                      });

                      if (widget.onPointTap != null) {
                        final spot = response.lineBarSpots!.first;
                        final index = spot.spotIndex;
                        if (index < widget.data.length) {
                          widget.onPointTap!(widget.data[index]);
                        }
                      }
                    } else {
                      setState(() {
                        touchedIndex = null;
                      });
                    }
                  },
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: widget.primaryColor.withOpacity(0.9),
                    tooltipRoundedRadius: 8,
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        final index = spot.spotIndex;
                        if (index >= widget.data.length) return null;

                        final point = widget.data[index];
                        return LineTooltipItem(
                          '${point.label}\n${point.primaryValue.toStringAsFixed(1)}',
                          TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
                lineBarsData: [
                  // Primary line
                  LineChartBarData(
                    spots: widget.data.asMap().entries.map((e) {
                      return FlSpot(e.key.toDouble(), e.value.primaryValue);
                    }).toList(),
                    isCurved: true,
                    color: widget.primaryColor,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: touchedIndex == index ? 6 : 4,
                          color: Colors.white,
                          strokeWidth: 2,
                          strokeColor: widget.primaryColor,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          widget.primaryColor.withOpacity(0.3),
                          widget.primaryColor.withOpacity(0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),

                  // Secondary line (if enabled)
                  if (widget.showSecondaryLine && widget.secondaryColor != null)
                    LineChartBarData(
                      spots: widget.data.asMap().entries.map((e) {
                        return FlSpot(
                            e.key.toDouble(), e.value.secondaryValue ?? 0);
                      }).toList(),
                      isCurved: true,
                      color: widget.secondaryColor,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: false),
                    ),
                ],
              ),
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            ),
          ),
        ),

        // Legend
        if (widget.showSecondaryLine && widget.secondaryColor != null)
          Padding(
            padding: EdgeInsets.only(top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem('Primary', widget.primaryColor),
                SizedBox(width: 20),
                _buildLegendItem('Secondary', widget.secondaryColor!),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

/// Data point for interactive chart
class ChartDataPoint {
  final String label;
  final double primaryValue;
  final double? secondaryValue;
  final DateTime? timestamp;
  final Map<String, dynamic>? metadata;

  ChartDataPoint({
    required this.label,
    required this.primaryValue,
    this.secondaryValue,
    this.timestamp,
    this.metadata,
  });
}

/// Time range selector widget
class TimeRangeSelector extends StatelessWidget {
  final TimeRange selectedRange;
  final Function(TimeRange) onRangeChanged;

  const TimeRangeSelector({
    Key? key,
    required this.selectedRange,
    required this.onRangeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: TimeRange.values.map((range) {
          final isSelected = range == selectedRange;
          return GestureDetector(
            onTap: () => onRangeChanged(range),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? Color(0xFF8EAC50) : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? Color(0xFF8EAC50) : Colors.grey[300]!,
                ),
              ),
              child: Text(
                range.label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey[700],
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

enum TimeRange {
  day24h,
  week7d,
  month30d,
  custom,
}

extension TimeRangeExtension on TimeRange {
  String get label {
    switch (this) {
      case TimeRange.day24h:
        return '24H';
      case TimeRange.week7d:
        return '7D';
      case TimeRange.month30d:
        return '30D';
      case TimeRange.custom:
        return 'Custom';
    }
  }

  int get days {
    switch (this) {
      case TimeRange.day24h:
        return 1;
      case TimeRange.week7d:
        return 7;
      case TimeRange.month30d:
        return 30;
      case TimeRange.custom:
        return 0;
    }
  }
}
