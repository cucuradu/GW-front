import 'package:intl/intl.dart';

/// ML-based prediction service for smart agriculture features
class MLPredictionService {
  /// Predict watering schedule for next 7 days
  /// 
  /// Uses simple linear regression based on:
  /// - Historical soil moisture trends
  /// - Weather forecast (rain probability, temperature)
  /// - Plant type water requirements
  Future<List<WateringPrediction>> predictWateringSchedule({
    required List<SensorReading> historicalData,
    required List<WeatherForecast> weatherForecast,
    required String plantType,
  }) async {
    final predictions = <WateringPrediction>[];
    final now = DateTime.now();

    // Calculate average moisture depletion rate
    final depletionRate = _calculateDepletionRate(historicalData);
    
    // Plant-specific thresholds (can be expanded)
    final wateringThreshold = _getWateringThreshold(plantType);
    
    for (int day = 0; day < 7; day++) {
      final date = now.add(Duration(days: day));
      final weather = day < weatherForecast.length ? weatherForecast[day] : null;
      
      // Predict moisture level
      double predictedMoisture = historicalData.isNotEmpty
          ? historicalData.last.moistureLevel - (depletionRate * day)
          : 50.0;
      
      // Adjust for rain
      if (weather != null && weather.rainProbability > 50) {
        predictedMoisture += 20; // Rain adds moisture
      }
      
      // Adjust for temperature
      if (weather != null && weather.maxTemperature > 30) {
        predictedMoisture -= 5; // Heat increases evaporation
      }
      
      final needsWatering = predictedMoisture < wateringThreshold;
      final confidence = _calculateConfidence(historicalData.length, day);
      
      predictions.add(WateringPrediction(
        date: date,
        needsWatering: needsWatering,
        predictedMoistureLevel: predictedMoisture.clamp(0, 100),
        confidence: confidence,
        reason: _generateReason(needsWatering, weather, predictedMoisture),
      ));
    }
    
    return predictions;
  }

  /// Calculate plant health score (0-100)
  /// 
  /// Considers:
  /// - Soil moisture (optimal range)
  /// - Temperature (optimal range)
  /// - Nutrient levels
  double calculatePlantHealthScore({
    required double moistureLevel,
    required double temperature,
    required double nitrogenLevel,
    required double phosphorusLevel,
    required double potassiumLevel,
    required String plantType,
  }) {
    double score = 100.0;
    
    // Moisture score (40% weight)
    final optimalMoisture = _getOptimalMoisture(plantType);
    final moistureDeviation = (moistureLevel - optimalMoisture).abs();
    score -= (moistureDeviation / optimalMoisture) * 40;
    
    // Temperature score (30% weight)
    final optimalTemp = _getOptimalTemperature(plantType);
    final tempDeviation = (temperature - optimalTemp).abs();
    score -= (tempDeviation / optimalTemp) * 30;
    
    // Nutrient score (30% weight)
    final nutrientScore = (nitrogenLevel + phosphorusLevel + potassiumLevel) / 3;
    score -= (100 - nutrientScore) * 0.3;
    
    return score.clamp(0, 100);
  }

  /// Generate smart recommendations based on sensor data and weather
  List<SmartRecommendation> generateRecommendations({
    required Map<String, dynamic> sensorData,
    required WeatherForecast? todayWeather,
  }) {
    final recommendations = <SmartRecommendation>[];
    
    final moisture = sensorData['moisture'] as double? ?? 50.0;
    final temp = sensorData['temperature'] as double? ?? 25.0;
    final nitrogen = sensorData['nitrogen'] as double? ?? 70.0;
    
    // Low moisture alert
    if (moisture < 30) {
      recommendations.add(SmartRecommendation(
        title: 'Water Needed Soon',
        message: 'Soil moisture is low (${moisture.toStringAsFixed(1)}%). Water within 2 hours for best results.',
        priority: RecommendationPriority.high,
        icon: '💧',
        action: 'Water Now',
      ));
    }
    
    // Rain incoming
    if (todayWeather != null && todayWeather.rainProbability > 70) {
      recommendations.add(SmartRecommendation(
        title: 'Rain Expected',
        message: '${todayWeather.rainProbability}% chance of rain today. Consider delaying watering.',
        priority: RecommendationPriority.medium,
        icon: '🌧️',
      ));
    }
    
    // Heat wave warning
    if (temp > 35) {
      recommendations.add(SmartRecommendation(
        title: 'Heat Stress Alert',
        message: 'Temperature is ${temp.toStringAsFixed(1)}°C. Increase watering frequency and provide shade.',
        priority: RecommendationPriority.high,
        icon: '🌡️',
        action: 'View Tips',
      ));
    }
    
    // Nutrient low
    if (nitrogen < 50) {
      recommendations.add(SmartRecommendation(
        title: 'Low Nitrogen Levels',
        message: 'Nitrogen at ${nitrogen.toStringAsFixed(1)}%. Consider adding fertilizer.',
        priority: RecommendationPriority.medium,
        icon: '🌱',
        action: 'Add Fertilizer',
      ));
    }
    
    // Optimal conditions
    if (moisture > 60 && moisture < 80 && temp > 20 && temp < 30) {
      recommendations.add(SmartRecommendation(
        title: 'Perfect Growing Conditions',
        message: 'Your plants are thriving! Maintain current care routine.',
        priority: RecommendationPriority.low,
        icon: '✨',
      ));
    }
    
    return recommendations;
  }

