import 'package:flutter/material.dart';

/// Beautiful error state widget for handling various error scenarios
class ErrorStateWidget extends StatelessWidget {
  final ErrorType errorType;
  final String? customMessage;
  final VoidCallback? onRetry;

  const ErrorStateWidget({
    Key? key,
    required this.errorType,
    this.customMessage,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final errorInfo = _getErrorInfo();

    return Center(
      child: Padding(
        padding: EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Container(
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: errorInfo.color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                errorInfo.icon,
                size: 80,
                color: errorInfo.color,
              ),
            ),
            SizedBox(height: 30),

            // Title
            Text(
              errorInfo.title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.tertiary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 15),

            // Message
            Text(
              customMessage ?? errorInfo.message,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),

            // Retry button
            if (onRetry != null)
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: Icon(Icons.refresh, color: Colors.white),
                label: Text(
                  'Try Again',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF8EAC50),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
              ),
          ],
        ),
      ),
    );
  }

  _ErrorInfo _getErrorInfo() {
    switch (errorType) {
      case ErrorType.noInternet:
        return _ErrorInfo(
          icon: Icons.wifi_off_rounded,
          title: 'No Internet Connection',
          message: 'Please check your internet connection and try again.',
          color: Colors.orange,
        );

      case ErrorType.serverError:
        return _ErrorInfo(
          icon: Icons.cloud_off_rounded,
          title: 'Server Error',
          message:
              'We\'re having trouble connecting to our servers. Please try again later.',
          color: Colors.red,
        );

      case ErrorType.noData:
        return _ErrorInfo(
          icon: Icons.inbox_rounded,
          title: 'No Data Available',
          message:
              'There\'s no data to display yet. Add some sensors to get started!',
          color: Colors.blue,
        );

      case ErrorType.timeout:
        return _ErrorInfo(
          icon: Icons.access_time_rounded,
          title: 'Request Timeout',
          message:
              'The request took too long to complete. Please check your connection.',
          color: Colors.deepOrange,
        );

      case ErrorType.unauthorized:
        return _ErrorInfo(
          icon: Icons.lock_outline_rounded,
          title: 'Access Denied',
          message: 'You don\'t have permission to access this resource.',
          color: Colors.purple,
        );

      case ErrorType.notFound:
        return _ErrorInfo(
          icon: Icons.search_off_rounded,
          title: 'Not Found',
          message: 'The resource you\'re looking for doesn\'t exist.',
          color: Colors.grey,
        );

      case ErrorType.unknown:
      default:
        return _ErrorInfo(
          icon: Icons.error_outline_rounded,
          title: 'Something Went Wrong',
          message: 'An unexpected error occurred. Please try again.',
          color: Colors.red,
        );
    }
  }
}

class _ErrorInfo {
  final IconData icon;
  final String title;
  final String message;
  final Color color;

  _ErrorInfo({
    required this.icon,
    required this.title,
    required this.message,
    required this.color,
  });
}

enum ErrorType {
  noInternet,
  serverError,
  noData,
  timeout,
  unauthorized,
  notFound,
  unknown,
}

/// Compact error banner for inline error messages
class ErrorBanner extends StatelessWidget {
  final String message;
  final VoidCallback? onDismiss;

  const ErrorBanner({
    Key? key,
    required this.message,
    this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 24),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: Colors.red[900],
                fontSize: 14,
              ),
            ),
          ),
          if (onDismiss != null)
            IconButton(
              icon: Icon(Icons.close, color: Colors.red, size: 20),
              onPressed: onDismiss,
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
            ),
        ],
      ),
    );
  }
}
