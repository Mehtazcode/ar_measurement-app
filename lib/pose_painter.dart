import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class PosePainter extends CustomPainter {
  final List<Pose> poses;
  final Size imageSize;

  PosePainter(this.poses, this.imageSize);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 4
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    for (final pose in poses) {
      // Draw dots on each landmark
      for (final landmark in pose.landmarks.values) {
        final x = landmark.x * size.width / imageSize.width;
        final y = landmark.y * size.height / imageSize.height;
        canvas.drawCircle(Offset(x, y), 6, paint);
      }

      // Draw lines connecting body parts
      void drawLine(PoseLandmarkType type1, PoseLandmarkType type2) {
        final joint1 = pose.landmarks[type1];
        final joint2 = pose.landmarks[type2];
        if (joint1 == null || joint2 == null) return;

        final x1 = joint1.x * size.width / imageSize.width;
        final y1 = joint1.y * size.height / imageSize.height;
        final x2 = joint2.x * size.width / imageSize.width;
        final y2 = joint2.y * size.height / imageSize.height;

        canvas.drawLine(Offset(x1, y1), Offset(x2, y2), linePaint);
      }

      // Body connections
      drawLine(PoseLandmarkType.leftShoulder, PoseLandmarkType.rightShoulder);
      drawLine(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow);
      drawLine(PoseLandmarkType.leftElbow, PoseLandmarkType.leftWrist);
      drawLine(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow);
      drawLine(PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist);
      drawLine(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip);
      drawLine(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip);
      drawLine(PoseLandmarkType.leftHip, PoseLandmarkType.rightHip);
      drawLine(PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee);
      drawLine(PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle);
      drawLine(PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee);
      drawLine(PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle);
      drawLine(PoseLandmarkType.nose, PoseLandmarkType.leftShoulder);
      drawLine(PoseLandmarkType.nose, PoseLandmarkType.rightShoulder);
    }
  }

  @override
  bool shouldRepaint(PosePainter oldDelegate) => true;
}