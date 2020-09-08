import 'package:camera/camera.dart';

// simple class to call camera
class CameraService {

  CameraService();

  availableCamera() async {
    final cameras = await availableCameras();
    // Get a specific camera from the list of available cameras.
    final firstCamera = cameras.first;
    return firstCamera;
  }
}