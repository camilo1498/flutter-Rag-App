import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

class CroppedSettings{
   cropImage({image, context}){
    return ImageCropper.cropImage(
        sourcePath: image,
        aspectRatioPresets: Platform.isAndroid
            ? [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio5x3,
          CropAspectRatioPreset.ratio7x5,
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio16x9
        ]
            : [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio5x3,
          CropAspectRatioPreset.ratio7x5,
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Recortar',
            toolbarWidgetColor: Colors.white,
            toolbarColor: Colors.grey[850],
            cropFrameColor: Colors.grey[850],
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        cropStyle: CropStyle.rectangle,
        iosUiSettings: IOSUiSettings(
          title: 'Recortar',
          aspectRatioLockDimensionSwapEnabled: true,
          aspectRatioLockEnabled: false,
          rotateClockwiseButtonHidden: true,
          showCancelConfirmationDialog: true,
          minimumAspectRatio: MediaQuery.of(context).size.aspectRatio,
          resetAspectRatioEnabled: true,
          doneButtonTitle: 'Guardar',
          cancelButtonTitle: 'Cancelar',
        ),
        compressQuality: 100
    );
  }
}