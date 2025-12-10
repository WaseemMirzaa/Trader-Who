import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paginate_firestore_plus/paginate_firestore.dart';
import 'package:traderou/controller/job_history_page_controller.dart';
import 'package:traderou/controller/notification_controller.dart';
import 'package:traderou/core/extensions/extensions.dart';
import 'package:traderou/core/shared_widgets/custom_button.dart';
import 'package:traderou/core/shared_widgets/custom_sccfold.dart';
import 'package:traderou/core/shared_widgets/custom_text.dart';
import 'package:traderou/core/theme/app_color.dart';
import 'package:traderou/core/theme/assets.dart';
import 'package:traderou/models/models.dart';
import 'package:traderou/views/notifications/presentation/widgets/widgets.dart';
import 'package:traderou/views/trades_job_history/presentation/pages/pages.dart';

part 'trade_notification_page.dart';
