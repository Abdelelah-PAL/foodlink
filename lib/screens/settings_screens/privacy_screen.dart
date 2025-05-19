import 'package:flutter/material.dart';
import '../../core/constants/fonts.dart';
import '../../core/utils/size_config.dart';
import '../../providers/settings_provider.dart';
import 'widgets/custom_top_bar.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key, required this.settingsProvider});

  final SettingsProvider settingsProvider;

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  @override
  Widget build(BuildContext context) {
    final textDirection = widget.settingsProvider.language == "ar"
        ? TextDirection.rtl
        : TextDirection.ltr;

    return Scaffold(
      appBar:PreferredSize(
          preferredSize: Size.fromHeight(SizeConfig.getProportionalHeight(100)),
          child: CustomTopBar(text: 'privacy', rightPadding: 150, settingsProvider: widget.settingsProvider)),
      body: Directionality(
        textDirection: textDirection,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.settingsProvider.language == "ar"
                ? _arabicContent()
                : _englishContent(),
          ),
        ),
      ),
    );
  }

  List<Widget> _englishContent() => const [
        SectionTitle('Terms of Use'),
        SubSectionTitle('First: Unauthorized Use'),
        SectionText(
          'You may use this website only for lawful purposes. You may not use the website in any of the following situations:\n\n'
          '- In any way that breaches any applicable local, national, or international law or regulation;\n'
          '- In any unlawful or fraudulent manner or for any unlawful or fraudulent purpose or effect;\n'
          '- In a defamatory, obscene, offensive, or hateful manner, or in a way that incites hatred;\n'
          '- To promote any obscene or discriminatory materials of any kind;\n'
          '- To transmit or cause the sending of any unsolicited or unauthorized advertising or promotional materials or any other form of spam.',
        ),
        SubSectionTitle('Second: Intellectual Property Rights'),
        SectionText(
          'All trademarks mentioned on the site are the property of their respective owners unless otherwise stated. This website is protected by copyright, trademarks, data rights, and intellectual property rights.',
        ),
        SubSectionTitle('Third: Legal Responsibility'),
        SectionText(
          'We are not responsible for any content, loss, or damage of any kind resulting from the use of any content on this website. We are also not liable for any actions performed by us or our employees, except as required by UAE law.',
        ),
        SectionTitle('Privacy Policy'),
        SubSectionTitle('Browsing'),
        SectionText(
          'This website does not collect personal information while browsing unless you provide it voluntarily.',
        ),
        SubSectionTitle('IP Address'),
        SectionText(
          'Your IP address, browser type, and referral URL are automatically recorded when you visit any website including ours.',
        ),
        SubSectionTitle('Web Surveys'),
        SectionText(
          'We may collect feedback via surveys to improve our site. You are free to provide or withhold personal data.',
        ),
        SubSectionTitle('Links to Other Websites'),
        SectionText(
          'We are not responsible for the data collection policies of other websites linked to our site. Ads may use cookies for ad targeting.',
        ),
        SubSectionTitle('Disclosure of Information'),
        SectionText(
          'We keep your personal data confidential unless required by law or to protect our legal rights.',
        ),
        SubSectionTitle('Data for Transaction Completion'),
        SectionText(
          'We may request your data to fulfill your requests. Your data will never be sold or shared without your written consent.',
        ),
      ];

  List<Widget> _arabicContent() => const [
        SectionTitle('سياسة الاستخدام'),
        SubSectionTitle('أولاً: الاستخدام غير المصرح به'),
        SectionText(
          'يجوز لكم استخدام هذا الموقع فقط لأغراض قانونية. ولا يجوز لكم استخدام الموقع في حال شمل الاستخدام أيًّا من الحالات التالية:\n\n'
          '- إخلال بأي قانون أو لائحة محلية أو وطنية أو دولية نافذة؛\n'
          '- استخدام غير قانوني أو احتيالي أو له أي غرض غير قانوني أو احتيالي؛\n'
          '- التشهير بأي شخص أو استخدام محتوى فاحش أو مهين أو مكروه أو تحريضي؛\n'
          '- الترويج لأي مواد جنسية فاضحة أو تمييز من أي نوع؛\n'
          '- إرسال أو التسبب في إرسال مواد دعائية أو ترويجية غير مرغوب فيها (spam).',
        ),
        SubSectionTitle('ثانياً: حقوق الملكية الفكرية'),
        SectionText(
          'جميع العلامات التجارية المذكورة بالموقع هي ملك لأصحابها ما لم يُعلن غير ذلك. هذا الموقع محمي بحقوق النسخ والعلامات التجارية والبيانات والملكية الفكرية.',
        ),
        SubSectionTitle('ثالثاً: المسؤولية القانونية'),
        SectionText(
          'لا نتحمل مسؤولية أي محتوى أو خسائر أو أضرار من أي نوع نتيجة استخدام أي محتوى على هذا الموقع. كما أننا غير مسؤولين عن أي تصرفات من قبل موظفينا إلا حسب ما ينص عليه قانون دولة الإمارات.',
        ),
        SectionTitle('سياسة الخصوصية'),
        SubSectionTitle('التصفح'),
        SectionText(
          'لم نقم بتصميم هذا الموقع من أجل تجميع بياناتك الشخصية أثناء التصفح، إلا إذا قدمتها طوعاً.',
        ),
        SubSectionTitle('عنوان بروتوكول الإنترنت (IP)'),
        SectionText(
          'يتم تسجيل عنوان IP ونوع المتصفح وتاريخ ووقت الزيارة تلقائياً عند زيارتك لأي موقع، بما في ذلك موقعنا.',
        ),
        SubSectionTitle('عمليات المسح على الشبكة'),
        SectionText(
          'نقوم بجمع بيانات من خلال المسوحات لفهم رأيك وتحسين الموقع. يحق لك عدم تقديم أي بيانات شخصية.',
        ),
        SubSectionTitle('روابط المواقع الأخرى'),
        SectionText(
          'قد يتضمن الموقع روابط لمواقع أخرى. لسنا مسؤولين عن سياسات الخصوصية لتلك المواقع. قد تستخدم الإعلانات ملفات تعريف الارتباط.',
        ),
        SubSectionTitle('إفشاء المعلومات'),
        SectionText(
          'سنحافظ على سرية بياناتك ولن نفصح عنها إلا إذا طُلب قانونياً أو لحماية حقوقنا.',
        ),
        SubSectionTitle('البيانات اللازمة لتنفيذ المعاملات'),
        SectionText(
          'قد نطلب بيانات شخصية لتنفيذ طلباتك، ولن نبيعها لأي طرف ثالث دون موافقتك الكتابية المسبقة.',
        ),
      ];
}

class SectionTitle extends StatelessWidget {
  final String text;

  const SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        text,
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: AppFonts.getPrimaryFont(context)),
      ),
    );
  }
}

class SubSectionTitle extends StatelessWidget {
  final String text;

  const SubSectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 6),
      child: Text(
        text,
        style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: AppFonts.getPrimaryFont(context)),
      ),
    );
  }
}

class SectionText extends StatelessWidget {
  final String text;

  const SectionText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontSize: 14,
          height: 1.6,
          fontWeight: FontWeight.bold,
          fontFamily: AppFonts.getPrimaryFont(context)),
    );
  }
}
