import 'dart:io';


import 'package:dio/dio.dart';
import 'package:firebase_performance_dio/firebase_performance_dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple_connection_checker/simple_connection_checker.dart';

import '../config/config.dart';
import '../cubit/network_cubit.dart';
import '../network/network.dart';
import '../services/services.dart';

import '../utils/preferences_utils.dart';

part 'core_injection.dart';
part 'datasource_injection.dart';
part 'repository_injection.dart';
