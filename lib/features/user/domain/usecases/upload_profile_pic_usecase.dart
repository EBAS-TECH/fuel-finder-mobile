import 'dart:io';

import 'package:fuel_finder/features/user/domain/repositories/user_repository.dart';

class UploadProfilePicUsecase {
  final UserRepository userRepository;

  UploadProfilePicUsecase({required this.userRepository});

  Future<void> call(File imageFile) {
    return userRepository.uploadProfilePic(imageFile);
  }
}

