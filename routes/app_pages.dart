import 'package:foodlink/screens/auth_screens/login_screen.dart';
import 'package:get/get.dart';
import 'app_routes.dart';

class AppPages {
  static var list = [
    GetPage(
      name: AppRoutes.logIn,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: AppRoutes.createAccount,
      page: () => const CreateAccount(),
    ),
    GetPage(
      name: AppRoutes.mobileVerification,
      page: () => MobileVerification(),
    ),
    GetPage(
      name: AppRoutes.otpVerification,
      page: () {
        OTPVerification otpVerification  = Get.arguments;
        return otpVerification;
      },
    ),
    GetPage(
      name: AppRoutes.kycPage,
      page: () => KYCPage(),
    ),
    GetPage(
      name: AppRoutes.kycSuccess,
      page: () => const KYCSuccess(),
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordScreen(),
    ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const MainTabScreen(),
    ),
    GetPage(
      name: AppRoutes.homeScreen,
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: AppRoutes.searchScreen,
      page: () => SearchScreen(),
    ),
    GetPage(
      name: AppRoutes.chatNotification,
      page: () => const ChatNotificationScreen(),
    ),
    GetPage(
      name: AppRoutes.notificationScreen,
      page: () => const NotificationScreen(),
    ),
    GetPage(
      name: AppRoutes.profileScreen,
      page: () => const ProfileScreen(),
    ),
    GetPage(
      name: AppRoutes.emailSent,
      page: () => const EmailSentScreen(),
    ),
    GetPage(
      name: AppRoutes.searchItem,
      page: () => const SearchItemScreen(),
    ),
    GetPage(
      name: AppRoutes.createRequest,
      page: () => const CreateRequestScreen(),
    ),
    GetPage(
      name: AppRoutes.decline,
      page: () => const Decline(),
    ),
    GetPage(
      name: AppRoutes.requestSentSuccess,
      page: () => const RequestSentSuccessScreen(),
    ),
    GetPage(
      name: AppRoutes.editProfile,
      page: () => const EditProfile(),
    ),
    GetPage(
      name: AppRoutes.requesterPost,
      page: () => RequesterPostScreen(),
    ),
    GetPage(
      name: AppRoutes.travellerPost,
      page: () => TravellerPostScreen(),
    ),
    GetPage(
      name: AppRoutes.deliveryDone,
      page: () => const DeliveryDoneScreen(),
    ),
    GetPage(
      name: AppRoutes.paymentDone,
      page: () => const PaymentDoneScreen(),
    ),
    GetPage(
      name: AppRoutes.createTrip,
      page: () => const CreateTripScreen(),
    ),
    GetPage(
      name: AppRoutes.destinationCardDetail,
      page: () => const DestinationCardDetailScreen(),
    ),
    GetPage(
      name: AppRoutes.requestTravellerPost,
      page: () => RequestTravellerPostScreen(),
    ),
    GetPage(
      name: AppRoutes.paymentStuff,
      page: () => const PaymentStuffScreen(),
    ),
    GetPage(
      name: AppRoutes.showQRCode,
      page: () => const ShowQRCode(),
    ),
    GetPage(
      name: AppRoutes.travellerPostAccept,
      page: () => TravellerPostAcceptScreen(),
    ),
    GetPage(
      name: AppRoutes.declineSentNewRequest,
      page: () => const DeclineSentNewRequestScreen(),
    ),
    GetPage(
      name: AppRoutes.myRequest,
      page: () => const MyRequestScreen(),
    ),
    GetPage(
      name: AppRoutes.KYCPageUploadDoc,
      page: () => KYCPageUploadDoc(),
    ),
    GetPage(
      name: AppRoutes.KYCPageSelectDoc,
      page: () => KYCPageSelectDoc(),
    ),
    GetPage(
      name: AppRoutes.chat,
      page: () => const ChatScreen(),
    ),
  ];
}
