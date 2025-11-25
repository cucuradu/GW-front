import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// Smart refresh wrapper with custom styling
class SmartRefreshWrapper extends StatelessWidget {
  final RefreshController controller;
  final Future<void> Function() onRefresh;
  final Widget child;
  final bool enablePullDown;
  final bool enablePullUp;
  final Future<void> Function()? onLoading;

  const SmartRefreshWrapper({
    Key? key,
    required this.controller,
    required this.onRefresh,
    required this.child,
    this.enablePullDown = true,
    this.enablePullUp = false,
    this.onLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: controller,
      enablePullDown: enablePullDown,
      enablePullUp: enablePullUp,
      onRefresh: () async {
        await onRefresh();
        controller.refreshCompleted();
      },
      onLoading: onLoading != null
          ? () async {
              await onLoading!();
              controller.loadComplete();
            }
          : null,
      header: CustomHeader(
        builder: (context, mode) {
          Widget body;
          if (mode == RefreshStatus.idle) {
            body = Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.arrow_downward, size: 20, color: Color(0xFF8EAC50)),
                SizedBox(width: 8),
                Text(
                  'Pull to refresh',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            );
          } else if (mode == RefreshStatus.refreshing) {
            body = Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(Color(0xFF8EAC50)),
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  'Refreshing...',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            );
          } else if (mode == RefreshStatus.completed) {
            body = Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, size: 20, color: Color(0xFF8EAC50)),
                SizedBox(width: 8),
                Text(
                  'Updated!',
                  style: TextStyle(color: Color(0xFF8EAC50)),
                ),
              ],
            );
          } else {
            body = Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.refresh, size: 20, color: Color(0xFF8EAC50)),
                SizedBox(width: 8),
                Text(
                  'Release to refresh',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            );
          }

          return Container(
            height: 60,
            child: Center(child: body),
          );
        },
      ),
      footer: enablePullUp
          ? CustomFooter(
              builder: (context, mode) {
                Widget body;
                if (mode == LoadStatus.idle) {
                  body = Text('Pull up to load more');
                } else if (mode == LoadStatus.loading) {
                  body = CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(Color(0xFF8EAC50)),
                  );
                } else if (mode == LoadStatus.failed) {
                  body = Text('Load Failed!');
                } else if (mode == LoadStatus.canLoading) {
                  body = Text('Release to load more');
                } else {
                  body = Text('No more data');
                }
                return Container(
                  height: 55.0,
                  child: Center(child: body),
                );
              },
            )
          : null,
      child: child,
    );
  }
}
