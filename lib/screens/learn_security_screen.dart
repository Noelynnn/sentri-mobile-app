import 'package:flutter/material.dart';

import '../models/learning_resource.dart';
import '../models/security_lesson.dart';
import '../theme/app_colors.dart';
import '../widgets/security_topic_card.dart';
import 'security_lesson_screen.dart';

class LearnSecurityScreen extends StatefulWidget {
  const LearnSecurityScreen({super.key});

  @override
  State<LearnSecurityScreen> createState() => _LearnSecurityScreenState();
}

class _LearnSecurityScreenState extends State<LearnSecurityScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allLessons = _buildLessons();
    final filteredLessons = _filterLessons(allLessons);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Learn Security',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            20,
            12,
            20,
            32,
          ),
          children: [
            // --------------------------------------------------
            // Header
            // --------------------------------------------------
            const Text(
              'Stay Safe Online',
              style: TextStyle(
                fontSize: 29,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
                height: 1.15,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Learn practical ways to protect yourself from '
              'scams, phishing, fraud, and other online threats.',
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 22),

            // --------------------------------------------------
            // Intro card
            // --------------------------------------------------
            _buildLearningIntro(),

            const SizedBox(height: 20),

            // --------------------------------------------------
            // Search
            // --------------------------------------------------
            _buildSearchField(),

            const SizedBox(height: 24),

            // --------------------------------------------------
            // No results
            // --------------------------------------------------
            if (filteredLessons.isEmpty) _buildNoResults(),

            // --------------------------------------------------
            // Categories
            // --------------------------------------------------
            if (filteredLessons.isNotEmpty)
              ...SecurityLessonCategory.values.map(
                (category) {
                  final categoryLessons = filteredLessons
                      .where(
                        (lesson) => lesson.category == category,
                      )
                      .toList();

                  if (categoryLessons.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return Padding(
                    padding: const EdgeInsets.only(
                      bottom: 24,
                    ),
                    child: _buildCategorySection(
                      context,
                      category,
                      categoryLessons,
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLearningIntro() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.15),
        ),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.white,
            child: Icon(
              Icons.school_outlined,
              color: AppColors.primary,
            ),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Learn in a few minutes',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Explore short lessons, safety tips, and trusted '
                  'resources you can use to build safer digital habits.',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.45,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        style: const TextStyle(
          color: AppColors.textDark,
          fontSize: 15,
        ),
        decoration: InputDecoration(
          icon: const Icon(
            Icons.search_rounded,
            color: AppColors.primary,
          ),
          hintText: 'Search security lessons...',
          hintStyle: TextStyle(
            color: AppColors.textSecondary.withOpacity(0.75),
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildNoResults() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 42,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: 12),
          Text(
            'No lessons found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Try searching for another security topic.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              height: 1.4,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(
    BuildContext context,
    SecurityLessonCategory category,
    List<SecurityLesson> lessons,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _categoryTitle(category),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 12),
        ...lessons.map(
          (lesson) => Padding(
            padding: const EdgeInsets.only(
              bottom: 12,
            ),
            child: SecurityTopicCard(
              icon: lesson.icon,
              title: lesson.title,
              description: lesson.description,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SecurityLessonScreen(
                      lesson: lesson,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  String _categoryTitle(
    SecurityLessonCategory category,
  ) {
    switch (category) {
      case SecurityLessonCategory.scamsAndFraud:
        return 'Scams & Fraud';

      case SecurityLessonCategory.accountAndDeviceSafety:
        return 'Account & Device Safety';

      case SecurityLessonCategory.onlineAwareness:
        return 'Online Awareness';
    }
  }

  List<SecurityLesson> _filterLessons(
    List<SecurityLesson> lessons,
  ) {
    final query = _searchQuery.trim().toLowerCase();

    if (query.isEmpty) {
      return lessons;
    }

    return lessons.where((lesson) {
      return lesson.title.toLowerCase().contains(query) ||
          lesson.description.toLowerCase().contains(query) ||
          lesson.category.name.toLowerCase().contains(query);
    }).toList();
  }

  List<SecurityLesson> _buildLessons() {
    return [
      // ==================================================
      // SCAMS & FRAUD
      // ==================================================

      const SecurityLesson(
        title: 'Online Scams',
        description: 'Understand common scam tactics and learn how '
            'to avoid them.',
        icon: Icons.warning_amber_rounded,
        category: SecurityLessonCategory.scamsAndFraud,
        sections: [
          'Online scams often rely on deception rather than technical hacking. Scammers may pretend that you have won something, owe money, received a package, or need to act immediately.',
          'A common warning sign is a request for money, passwords, verification codes, or other sensitive information that you were not expecting.',
          'Take a moment to verify the situation independently instead of acting under pressure.',
        ],
        tips: [
          'Be suspicious of unexpected requests for money.',
          'Do not share verification codes with anyone.',
          'Question offers that seem too good to be true.',
          'Take time to verify urgent requests.',
        ],
      ),

      const SecurityLesson(
        title: 'M-Pesa & Mobile Money Scams',
        description: 'Learn how common mobile-money scams work and '
            'how to protect your money and account.',
        icon: Icons.account_balance_wallet_outlined,
        category: SecurityLessonCategory.scamsAndFraud,
        sections: [
          'Mobile-money scams may involve fake customer-care agents, fake reversal requests, false payment confirmations, or messages designed to make you send money quickly.',
          'Scammers may try to convince you that a transaction has failed, that money was sent to you by mistake, or that your account needs urgent verification.',
          'Never rely only on a message or screenshot as proof of payment. Check the transaction directly through the official service.',
        ],
        tips: [
          'Never share your M-Pesa PIN or verification code.',
          'Check your balance or transaction history yourself.',
          'Do not send money to “reverse” a payment unless you have independently verified the request.',
          'Use official customer-care channels when you need help.',
        ],
        resources: [
          LearningResource(
            title: 'M-PESA Fraud Awareness',
            source: 'Safaricom PLC • YouTube',
            url: 'https://www.youtube.com/watch?v=byELy62B0mU',
            type: LearningResourceType.video,
          ),
        ],
      ),

      const SecurityLesson(
        title: 'WhatsApp Scams',
        description: 'Recognize common WhatsApp scams, impersonation attempts, '
            'and suspicious requests.',
        icon: Icons.chat_bubble_outline,
        category: SecurityLessonCategory.scamsAndFraud,
        sections: [
          'WhatsApp scams can involve fake friends, relatives, businesses, customer-care agents, or giveaway accounts.',
          'Attackers may use a familiar profile photo or name to create trust before asking for money, verification codes, or other information.',
          'A different phone number or unusual request should be treated carefully, even when the profile looks familiar.',
        ],
        tips: [
          'Verify unusual requests using another trusted contact method.',
          'Never share WhatsApp verification codes.',
          'Be cautious with unexpected group invitations and links.',
          'Report and block suspicious accounts.',
        ],
        resources: [
          LearningResource(
            title: 'How to protect yourself from suspicious messages and scams',
            source: 'WhatsApp Help Center',
            url: 'https://faq.whatsapp.com/573786218075805',
            type: LearningResourceType.article,
          ),
        ],
      ),

      const SecurityLesson(
        title: 'Fake Job Offers',
        description: 'Learn how scammers use fake jobs, interviews, and '
            'recruitment messages to steal money or information.',
        icon: Icons.work_outline,
        category: SecurityLessonCategory.scamsAndFraud,
        sections: [
          'Fake job scams often promise easy work, unusually high pay, or immediate hiring without a normal recruitment process.',
          'Scammers may ask for registration fees, training fees, transport charges, or personal information before employment begins.',
          'A legitimate opportunity should be independently verifiable through the organization involved.',
        ],
        tips: [
          'Research the company before sharing personal information.',
          'Be cautious when a job requires payment upfront.',
          'Check the sender and official company website.',
          'Do not send identity or financial information to unverified recruiters.',
        ],
      ),

      const SecurityLesson(
        title: 'Romance Scams',
        description: 'Learn how online relationships can be manipulated '
            'to build trust and request money.',
        icon: Icons.favorite_border,
        category: SecurityLessonCategory.scamsAndFraud,
        sections: [
          'Romance scammers often build emotional trust over time before introducing an urgent financial problem or request.',
          'They may claim to have an emergency, need help with travel, medical expenses, customs, or other unexpected costs.',
          'Strong emotional pressure should not replace independent verification.',
        ],
        tips: [
          'Be cautious about sending money to someone you have not met and verified.',
          'Do not share financial credentials with an online romantic contact.',
          'Talk to someone you trust before acting on an emotional request.',
          'Be suspicious when emergencies repeatedly involve money.',
        ],
      ),

      const SecurityLesson(
        title: 'SIM Swap Fraud',
        description: 'Understand how criminals can take control of a mobile '
            'number and why account security matters.',
        icon: Icons.sim_card_alert_outlined,
        category: SecurityLessonCategory.scamsAndFraud,
        sections: [
          'SIM swap fraud happens when an attacker tricks or manipulates a mobile-service provider into moving your number to a SIM card controlled by the attacker.',
          'Once control of the number is lost, attackers may try to intercept verification codes or gain access to accounts linked to the number.',
          'Unexpected loss of mobile service can be a warning sign that requires immediate attention.',
        ],
        tips: [
          'Treat unexpected loss of mobile service seriously.',
          'Contact your mobile provider through official channels if your SIM suddenly stops working.',
          'Use strong account protection and multi-factor authentication where possible.',
          'Monitor important accounts for unusual activity.',
        ],
        resources: [
          LearningResource(
            title: 'Advisory on SIM swap fraud',
            source: 'Communications Authority of Kenya',
            url: 'https://repository.ca.go.ke/handle/123456789/1219',
            type: LearningResourceType.article,
          ),
        ],
      ),

      const SecurityLesson(
        title: 'Online Shopping Scams',
        description: 'Spot fake stores, unrealistic deals, and payment traps '
            'when shopping online.',
        icon: Icons.shopping_cart_outlined,
        category: SecurityLessonCategory.scamsAndFraud,
        sections: [
          'Online shopping scams may use fake stores, copied product listings, unrealistic discounts, or pressure to pay quickly.',
          'A seller may request payment through unusual channels while providing little reliable information about the business.',
          'Independent reviews, verified contact details, and secure payment practices can reduce risk.',
        ],
        tips: [
          'Be cautious of prices that seem unrealistically low.',
          'Research unfamiliar sellers before paying.',
          'Avoid sending payments through unusual or unverified channels.',
          'Check the website address carefully before purchasing.',
        ],
      ),

      const SecurityLesson(
        title: 'Impersonation Scams',
        description: 'Learn how criminals pretend to be trusted people, '
            'companies, or authorities.',
        icon: Icons.person_search_outlined,
        category: SecurityLessonCategory.scamsAndFraud,
        sections: [
          'Impersonation scams rely on pretending to be someone the victim already trusts, such as a bank, employer, family member, government agency, or support team.',
          'Attackers may use familiar names, logos, profile pictures, or official-looking language to appear legitimate.',
          'The safest response to an unusual request is to verify it independently.',
        ],
        tips: [
          'Do not rely on caller ID, profile photos, or logos alone.',
          'Verify requests through an official channel.',
          'Do not share sensitive information because someone claims authority.',
          'Slow down when a trusted person suddenly asks for something unusual.',
        ],
      ),

      const SecurityLesson(
        title: 'I Think I\'ve Been Scammed',
        description: 'Learn what to do if you have already shared information, '
            'sent money, or interacted with a suspicious person.',
        icon: Icons.help_outline_rounded,
        category: SecurityLessonCategory.scamsAndFraud,
        sections: [
          'If you think you have been scammed, do not panic. Acting quickly and calmly can help reduce further damage.',
          'Stop communicating with the suspicious person and do not send additional money or information, even if they promise to reverse the situation.',
          'Secure any affected accounts. Change compromised passwords, review account activity, and contact the relevant service provider through an official channel.',
          'Keep evidence such as screenshots, transaction information, phone numbers, usernames, links, and messages. This information can help when reporting the incident.',
          'Report the incident through the appropriate platform or official channel. In Sentri, you can also use Report Crime to record the incident and preserve the details for follow-up.',
        ],
        tips: [
          'Stop sending money or sensitive information.',
          'Change passwords that may have been exposed.',
          'Contact your bank, mobile-money provider, or service through an official channel.',
          'Keep screenshots and transaction details.',
          'Report the incident as soon as possible.',
        ],
        resources: [
          LearningResource(
            title: 'How to protect yourself from suspicious messages and scams',
            source: 'WhatsApp Help Center',
            url: 'https://faq.whatsapp.com/573786218075805',
            type: LearningResourceType.article,
          ),
        ],
      ),

      // ==================================================
      // ACCOUNT & DEVICE SAFETY
      // ==================================================

      const SecurityLesson(
        title: 'Password Safety',
        description: 'Learn how to create stronger passwords and protect '
            'your accounts.',
        icon: Icons.lock_outline,
        category: SecurityLessonCategory.accountAndDeviceSafety,
        sections: [
          'A strong password is one of the simplest ways to protect an online account. Avoid using information that is easy to guess, such as your name, birthday, phone number, or common words.',
          'Use long, unique passwords for important accounts. Reusing the same password across multiple services can put several accounts at risk if one password is exposed.',
          'Where available, use a password manager to generate and store unique passwords rather than relying on memory.',
        ],
        tips: [
          'Use long and unique passwords.',
          'Avoid reusing the same password across important accounts.',
          'Never share your passwords with other people.',
          'Enable multi-factor authentication when available.',
        ],
      ),

      const SecurityLesson(
        title: 'Two-Factor Authentication',
        description: 'Learn how an extra verification step can help protect '
            'your accounts.',
        icon: Icons.verified_user_outlined,
        category: SecurityLessonCategory.accountAndDeviceSafety,
        sections: [
          'Two-factor authentication adds another verification step beyond a password.',
          'This can make it harder for someone to access an account even if they discover the password.',
          'Different services may offer different authentication methods, so use the strongest trusted option available.',
        ],
        tips: [
          'Enable multi-factor authentication on important accounts.',
          'Never share verification codes with someone else.',
          'Review security settings regularly.',
          'Keep backup recovery methods secure.',
        ],
        resources: [
          LearningResource(
            title: 'About two-step verification',
            source: 'WhatsApp Help Center',
            url: 'https://faq.whatsapp.com/1278661612895630',
            type: LearningResourceType.article,
          ),
        ],
      ),

      const SecurityLesson(
        title: 'Device Security',
        description: 'Build safer habits for protecting your phone, computer, '
            'and personal data.',
        icon: Icons.devices_outlined,
        category: SecurityLessonCategory.accountAndDeviceSafety,
        sections: [
          'Your devices contain personal conversations, accounts, photos, documents, and other information that should be protected.',
          'Keeping your operating system and apps updated helps you receive important security fixes.',
          'Locking your device and limiting unnecessary permissions can reduce exposure if the device is lost or misused.',
        ],
        tips: [
          'Keep your phone and apps updated.',
          'Use a strong screen lock.',
          'Review app permissions.',
          'Avoid installing software from untrusted sources.',
        ],
      ),

      const SecurityLesson(
        title: 'Privacy & Personal Information',
        description: 'Learn how to reduce the amount of personal information '
            'you expose online.',
        icon: Icons.privacy_tip_outlined,
        category: SecurityLessonCategory.accountAndDeviceSafety,
        sections: [
          'Personal information can be valuable to scammers and attackers. Information shared publicly can sometimes be combined to create convincing scams.',
          'Think carefully about what you share publicly, especially contact details, location information, identification details, and financial information.',
          'Review privacy settings on services you use regularly.',
        ],
        tips: [
          'Share only the information that is necessary.',
          'Review privacy settings on social platforms.',
          'Avoid posting sensitive personal information publicly.',
          'Be cautious when unfamiliar services request personal data.',
        ],
      ),

      // ==================================================
      // ONLINE AWARENESS
      // ==================================================

      const SecurityLesson(
        title: 'Phishing Awareness',
        description: 'Learn to recognize suspicious messages, websites, '
            'and links.',
        icon: Icons.phishing_outlined,
        category: SecurityLessonCategory.onlineAwareness,
        sections: [
          'Phishing is a form of social engineering in which attackers try to trick people into revealing information, clicking malicious links, or taking an unsafe action.',
          'Phishing messages may pretend to come from banks, delivery services, schools, employers, social media platforms, or other trusted organizations.',
          'Attackers often create urgency or fear to make people act before they have time to verify the request.',
        ],
        tips: [
          'Check the sender before trusting a message.',
          'Be cautious with unexpected links and attachments.',
          'Do not enter sensitive information through links in suspicious messages.',
          'Verify unusual requests through an official channel.',
        ],
      ),

      const SecurityLesson(
        title: 'Social Engineering',
        description: 'Learn how attackers manipulate people into revealing '
            'information or taking unsafe actions.',
        icon: Icons.psychology_outlined,
        category: SecurityLessonCategory.onlineAwareness,
        sections: [
          'Social engineering attacks target human behavior. Instead of trying to break into a system directly, an attacker may manipulate a person into giving them access or information.',
          'Attackers may use authority, urgency, fear, curiosity, or familiarity to gain trust.',
          'Recognizing these psychological tactics can help you slow down and make safer decisions.',
        ],
        tips: [
          'Be cautious when someone pressures you to act quickly.',
          'Verify identities before sharing sensitive information.',
          'Do not assume a familiar name or profile proves someone’s identity.',
          'When something feels unusual, pause and verify it.',
        ],
      ),

      const SecurityLesson(
        title: 'Safe Browsing',
        description: 'Build safer habits when visiting websites and using '
            'online services.',
        icon: Icons.language_outlined,
        category: SecurityLessonCategory.onlineAwareness,
        sections: [
          'Safe browsing starts with paying attention to where links lead and what information a website asks you to provide.',
          'Before entering sensitive information, check that you are using the intended website and that the connection is protected.',
          'Keep your browser and devices updated so that security fixes are applied regularly.',
        ],
        tips: [
          'Check website addresses before entering sensitive information.',
          'Avoid downloading files from untrusted sources.',
          'Keep your browser and device software updated.',
          'Use caution when browsing on public or unsecured networks.',
        ],
      ),

      const SecurityLesson(
        title: 'Safe Social Media',
        description: 'Learn how to protect your privacy and avoid common '
            'social-media scams.',
        icon: Icons.people_outline,
        category: SecurityLessonCategory.onlineAwareness,
        sections: [
          'Social media can expose personal information that attackers may use for impersonation, scams, or targeted manipulation.',
          'Fake profiles, suspicious messages, giveaways, and misleading links are common ways people are targeted.',
          'Reviewing what you share and who can contact you can improve your privacy.',
        ],
        tips: [
          'Review who can see your posts and personal details.',
          'Be cautious with unexpected direct messages.',
          'Verify giveaways and offers independently.',
          'Do not share verification codes or sensitive account information.',
        ],
      ),
    ];
  }
}