  // Private helper methods
  
  double _calculateDepletionRate(List<SensorReading> data) {
    if (data.length < 2) return 5.0; // Default 5% per day
    
    // Simple linear regression
    double sumDays = 0, sumMoisture = 0, sumDaysMoisture = 0, sumDaysSquared = 0;
    
    for (int i = 0; i < data.length; i++) {
      sumDays += i;
      sumMoisture += data[i].moistureLevel;
      sumDaysMoisture += i * data[i].moistureLevel;
      sumDaysSquared += i * i;
    }
    
    final n = data.length;
    final slope = (n * sumDaysMoisture - sumDays * sumMoisture) /
        (n * sumDaysSquared - sumDays * sumDays);
    
    return slope.abs().clamp(1.0, 15.0); // Cap at reasonable values
  }

  double _getWateringThreshold(String plantType) {
    switch (plantType.toLowerCase()) {
      case 'tomato':
      case 'tomatoes':
        return 40.0;
      case 'lettuce':
      case 'leafy greens':
        return 50.0;
      case 'cactus':
      case 'succulent':
        return 20.0;
      default:
        return 35.0;
    }
  }

  double _getOptimalMoisture(String plantType) {
    switch (plantType.toLowerCase()) {
      case 'tomato':
      case 'tomatoes':
        return 65.0;
      case 'lettuce':
        return 75.0;
      case 'cactus':
        return 30.0;
      default:
        return 60.0;
    }
  }

  double _getOptimalTemperature(String plantType) {
    switch (plantType.toLowerCase()) {
      case 'tomato':
        return 25.0;
      case 'lettuce':
        return 18.0;
      case 'cactus':
        return 30.0;
      default:
        return 23.0;
    }
  }

  double _calculateConfidence(int dataPoints, int daysAhead) {
    // Confidence decreases with fewer data points and more days ahead
    double baseConfidence = (dataPoints / 30).clamp(0.3, 1.0);
    double timeDecay = 1.0 - (daysAhead * 0.1);
    return (baseConfidence * timeDecay * 100).clamp(0, 100);
  }

  String _generateReason(bool needsWatering, WeatherForecast? weather, double moisture) {
    if (!needsWatering) {
      if (weather != null && weather.rainProbability > 50) {
        return 'Rain expected, moisture sufficient';
      }
      return 'Soil moisture optimal';
    }
    
    if (moisture < 20) {
      return 'Critical: Very low soil moisture';
    } else if (moisture < 35) {
      return 'Low moisture detected';
    }
    
    return 'Scheduled watering';
  }
}

// Data models

class SensorReading {
  final DateTime timestamp;
  final double moistureLevel;
  final double temperature;

  SensorReading({
    required this.timestamp,
    required this.moistureLevel,
    required this.temperature,
  });
}

class WeatherForecast {
  final DateTime date;
  final double maxTemperature;
  final double minTemperature;
  final int rainProbability;

  WeatherForecast({
    required this.date,
    required this.maxTemperature,
    required this.minTemperature,
    required this.rainProbability,
  });
}

class WateringPrediction {
  final DateTime date;
  final bool needsWatering;
  final double predictedMoistureLevel;
  final double confidence;
  final String reason;

  WateringPrediction({
    required this.date,
    required this.needsWatering,
    required this.predictedMoistureLevel,
    required this.confidence,
    required this.reason,
  });

  String get formattedDate => DateFormat('EEE, MMM d').format(date);
}

class SmartRecommendation {
  final String title;
  final String message;
  final RecommendationPriority priority;
  final String icon;
  final String? action;

  SmartRecommendation({
    required this.title,
    required this.message,
    required this.priority,
    required this.icon,
    this.action,
  });
}

enum RecommendationPriority {
  low,
  medium,
  high,
}
