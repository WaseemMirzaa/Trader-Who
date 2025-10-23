import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paginate_firestore_plus/paginate_firestore.dart';
import 'package:traderwho/controller/job_history_page_controller.dart';
import 'package:traderwho/controller/notification_controller.dart';
import 'package:traderwho/controller/quote_controller.dart';
import 'package:traderwho/core/extensions/extensions.dart';
import 'package:traderwho/core/shared_widgets/custom_button.dart';
import 'package:traderwho/core/shared_widgets/custom_sccfold.dart';
import 'package:traderwho/core/shared_widgets/custom_text.dart';
import 'package:traderwho/core/theme/theme.dart';
import 'package:traderwho/models/models.dart';
import 'package:traderwho/views/notifications/presentation/widgets/widgets.dart';
import 'package:traderwho/views/trades_job_history/presentation/pages/pages.dart';

part 'notification_page.dart';
