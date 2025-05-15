import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

/// Custom Image Picker Widget using image_picker package
class CustomImagePicker extends StatefulWidget {
  /// Initial image file
  final XFile? initialImageFile;

  /// Width of the image
  final double? width;

  /// Height of the image
  final double? height;

  /// Color of the image
  final Color? color;

  /// Fit of the image
  final BoxFit? fit;

  /// Semantic label of the image
  final String? semanticLabel;

  /// Margin of the image
  final EdgeInsets? margin;

  /// Placeholder widget to show when no image is selected
  final Widget? placeholder;

  /// Function to build the child widget with the selected image
  final Widget Function(XFile? imageFile)? child;

  /// Callback when an image is picked
  final ValueChanged<XFile?>? onImagePicked;

  /// Constructor for the CustomImagePicker widget
  const CustomImagePicker({
    super.key,
    this.initialImageFile,
    this.width,
    this.height,
    this.color,
    this.fit,
    this.semanticLabel,
    this.margin,
    this.placeholder,
    this.child,
    this.onImagePicked,
  });

  @override
  CustomImagePickerState createState() => CustomImagePickerState();
}

/// Custom Image Picker
class CustomImagePickerState extends State<CustomImagePicker> {
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _imageFile = widget.initialImageFile;
  }

  Future<void> _pickImage() async {
    try {
      if (!kIsWeb) {
        final hasPermission = await _checkAndRequestPermission();
        if (!hasPermission) return;
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _imageFile = image;
        });
        widget.onImagePicked?.call(image);
      }
    } on PlatformException catch (e) {
      _handlePickError(e);
    } on Exception catch (e) {
      if (mounted) {
        _showCustomSnackBar('Error picking image: $e');
      }
    }
  }

  Future<bool> _checkAndRequestPermission() async {
    if (!Platform.isAndroid && !Platform.isIOS) return true;

    final deviceInfo = DeviceInfoPlugin();
    PermissionStatus status;

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      if (androidInfo.version.sdkInt >= 33) {
        status = await Permission.photos.request();
      } else {
        status = await Permission.storage.request();
      }
    } else {
      status = await Permission.photos.request();
    }

    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied && mounted) {
      _showCustomSnackBar(
        'Permission denied. Please enable it in app settings',
        action: const SnackBarAction(
          label: 'Open Settings',
          onPressed: openAppSettings,
        ),
      );
    }
    return false;
  }

  void _handlePickError(PlatformException e) {
    if (!mounted) return;

    if (e.code == 'photo_access_denied' || e.code == 'access_denied') {
      _showCustomSnackBar(
        'Photo library access was denied',
        action: const SnackBarAction(
          label: 'Open Settings',
          onPressed: openAppSettings,
        ),
      );
    } else {
      _showCustomSnackBar('Error: ${e.message}');
    }
  }

  void _showCustomSnackBar(String message, {SnackBarAction? action}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        action: action,
      ),
    );
  }

  Widget _buildImageWidget() {
    if (_imageFile == null) {
      return widget.placeholder ??
          widget.child?.call(null) ??
          const Icon(Icons.image, size: 50);
    }

    if (widget.child != null) {
      return widget.child!(_imageFile);
    }

    return FutureBuilder<Uint8List>(
      future: _imageFile!.readAsBytes(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Image.memory(
            snapshot.data!,
            width: widget.width,
            height: widget.height,
            color: widget.color,
            fit: widget.fit ?? BoxFit.contain,
            semanticLabel: widget.semanticLabel,
            errorBuilder:
                (context, error, stackTrace) =>
                    widget.placeholder ?? const Icon(Icons.error, size: 50),
          );
        } else if (snapshot.hasError) {
          return widget.placeholder ?? const Icon(Icons.error, size: 50);
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: Padding(
        padding: widget.margin ?? EdgeInsets.zero,
        child: _buildImageWidget(),
      ),
    );
  }
}
