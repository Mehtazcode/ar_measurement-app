import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class PosePainter extends CustomPainter {
  final List<Pose> poses;
  final Size imageSize;
  final int sensorOrientation;

  PosePainter(this.poses, this.imageSize, this.sensorOrientation);

 Offset _translate(double x, double y, Size screenSize) {
    final double scaleX = screenSize.width / imageSize.height;
    final double scaleY = screenSize.height / imageSize.width;
    return Offset(
      (imageSize.height - x) * scaleX,  // flip x axis
      y * scaleY,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final dotPaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 4
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    for (final pose in poses) {
      for (final landmark in pose.landmarks.values) {
        final pos = _translate(landmark.x, landmark.y, size);
        canvas.drawCircle(pos, 6, dotPaint);
      }

      void drawLine(PoseLandmarkType type1, PoseLandmarkType type2) {
        final joint1 = pose.landmarks[type1];
        final joint2 = pose.landmarks[type2];
        if (joint1 == null || joint2 == null) return;
        canvas.drawLine(
          _translate(joint1.x, joint1.y, size),
          _translate(joint2.x, joint2.y, size),
          linePaint,
        );
      }

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