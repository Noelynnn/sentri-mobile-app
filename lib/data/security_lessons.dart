import 'package:flutter/material.dart';

import '../models/learning_resource.dart';
import '../models/security_lesson.dart';

class SecurityLessons {
  SecurityLessons._();

  static const List<SecurityLesson> all = [
    // ============================================================
    // SCAMS & FRAUD
    // ============================================================

    SecurityLesson(
      title: 'Online Scams',
      description:
          'Understand how common online scams work and learn how to recognize pressure, deception, and suspicious requests.',
      icon: Icons.warning_amber_rounded,
      category: SecurityLessonCategory.scamsAndFraud,
      estimatedMinutes: 7,
      learningObjectives: [
        'Recognize common scam patterns.',
        'Identify pressure and manipulation tactics.',
        'Know what to verify before sending money or information.',
        'Respond safely when a situation feels suspicious.',
      ],
      sections: [
        LessonSection(
          title: 'What is an online scam?',
          body:
              'An online scam is a deceptive attempt to trick someone into giving away money, information, access, or something else valuable. Scammers often do not need to break into a system. Instead, they create a convincing story and try to get the target to make the unsafe decision for them.',
        ),
        LessonSection(
          title: 'How scammers create pressure',
          body:
              'Scammers often create urgency by saying an account will be closed, a payment must be made immediately, a prize is waiting, or a problem must be fixed right away. Pressure reduces the chance that you will stop and verify what is happening.',
        ),
        LessonSection(
          title: 'What should make you pause?',
          body:
              'Unexpected requests for money, passwords, verification codes, or personal information deserve extra scrutiny. The fact that a message looks professional does not prove that it is genuine. Verify the situation using contact details or channels you already trust.',
        ),
        LessonSection(
          title: 'Why independent verification matters',
          body:
              'A common mistake is verifying a message using the same information provided by the sender. A safer approach is to leave the conversation and contact the company, person, or service through an official route you find independently.',
        ),
      ],
      warningSigns: [
        'Unexpected requests for money or sensitive information.',
        'Pressure to act immediately.',
        'Promises that seem unusually generous or unrealistic.',
        'Requests to keep the situation secret.',
      ],
      scenario:
          'You receive a message claiming that you have won a cash prize. The sender says you must pay a small processing fee within the next ten minutes or the prize will be cancelled.',
      actions: [
        'Stop and avoid acting under pressure.',
        'Check whether the offer is genuine using an independent source.',
        'Do not send money or sensitive information just to unlock a reward.',
        'Keep suspicious messages in case you need to report them.',
      ],
      commonMistakes: [
        'Trusting a message because it uses official-looking logos.',
        'Assuming urgency means the request must be legitimate.',
        'Paying a small amount because it feels safer than paying a large amount.',
        'Sharing verification codes with someone who claims to be helping.',
      ],
      tips: [
        'Pause before responding to unexpected requests.',
        'Verify important claims independently.',
        'Never share passwords or verification codes.',
        'Be suspicious of offers that require payment before a benefit is delivered.',
      ],
      takeaway:
          'A convincing story is not proof. When money, access, or sensitive information is involved, slow down and verify independently.',
      quizQuestions: [
        SecurityQuizQuestion(
          question: 'Which situation should make you most cautious?',
          options: [
            'A message you expected from a known contact.',
            'An unexpected request for money with a deadline.',
            'A normal newsletter from a service you use.',
            'A reminder you created yourself.',
          ],
          correctIndex: 1,
          explanation:
              'Unexpected money requests combined with urgency are common scam warning signs.',
        ),
        SecurityQuizQuestion(
          question: 'What is the safest way to verify an unexpected request?',
          options: [
            'Reply and ask the sender if it is real.',
            'Use another trusted or official contact method.',
            'Forward it to a friend and wait.',
            'Click the link in the message.',
          ],
          correctIndex: 1,
          explanation:
              'Independent verification reduces the chance that you are relying on information controlled by the scammer.',
        ),
        SecurityQuizQuestion(
          question: 'Why do scammers create urgency?',
          options: [
            'To make the message look professional.',
            'To encourage you to slow down.',
            'To reduce the time you have to think and verify.',
            'To improve customer service.',
          ],
          correctIndex: 2,
          explanation:
              'Urgency is often used to push people into making decisions before they have time to verify the situation.',
        ),
        SecurityQuizQuestion(
          question:
              'What should you never share just because someone asks for it?',
          options: [
            'A public website address.',
            'A verification code or password.',
            'A product name.',
            'A general question.',
          ],
          correctIndex: 1,
          explanation:
              'Passwords and verification codes are sensitive credentials and should not be shared with another person.',
        ),
      ],
    ),

    SecurityLesson(
      title: 'M-Pesa & Mobile Money Scams',
      description:
          'Learn how mobile-money scams use fake reversals, payment claims, impersonation, and urgency to target users.',
      icon: Icons.account_balance_wallet_outlined,
      category: SecurityLessonCategory.scamsAndFraud,
      estimatedMinutes: 8,
      learningObjectives: [
        'Recognize common mobile-money scam patterns.',
        'Verify payments independently.',
        'Respond safely to reversal and customer-care requests.',
        'Protect PINs and verification codes.',
      ],
      sections: [
        LessonSection(
          title: 'Why mobile-money scams work',
          body:
              'Mobile-money services are used frequently and transactions can feel urgent. Scammers take advantage of that speed by creating believable stories about mistaken payments, failed transactions, account problems, or urgent verification.',
        ),
        LessonSection(
          title: 'Fake payment and reversal claims',
          body:
              'A scammer may claim to have sent money to you or may send a screenshot as supposed proof. Another common tactic is asking you to send money back because a payment was supposedly made by mistake. The safest approach is to check your actual transaction history or balance rather than trusting a message or screenshot.',
        ),
        LessonSection(
          title: 'Fake customer-care requests',
          body:
              'Someone may claim to be support staff and ask for a PIN, verification code, or other sensitive information. A genuine support interaction should not require you to hand over confidential credentials.',
        ),
        LessonSection(
          title: 'When a transaction looks suspicious',
          body:
              'Stop the conversation, verify the transaction yourself, and use an official customer-care channel if you need help. Keep messages and transaction information if you think you have encountered a scam.',
        ),
      ],
      warningSigns: [
        'Someone claims money was sent but your balance does not reflect it.',
        'A stranger asks you to reverse a payment urgently.',
        'Someone claiming to be support requests your PIN or verification code.',
        'You are told to send money to unlock, verify, or reverse an account.',
      ],
      scenario:
          'You receive a message saying someone accidentally sent KSh 5,000 to your number and wants you to send it back immediately. They attach a screenshot showing the supposed transaction.',
      actions: [
        'Check your actual mobile-money transaction history.',
        'Do not rely on the screenshot as proof.',
        'Do not share your PIN or verification code.',
        'Contact the provider through an official support channel if needed.',
      ],
      commonMistakes: [
        'Treating screenshots as proof of payment.',
        'Sending money before checking the actual transaction.',
        'Sharing a PIN with someone claiming to be support staff.',
        'Following instructions from an unknown number because the request sounds urgent.',
      ],
      tips: [
        'Verify transactions inside the official service.',
        'Keep your PIN private.',
        'Never share verification codes.',
        'Use official customer-care channels.',
      ],
      takeaway:
          'Your transaction history is more trustworthy than a message or screenshot claiming that money was sent.',
      quizQuestions: [
        SecurityQuizQuestion(
          question:
              'Someone says they sent you money and shows a screenshot. What should you do first?',
          options: [
            'Send the money back immediately.',
            'Ask for their PIN.',
            'Check your actual transaction history.',
            'Post the screenshot online.',
          ],
          correctIndex: 2,
          explanation:
              'Independent confirmation inside the mobile-money service is safer than trusting a screenshot.',
        ),
        SecurityQuizQuestion(
          question:
              'Which information should never be shared with someone claiming to be customer care?',
          options: [
            'A general support question.',
            'Your mobile network.',
            'Your PIN or verification code.',
            'The date of a transaction.',
          ],
          correctIndex: 2,
          explanation:
              'PINs and verification codes are sensitive authentication credentials.',
        ),
        SecurityQuizQuestion(
          question: 'Why might a scammer ask you to act immediately?',
          options: [
            'To give you more time to research.',
            'To prevent you from checking the transaction independently.',
            'To improve the service.',
            'To reduce transaction fees.',
          ],
          correctIndex: 1,
          explanation: 'Urgency can discourage careful verification.',
        ),
        SecurityQuizQuestion(
          question: 'What is a safer source of truth for a payment claim?',
          options: [
            'A screenshot sent by the other person.',
            'A forwarded WhatsApp message.',
            'Your actual transaction history.',
            'A stranger\'s explanation.',
          ],
          correctIndex: 2,
          explanation:
              'The official transaction record is more reliable than information supplied by an unknown person.',
        ),
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

    SecurityLesson(
      title: 'WhatsApp Scams',
      description:
          'Recognize impersonation, fake emergencies, suspicious links, and verification-code scams on WhatsApp.',
      icon: Icons.chat_bubble_outline,
      category: SecurityLessonCategory.scamsAndFraud,
      estimatedMinutes: 7,
      learningObjectives: [
        'Recognize common WhatsApp scam patterns.',
        'Verify unusual requests from familiar contacts.',
        'Protect your verification code.',
        'Know when to block and report suspicious accounts.',
      ],
      sections: [
        LessonSection(
          title: 'Why WhatsApp is attractive to scammers',
          body:
              'People often trust messages from familiar names and profile pictures. Scammers can copy a person\'s photo or pretend to have changed numbers, then use that familiarity to make a request seem believable.',
        ),
        LessonSection(
          title: 'Common WhatsApp scam patterns',
          body:
              'Scams may involve fake friends or relatives asking for money, giveaway messages, suspicious groups, fake customer care, or links designed to steal information. Some attackers also try to obtain WhatsApp verification codes.',
        ),
        LessonSection(
          title: 'Familiar does not always mean genuine',
          body:
              'A familiar profile picture or name is not proof of identity. When a message is unusual, verify the person using another trusted method, such as calling a number you already know.',
        ),
        LessonSection(
          title: 'Protecting your account',
          body:
              'Keep verification codes private and use additional account protection where available. Suspicious accounts and messages can also be blocked and reported.',
        ),
      ],
      warningSigns: [
        'A friend suddenly asks for money from a new number.',
        'Someone asks for your WhatsApp verification code.',
        'A message promises prizes or rewards through a link.',
        'An account insists that you act before you can verify the request.',
      ],
      scenario:
          'A contact with your friend\'s profile photo says they lost their phone and need KSh 3,000 urgently. They ask you not to call because their phone is "not working."',
      actions: [
        'Do not send money immediately.',
        'Verify the person using another trusted contact method.',
        'Do not share verification codes.',
        'Block or report the account if the request proves suspicious.',
      ],
      commonMistakes: [
        'Trusting a profile picture as identity proof.',
        'Sending money because the message sounds emotionally urgent.',
        'Sharing a verification code to "help" someone recover an account.',
      ],
      tips: [
        'Verify unusual requests outside the chat.',
        'Keep WhatsApp verification codes private.',
        'Be careful with unexpected links.',
        'Block and report suspicious accounts.',
      ],
      takeaway:
          'On WhatsApp, familiarity can be copied. Verify unusual requests before trusting them.',
      quizQuestions: [
        SecurityQuizQuestion(
          question:
              'A friend appears to have a new number and urgently requests money. What should you do?',
          options: [
            'Send the money immediately.',
            'Verify their identity another way.',
            'Ask for their verification code.',
            'Post their message publicly.',
          ],
          correctIndex: 1,
          explanation:
              'A separate contact method helps confirm whether the account is genuinely your friend.',
        ),
        SecurityQuizQuestion(
          question: 'Which is a sensitive WhatsApp credential?',
          options: [
            'Your favorite emoji.',
            'A verification code.',
            'A public group name.',
            'A profile picture.',
          ],
          correctIndex: 1,
          explanation:
              'Verification codes can be used to control access to your account and should remain private.',
        ),
        SecurityQuizQuestion(
          question: 'What does a familiar profile picture prove?',
          options: [
            'That the person is definitely genuine.',
            'That the account belongs to your friend.',
            'Nothing by itself.',
            'That the request is safe.',
          ],
          correctIndex: 2,
          explanation: 'Profile photos and names can be copied.',
        ),
        SecurityQuizQuestion(
          question:
              'What is an appropriate response to a clearly suspicious WhatsApp account?',
          options: [
            'Continue chatting to see what happens.',
            'Share your code to test the person.',
            'Block and report the account.',
            'Send a small payment first.',
          ],
          correctIndex: 2,
          explanation:
              'Blocking and reporting can limit further contact and help protect others.',
        ),
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

    SecurityLesson(
      title: 'Fake Job Offers',
      description:
          'Learn how fake recruiters use attractive jobs, urgency, fees, and requests for personal information to target job seekers.',
      icon: Icons.work_outline,
      category: SecurityLessonCategory.scamsAndFraud,
      estimatedMinutes: 7,
      learningObjectives: [
        'Recognize warning signs in recruitment messages.',
        'Identify suspicious payment requests.',
        'Verify recruiters and companies independently.',
        'Protect personal and financial information during job searches.',
      ],
      sections: [
        LessonSection(
          title: 'How fake job scams work',
          body:
              'Fake job scams can appear through social media, messaging apps, email, or websites. They may promise unusually high pay, immediate hiring, simple work, or guaranteed employment.',
        ),
        LessonSection(
          title: 'The payment trap',
          body:
              'A common warning sign is being asked to pay a registration fee, training fee, equipment fee, or other charge before you can start working. A polished recruitment message does not make a payment request legitimate.',
        ),
        LessonSection(
          title: 'Protecting your information',
          body:
              'Recruiters may legitimately need some information, but requests for identity documents, banking details, passwords, or other sensitive information should be handled carefully and only after the organization and opportunity are verified.',
        ),
        LessonSection(
          title: 'Verifying the opportunity',
          body:
              'Search for the organization independently and use its official website or contact information. Do not rely only on the details supplied by the person who contacted you.',
        ),
      ],
      warningSigns: [
        'Guaranteed or unusually high pay for minimal work.',
        'Pressure to pay before employment begins.',
        'Recruitment without a normal or verifiable process.',
        'Requests for sensitive personal or financial information too early.',
      ],
      scenario:
          'A recruiter messages you about a remote job paying very well. You are told to pay KSh 2,500 for registration today because only a few slots remain.',
      actions: [
        'Do not pay the fee immediately.',
        'Research the company independently.',
        'Verify the recruiter using official company channels.',
        'Avoid sending sensitive documents until the opportunity is verified.',
      ],
      commonMistakes: [
        'Assuming a professional-looking job advert is genuine.',
        'Paying because the fee seems small.',
        'Sending identity documents before verifying the employer.',
      ],
      tips: [
        'Research unfamiliar employers.',
        'Treat upfront fees as a major warning sign.',
        'Verify recruitment contacts independently.',
        'Protect your identity and financial information.',
      ],
      takeaway:
          'A real-looking job advert can still be fake. Verify the employer and recruitment process before paying or sharing sensitive information.',
      quizQuestions: [
        SecurityQuizQuestion(
          question: 'Which is a major warning sign in a job offer?',
          options: [
            'A normal interview process.',
            'A request to pay a registration fee immediately.',
            'A company website you can verify independently.',
            'A clear job description.',
          ],
          correctIndex: 1,
          explanation:
              'Urgent upfront payment is a common fake-job scam tactic.',
        ),
        SecurityQuizQuestion(
          question: 'How should you verify an unfamiliar recruiter?',
          options: [
            'Use the phone number they sent you.',
            'Ask another stranger online.',
            'Find the company\'s official contact details independently.',
            'Send your ID first.',
          ],
          correctIndex: 2,
          explanation:
              'Independent verification helps avoid relying on information controlled by the scammer.',
        ),
        SecurityQuizQuestion(
          question: 'Why can a small fee still be dangerous?',
          options: [
            'Small fees are always illegal.',
            'It can be used to establish trust and extract more money later.',
            'Small payments cannot be reversed.',
            'It proves the job is real.',
          ],
          correctIndex: 1,
          explanation:
              'Scammers may use a small initial payment to gain trust before requesting more.',
        ),
        SecurityQuizQuestion(
          question: 'When should sensitive identity information be shared?',
          options: [
            'As soon as someone claims to be a recruiter.',
            'Only after the opportunity and recipient are verified.',
            'Whenever payment is requested.',
            'Whenever a profile looks professional.',
          ],
          correctIndex: 1,
          explanation:
              'Sensitive information should be shared carefully and only with verified organizations for legitimate purposes.',
        ),
      ],
    ),

    SecurityLesson(
      title: 'Romance Scams',
      description:
          'Understand how scammers build emotional trust and later use emergencies, promises, or pressure to request money.',
      icon: Icons.favorite_border,
      category: SecurityLessonCategory.scamsAndFraud,
      estimatedMinutes: 7,
      learningObjectives: [
        'Recognize emotional manipulation patterns.',
        'Understand why rushed financial requests are risky.',
        'Protect money and sensitive information.',
        'Use trusted people and verification when something feels wrong.',
      ],
      sections: [
        LessonSection(
          title: 'How romance scams develop',
          body:
              'A romance scam often begins with attention, affection, and frequent communication. The scammer may spend time building emotional trust before introducing a financial problem.',
        ),
        LessonSection(
          title: 'The emergency story',
          body:
              'Common stories involve travel problems, medical emergencies, customs fees, lost documents, or business problems. The story is designed to create emotional urgency and make financial help feel like the natural response.',
        ),
        LessonSection(
          title: 'Why emotions matter',
          body:
              'Strong emotions can make people ignore warning signs that would seem obvious in another situation. It helps to step back and discuss unusual requests with someone you trust.',
        ),
        LessonSection(
          title: 'Protecting yourself',
          body:
              'Do not send money, financial credentials, or sensitive documents simply because you feel emotionally close to someone online. A genuine relationship does not remove the need for basic verification.',
        ),
      ],
      warningSigns: [
        'A relationship becomes financially focused.',
        'Repeated emergencies involve requests for money.',
        'The person avoids reasonable verification or meeting opportunities.',
        'You are pressured to keep financial requests secret.',
      ],
      scenario:
          'Someone you met online says they are stranded abroad and urgently need money for travel documents. They promise to repay you as soon as they return home.',
      actions: [
        'Do not send money immediately.',
        'Slow the situation down.',
        'Speak with someone you trust before acting.',
        'Preserve messages and evidence if the situation appears fraudulent.',
      ],
      commonMistakes: [
        'Assuming emotional closeness proves identity.',
        'Sending money because the emergency sounds convincing.',
        'Keeping suspicious financial requests secret.',
      ],
      tips: [
        'Protect your financial information.',
        'Be cautious when online relationships quickly become financial.',
        'Discuss unusual requests with someone you trust.',
        'Watch for repeated emergencies.',
      ],
      takeaway:
          'Emotional trust should not replace independent verification when money or sensitive information is involved.',
      quizQuestions: [
        SecurityQuizQuestion(
          question: 'Why can romance scams be difficult to recognize?',
          options: [
            'They only use technical hacking.',
            'They build emotional trust before making requests.',
            'They never ask for money.',
            'They only happen through email.',
          ],
          correctIndex: 1,
          explanation:
              'The emotional relationship is often used to make later requests feel trustworthy.',
        ),
        SecurityQuizQuestion(
          question:
              'What should you do before sending money to an online romantic contact in an emergency?',
          options: [
            'Send a small amount first.',
            'Verify independently and talk to someone you trust.',
            'Share your banking password.',
            'Keep the request secret.',
          ],
          correctIndex: 1,
          explanation:
              'A second perspective and independent verification can interrupt emotional pressure.',
        ),
        SecurityQuizQuestion(
          question: 'Which pattern should increase your suspicion?',
          options: [
            'Normal conversation.',
            'A repeated series of financial emergencies.',
            'A shared hobby.',
            'A friendly greeting.',
          ],
          correctIndex: 1,
          explanation:
              'Repeated emergencies tied to money are a significant warning sign.',
        ),
        SecurityQuizQuestion(
          question: 'What should emotional closeness never replace?',
          options: [
            'Communication.',
            'Independent verification.',
            'Listening.',
            'Respect.',
          ],
          correctIndex: 1,
          explanation: 'Feelings do not prove identity or legitimacy.',
        ),
      ],
    ),

    SecurityLesson(
      title: 'SIM Swap Fraud',
      description:
          'Understand how criminals may attempt to take control of a phone number and why sudden loss of mobile service matters.',
      icon: Icons.sim_card_alert_outlined,
      category: SecurityLessonCategory.scamsAndFraud,
      estimatedMinutes: 7,
      learningObjectives: [
        'Understand the basic idea behind SIM swap fraud.',
        'Recognize sudden loss of mobile service as a warning sign.',
        'Know what to do when you suspect number takeover.',
        'Strengthen account protection beyond a phone number.',
      ],
      sections: [
        LessonSection(
          title: 'What is SIM swap fraud?',
          body:
              'SIM swap fraud occurs when an attacker manages to get a mobile number transferred to another SIM card under their control. The attacker may then try to receive calls or verification codes intended for the real owner.',
        ),
        LessonSection(
          title: 'How attackers use the number',
          body:
              'Once an attacker controls a number, they may attempt to reset accounts that rely on the number for verification. This is why a phone number should not be treated as the only layer of account security.',
        ),
        LessonSection(
          title: 'The sudden service-loss clue',
          body:
              'An unexpected and unexplained loss of mobile service can be a warning sign. It does not automatically mean a SIM swap occurred, but it deserves quick investigation.',
        ),
        LessonSection(
          title: 'Responding quickly',
          body:
              'Contact the mobile provider through an official channel and secure important accounts if you suspect unauthorized control of your number. Review account activity and use stronger account protections where available.',
        ),
      ],
      warningSigns: [
        'Your phone suddenly loses service without an obvious reason.',
        'Unexpected account-reset messages appear.',
        'You notice login or verification activity you did not initiate.',
        'Your mobile number stops receiving expected calls or messages.',
      ],
      scenario:
          'Your phone suddenly shows no network service. A short time later, you receive an email saying that a password-reset request was made for one of your accounts.',
      actions: [
        'Contact your mobile provider through an official channel.',
        'Secure important accounts using another trusted method where possible.',
        'Review recent account activity.',
        'Treat unexplained service loss seriously.',
      ],
      commonMistakes: [
        'Ignoring sudden service loss.',
        'Assuming all account alerts are harmless.',
        'Using a phone number as the only security layer for important accounts.',
      ],
      tips: [
        'Investigate unexpected loss of mobile service.',
        'Use multi-factor authentication where available.',
        'Keep important account recovery options secure.',
        'Monitor accounts for unusual activity.',
      ],
      takeaway:
          'Your phone number can be an important account-recovery tool, so sudden unexplained service loss deserves attention.',
      quizQuestions: [
        SecurityQuizQuestion(
          question: 'Which situation may be a warning sign of SIM swap fraud?',
          options: [
            'A normal text message.',
            'Sudden unexplained loss of mobile service.',
            'A routine phone call.',
            'A normal app notification.',
          ],
          correctIndex: 1,
          explanation:
              'Unexpected loss of service can be a warning sign that your number may no longer be under your control.',
        ),
        SecurityQuizQuestion(
          question:
              'What should you do if you suspect your number was taken over?',
          options: [
            'Wait several days.',
            'Contact your provider through an official channel.',
            'Send your PIN to a stranger.',
            'Ignore the issue.',
          ],
          correctIndex: 1,
          explanation:
              'The mobile provider is an important part of restoring control of the number.',
        ),
        SecurityQuizQuestion(
          question: 'Why can a SIM swap affect other accounts?',
          options: [
            'The attacker gets your physical laptop.',
            'Some accounts use the number for verification or recovery.',
            'SIM cards contain every password.',
            'SIM swaps automatically delete accounts.',
          ],
          correctIndex: 1,
          explanation:
              'Some account systems use phone numbers for verification or recovery.',
        ),
        SecurityQuizQuestion(
          question: 'What is a good broader protection strategy?',
          options: [
            'Use only your phone number.',
            'Use multiple security layers where available.',
            'Share account recovery codes publicly.',
            'Disable all security settings.',
          ],
          correctIndex: 1,
          explanation:
              'Multiple security layers reduce reliance on a single recovery method.',
        ),
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

    SecurityLesson(
      title: 'Online Shopping Scams',
      description:
          'Spot fake stores, unrealistic deals, copied product listings, and unsafe payment requests.',
      icon: Icons.shopping_cart_outlined,
      category: SecurityLessonCategory.scamsAndFraud,
      estimatedMinutes: 7,
      learningObjectives: [
        'Identify suspicious online stores and listings.',
        'Evaluate seller information before paying.',
        'Recognize pressure and unrealistic discounts.',
        'Choose safer payment and verification habits.',
      ],
      sections: [
        LessonSection(
          title: 'How fake stores attract buyers',
          body:
              'Fake stores often copy legitimate product images, create professional-looking pages, and advertise unusually low prices. Their goal is to make the offer feel too good to ignore.',
        ),
        LessonSection(
          title: 'The payment trap',
          body:
              'A seller may push you toward unusual payment methods or ask for money before providing enough information about the business. The more difficult it is to verify the seller, the more cautious you should be.',
        ),
        LessonSection(
          title: 'Look beyond the product',
          body:
              'A real-looking product page does not prove that the seller is trustworthy. Consider the business identity, contact information, independent reviews, website address, and payment process.',
        ),
        LessonSection(
          title: 'Before you buy',
          body:
              'Take time to research unfamiliar sellers. Avoid being rushed into a payment simply because the seller says the price or stock will disappear immediately.',
        ),
      ],
      warningSigns: [
        'Prices far below normal market prices.',
        'A seller pushes you to pay immediately.',
        'The business has little verifiable information.',
        'Payment is requested through unusual or untrusted channels.',
      ],
      scenario:
          'You find a phone online for half the price offered by other sellers. The seller says you must pay immediately through a personal number because other buyers are waiting.',
      actions: [
        'Research the seller independently.',
        'Compare the price with other reputable sellers.',
        'Verify the payment details before sending money.',
        'Avoid the purchase if the business cannot be reasonably verified.',
      ],
      commonMistakes: [
        'Assuming a low price means a great deal.',
        'Relying entirely on reviews displayed on the seller\'s own page.',
        'Ignoring unusual payment instructions.',
      ],
      tips: [
        'Research unfamiliar sellers.',
        'Check the website address carefully.',
        'Use safer and traceable payment methods where possible.',
        'Do not let urgency decide for you.',
      ],
      takeaway:
          'A good deal is not worth much if the seller cannot be independently verified.',
      quizQuestions: [
        SecurityQuizQuestion(
          question: 'Which combination should make you especially cautious?',
          options: [
            'A normal price and verified business.',
            'Very low price plus urgent payment request.',
            'A known store and standard checkout.',
            'A familiar product.',
          ],
          correctIndex: 1,
          explanation:
              'Unrealistic pricing combined with urgency is a common warning pattern.',
        ),
        SecurityQuizQuestion(
          question:
              'What should you research before buying from an unfamiliar seller?',
          options: [
            'Only the product photo.',
            'The seller and business information.',
            'Only the discount.',
            'Only the social-media follower count.',
          ],
          correctIndex: 1,
          explanation:
              'The seller itself needs to be verified, not just the product.',
        ),
        SecurityQuizQuestion(
          question: 'Why is urgency dangerous during online shopping?',
          options: [
            'It gives you more time to compare.',
            'It can discourage you from verifying the seller.',
            'It improves product quality.',
            'It guarantees stock.',
          ],
          correctIndex: 1,
          explanation: 'Pressure can make shoppers skip important checks.',
        ),
        SecurityQuizQuestion(
          question: 'What matters more than a seller\'s own claims?',
          options: [
            'Independent verification.',
            'A large emoji count.',
            'A dramatic sales message.',
            'A copied product photo.',
          ],
          correctIndex: 0,
          explanation:
              'Independent information provides stronger evidence than claims made by the seller.',
        ),
      ],
    ),

    SecurityLesson(
      title: 'Impersonation Scams',
      description:
          'Learn how attackers pretend to be trusted people, companies, support teams, or authorities.',
      icon: Icons.person_search_outlined,
      category: SecurityLessonCategory.scamsAndFraud,
      estimatedMinutes: 7,
      learningObjectives: [
        'Recognize common impersonation tactics.',
        'Understand why names and logos are not enough.',
        'Verify unusual requests independently.',
        'Avoid sharing sensitive information based on claimed authority.',
      ],
      sections: [
        LessonSection(
          title: 'What is impersonation?',
          body:
              'Impersonation scams happen when someone pretends to be a trusted person or organization in order to influence your actions. Attackers may copy names, photos, logos, email signatures, and language.',
        ),
        LessonSection(
          title: 'Authority and familiarity',
          body:
              'People are more likely to act when they believe a message comes from a bank, employer, government office, family member, or support team. Scammers use that sense of authority to reduce skepticism.',
        ),
        LessonSection(
          title: 'Verify the request, not just the identity',
          body:
              'Even if you believe the person is genuine, an unusual request should still be verified. Accounts can be compromised and identities can be copied.',
        ),
        LessonSection(
          title: 'Independent verification',
          body:
              'Use contact information you already trust or find independently. Do not simply call the number or open the link supplied in the suspicious message.',
        ),
      ],
      warningSigns: [
        'A trusted person suddenly asks for something unusual.',
        'The sender uses authority to pressure you.',
        'The request involves credentials or money.',
        'The message discourages independent verification.',
      ],
      scenario:
          'You receive an email that appears to be from your employer asking you to urgently purchase gift cards and send the codes because a client meeting is about to start.',
      actions: [
        'Do not purchase or send anything immediately.',
        'Verify the request through a known company contact.',
        'Check the actual sender address carefully.',
        'Report suspicious impersonation attempts to the relevant organization.',
      ],
      commonMistakes: [
        'Trusting a familiar logo.',
        'Assuming authority means legitimacy.',
        'Using the suspicious message itself to verify the request.',
      ],
      tips: [
        'Verify unusual requests independently.',
        'Do not rely on logos or profile photos alone.',
        'Treat sudden requests for money or credentials carefully.',
        'Pause when a trusted identity behaves unusually.',
      ],
      takeaway:
          'Identity can be copied. Unusual requests should always be verified independently.',
      quizQuestions: [
        SecurityQuizQuestion(
          question:
              'Which detail alone does not prove that a message is genuine?',
          options: [
            'A familiar logo.',
            'An independently verified request.',
            'A known official contact method.',
            'A normal transaction you expected.',
          ],
          correctIndex: 0,
          explanation: 'Logos and branding can be copied.',
        ),
        SecurityQuizQuestion(
          question:
              'What should you do with an unusual request from a trusted identity?',
          options: [
            'Obey immediately.',
            'Verify the request independently.',
            'Share your password.',
            'Forward it to everyone.',
          ],
          correctIndex: 1,
          explanation:
              'An identity can be copied or compromised, so the request itself should be verified.',
        ),
        SecurityQuizQuestion(
          question: 'Why can authority be used in scams?',
          options: [
            'People may be more likely to act without questioning.',
            'Authorities can never be impersonated.',
            'Authority removes all risk.',
            'Authority means payment is required.',
          ],
          correctIndex: 0,
          explanation: 'Perceived authority can reduce skepticism.',
        ),
        SecurityQuizQuestion(
          question: 'What is independent verification?',
          options: [
            'Using the same suspicious message to confirm itself.',
            'Checking with a trusted source you find separately.',
            'Asking the scammer twice.',
            'Clicking the link in the message.',
          ],
          correctIndex: 1,
          explanation:
              'Independent verification avoids relying on the suspicious source itself.',
        ),
      ],
    ),

    SecurityLesson(
      title: 'I Think I\'ve Been Scammed',
      description:
          'Learn what to do after you have sent money, shared information, clicked something suspicious, or interacted with a scammer.',
      icon: Icons.help_outline_rounded,
      category: SecurityLessonCategory.scamsAndFraud,
      estimatedMinutes: 8,
      learningObjectives: [
        'Stop further loss or exposure.',
        'Secure affected accounts.',
        'Preserve useful evidence.',
        'Know when and how to report the incident.',
      ],
      sections: [
        LessonSection(
          title: 'First: stop the situation',
          body:
              'If you realize that something may be a scam, stop sending additional money or information. Be especially careful of people who claim they can recover your money if you pay another fee.',
        ),
        LessonSection(
          title: 'Second: secure what may be affected',
          body:
              'Change passwords that may have been exposed, review account activity, and contact the relevant provider using official contact information. If payment information may have been compromised, contact the relevant financial or mobile-money provider promptly.',
        ),
        LessonSection(
          title: 'Third: preserve evidence',
          body:
              'Keep screenshots, messages, phone numbers, usernames, links, transaction details, receipts, and other information that may help explain what happened. Avoid deleting important evidence before recording it.',
        ),
        LessonSection(
          title: 'Fourth: report',
          body:
              'Reporting can help document the incident and may help others recognize similar scams. Sentri provides a Report Crime feature where you can record the details of a cybercrime incident.',
        ),
      ],
      warningSigns: [
        'The person asks for more money to fix the problem.',
        'You notice unauthorized account activity.',
        'You shared a password or verification code.',
        'You discover that a payment or transaction was fraudulent.',
      ],
      scenario:
          'You entered your password into a suspicious website and then realized that the page was fake. You are now receiving unusual login notifications.',
      actions: [
        'Change the affected password immediately.',
        'Review account activity and secure related accounts if necessary.',
        'Preserve screenshots and suspicious URLs.',
        'Report the incident using appropriate official channels.',
      ],
      commonMistakes: [
        'Sending more money to a supposed recovery service.',
        'Deleting all evidence immediately.',
        'Ignoring unusual account activity.',
        'Using the same compromised password elsewhere.',
      ],
      tips: [
        'Act quickly but calmly.',
        'Change exposed credentials.',
        'Preserve evidence.',
        'Report suspicious activity.',
      ],
      takeaway:
          'After a scam, the goal is not to undo the past instantly. It is to stop further harm, secure what you can, preserve evidence, and report.',
      quizQuestions: [
        SecurityQuizQuestion(
          question:
              'What should you do first after realizing a scam may be happening?',
          options: [
            'Send more money to fix it.',
            'Stop sending money or information.',
            'Delete every message.',
            'Ignore the situation.',
          ],
          correctIndex: 1,
          explanation:
              'Stopping further communication or payments can prevent additional loss.',
        ),
        SecurityQuizQuestion(
          question: 'What should you preserve?',
          options: [
            'Only your memory of the event.',
            'Screenshots, messages, transaction information, and other evidence.',
            'Nothing.',
            'Only the scammer\'s profile picture.',
          ],
          correctIndex: 1,
          explanation:
              'Evidence can be useful when investigating or reporting the incident.',
        ),
        SecurityQuizQuestion(
          question:
              'If a password was exposed, what should you consider doing?',
          options: [
            'Continue using it.',
            'Change it and review related accounts.',
            'Share it with support.',
            'Post it online to warn others.',
          ],
          correctIndex: 1,
          explanation:
              'Changing exposed credentials reduces the chance of continued unauthorized access.',
        ),
        SecurityQuizQuestion(
          question: 'What is one purpose of Sentri\'s Report Crime feature?',
          options: [
            'To send money to scammers.',
            'To record details of cybercrime incidents.',
            'To recover every stolen payment automatically.',
            'To identify the scammer with certainty.',
          ],
          correctIndex: 1,
          explanation:
              'Sentri provides a place to record cybercrime incidents and preserve the report details.',
        ),
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

    // ============================================================
    // ACCOUNT & DEVICE SAFETY
    // ============================================================

    SecurityLesson(
      title: 'Password Safety',
      description:
          'Build stronger password habits, understand password reuse, and learn how to make account access harder to compromise.',
      icon: Icons.lock_outline,
      category: SecurityLessonCategory.accountAndDeviceSafety,
      estimatedMinutes: 7,
      learningObjectives: [
        'Understand what makes a password stronger.',
        'Recognize the danger of password reuse.',
        'Use unique passwords for important accounts.',
        'Understand the role of password managers.',
      ],
      sections: [
        LessonSection(
          title: 'What makes a password stronger?',
          body:
              'Strong passwords are difficult to guess and are not based on information that is easy for others to know about you. Length and uniqueness are especially important.',
        ),
        LessonSection(
          title: 'The problem with reuse',
          body:
              'Using one password across many accounts creates a chain reaction risk. If one service suffers a password exposure, attackers may try the same password on your other accounts.',
        ),
        LessonSection(
          title: 'Passphrases and unique credentials',
          body:
              'Longer phrases can be easier to remember while still being difficult to guess. Important accounts should use credentials that are not reused elsewhere.',
        ),
        LessonSection(
          title: 'Password managers',
          body:
              'A password manager can help generate and store unique passwords so you do not have to memorize every credential yourself.',
        ),
      ],
      warningSigns: [
        'The same password is used everywhere.',
        'Passwords are based on birthdays, names, or phone numbers.',
        'Important accounts use short or predictable passwords.',
        'Passwords are written or stored somewhere insecure.',
      ],
      scenario:
          'You have used the same password for your email, social media, and shopping account for several years because it is easy to remember.',
      actions: [
        'Start with your most important accounts.',
        'Give each important account a unique password.',
        'Consider using a trusted password manager.',
        'Enable additional account protection where available.',
      ],
      commonMistakes: [
        'Changing one character every time and reusing the pattern.',
        'Using personal information as the password.',
        'Reusing the same password because it is easier to remember.',
      ],
      tips: [
        'Use long, unique passwords.',
        'Prioritize email and financial accounts.',
        'Never share passwords casually.',
        'Use a password manager if helpful.',
      ],
      takeaway:
          'A password is strongest when it is long, unique, and not based on information others can easily guess.',
      quizQuestions: [
        SecurityQuizQuestion(
          question: 'Why is password reuse dangerous?',
          options: [
            'It makes passwords longer.',
            'One exposed password can put multiple accounts at risk.',
            'It automatically deletes accounts.',
            'It improves account security.',
          ],
          correctIndex: 1,
          explanation:
              'Attackers may try an exposed password on other services.',
        ),
        SecurityQuizQuestion(
          question: 'Which is generally a better password habit?',
          options: [
            'Use one password everywhere.',
            'Use unique passwords for important accounts.',
            'Use your birthday.',
            'Use your phone number.',
          ],
          correctIndex: 1,
          explanation:
              'Unique credentials reduce the impact of a single password exposure.',
        ),
        SecurityQuizQuestion(
          question: 'What can a password manager help with?',
          options: [
            'Generating and storing unique passwords.',
            'Removing all cyber risks.',
            'Giving your password to strangers.',
            'Disabling account security.',
          ],
          correctIndex: 0,
          explanation:
              'Password managers help users handle multiple unique credentials more easily.',
        ),
        SecurityQuizQuestion(
          question: 'Which information is best avoided in a password?',
          options: [
            'Random characters.',
            'A long unique phrase.',
            'Your birthday and name.',
            'A unique generated password.',
          ],
          correctIndex: 2,
          explanation:
              'Personal information can be easier for attackers to guess.',
        ),
      ],
    ),

    SecurityLesson(
      title: 'Two-Factor Authentication',
      description:
          'Understand how an additional verification step can reduce the risk of account takeover.',
      icon: Icons.verified_user_outlined,
      category: SecurityLessonCategory.accountAndDeviceSafety,
      estimatedMinutes: 6,
      learningObjectives: [
        'Understand what two-factor authentication adds.',
        'Protect verification codes.',
        'Use stronger account protection where available.',
        'Keep backup recovery methods secure.',
      ],
      sections: [
        LessonSection(
          title: 'Why one password is not always enough',
          body:
              'Passwords can be exposed through phishing, reused-password attacks, or other mistakes. An additional verification step can create another barrier to unauthorized access.',
        ),
        LessonSection(
          title: 'How the second step works',
          body:
              'Depending on the service, the second step may involve an authentication app, a security key, a code, or another verification method. The exact options vary by service.',
        ),
        LessonSection(
          title: 'Verification codes are sensitive',
          body:
              'A verification code may be the final step needed to enter an account. Someone who asks you to share a code may be trying to complete an unauthorized login.',
        ),
        LessonSection(
          title: 'Recovery matters too',
          body:
              'Account security is not only about login. Keep backup codes and recovery methods protected so they do not become an easier path into the account.',
        ),
      ],
      warningSigns: [
        'Someone asks for a login verification code.',
        'You receive a code for a login you did not initiate.',
        'Recovery information is exposed or outdated.',
        'Important accounts have no additional protection.',
      ],
      scenario:
          'You receive a verification code by SMS even though you are not trying to sign in. A few seconds later, someone messages asking you to send them the code.',
      actions: [
        'Do not share the code.',
        'Change your password if the login was not yours.',
        'Review account security activity.',
        'Use stronger authentication methods where available.',
      ],
      commonMistakes: [
        'Treating a verification code as harmless.',
        'Sharing codes with people claiming to be support.',
        'Ignoring unexpected login codes.',
      ],
      tips: [
        'Never share verification codes.',
        'Enable additional authentication on important accounts.',
        'Protect recovery methods.',
        'Investigate unexpected login attempts.',
      ],
      takeaway:
          'A verification code is part of your account security. Treat it like a key, not like an ordinary message.',
      quizQuestions: [
        SecurityQuizQuestion(
          question: 'What is the main purpose of two-factor authentication?',
          options: [
            'To remove passwords.',
            'To add another verification layer.',
            'To make accounts public.',
            'To disable recovery.',
          ],
          correctIndex: 1,
          explanation:
              'Two-factor authentication adds an extra layer beyond the password.',
        ),
        SecurityQuizQuestion(
          question:
              'Someone asks you for a login verification code. What should you do?',
          options: [
            'Share it if they sound professional.',
            'Never share it.',
            'Post it online.',
            'Send half of it.',
          ],
          correctIndex: 1,
          explanation:
              'A verification code can be used to complete account access.',
        ),
        SecurityQuizQuestion(
          question: 'What does an unexpected login code potentially indicate?',
          options: [
            'Nothing.',
            'Someone may be trying to sign in.',
            'Your phone is broken.',
            'Your password became stronger.',
          ],
          correctIndex: 1,
          explanation:
              'An unexpected code can indicate that someone initiated an authentication attempt.',
        ),
        SecurityQuizQuestion(
          question: 'What should also be protected besides your password?',
          options: [
            'Recovery methods and backup codes.',
            'Only your profile picture.',
            'Only public posts.',
            'Nothing else.',
          ],
          correctIndex: 0,
          explanation:
              'Recovery methods can provide another route into an account.',
        ),
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

    SecurityLesson(
      title: 'Device Security',
      description:
          'Build practical habits for protecting your phone, computer, applications, and personal information.',
      icon: Icons.devices_outlined,
      category: SecurityLessonCategory.accountAndDeviceSafety,
      estimatedMinutes: 6,
      learningObjectives: [
        'Understand why device security matters.',
        'Keep devices and apps updated.',
        'Use a strong screen lock.',
        'Review permissions and software sources.',
      ],
      sections: [
        LessonSection(
          title: 'Why your device matters',
          body:
              'A phone or computer can contain private conversations, photographs, documents, account sessions, and financial applications. Protecting the device protects many different parts of your digital life at once.',
        ),
        LessonSection(
          title: 'Updates are part of security',
          body:
              'Operating-system and app updates can include security fixes. Delaying updates for long periods can leave known weaknesses unpatched.',
        ),
        LessonSection(
          title: 'Locking the device',
          body:
              'A strong screen lock creates a barrier if your device is lost or accessed by someone else. Avoid using easily guessed codes.',
        ),
        LessonSection(
          title: 'Apps and permissions',
          body:
              'Install software from trusted sources and review the permissions apps request. An app requesting access unrelated to its purpose deserves closer attention.',
        ),
      ],
      warningSigns: [
        'Important updates are repeatedly ignored.',
        'The device has no meaningful screen lock.',
        'Apps are installed from unknown sources.',
        'Applications have excessive or unnecessary permissions.',
      ],
      scenario:
          'A newly installed app asks for access to your contacts, microphone, storage, and location even though its purpose does not seem to require them.',
      actions: [
        'Review whether those permissions are necessary.',
        'Check the app source and reputation.',
        'Remove unnecessary permissions.',
        'Uninstall software you do not trust.',
      ],
      commonMistakes: [
        'Granting every permission automatically.',
        'Installing apps from unknown sources.',
        'Ignoring device updates indefinitely.',
      ],
      tips: [
        'Keep devices updated.',
        'Use a strong screen lock.',
        'Review app permissions.',
        'Install software from trusted sources.',
      ],
      takeaway:
          'Good device security is mostly about consistent small habits: updates, strong locks, careful installation, and permission awareness.',
      quizQuestions: [
        SecurityQuizQuestion(
          question: 'Why are device updates important?',
          options: [
            'They only change wallpapers.',
            'They can include security fixes.',
            'They remove all apps.',
            'They always slow the device.',
          ],
          correctIndex: 1,
          explanation:
              'Updates may include fixes for security vulnerabilities.',
        ),
        SecurityQuizQuestion(
          question:
              'What should you do when an app asks for unrelated permissions?',
          options: [
            'Grant everything immediately.',
            'Review whether the permissions are necessary.',
            'Share your password.',
            'Ignore the app completely without checking.',
          ],
          correctIndex: 1,
          explanation:
              'Permissions should make sense for what the app is supposed to do.',
        ),
        SecurityQuizQuestion(
          question: 'What does a screen lock help protect?',
          options: [
            'Only the wallpaper.',
            'Access to information on the device.',
            'The internet itself.',
            'All online accounts automatically.',
          ],
          correctIndex: 1,
          explanation:
              'A screen lock is a first layer of protection against unauthorized physical access.',
        ),
        SecurityQuizQuestion(
          question: 'Where should software preferably come from?',
          options: [
            'Unknown files shared by strangers.',
            'Trusted official sources.',
            'Random pop-ups.',
            'Any website that promises free downloads.',
          ],
          correctIndex: 1,
          explanation:
              'Trusted sources reduce the risk of installing malicious or modified software.',
        ),
      ],
    ),

    SecurityLesson(
      title: 'Privacy & Personal Information',
      description:
          'Learn how oversharing personal information can increase your exposure to scams, impersonation, and targeted manipulation.',
      icon: Icons.privacy_tip_outlined,
      category: SecurityLessonCategory.accountAndDeviceSafety,
      estimatedMinutes: 6,
      learningObjectives: [
        'Recognize sensitive personal information.',
        'Reduce unnecessary public exposure.',
        'Review privacy settings.',
        'Think carefully before sharing information with unfamiliar services.',
      ],
      sections: [
        LessonSection(
          title: 'Why personal information matters',
          body:
              'Names, phone numbers, locations, identification details, workplaces, and other information can help someone build a more convincing scam or impersonation attempt.',
        ),
        LessonSection(
          title: 'Oversharing creates clues',
          body:
              'Individual details may look harmless, but several public details can be combined. Attackers may use them to guess security questions, create believable stories, or target specific people.',
        ),
        LessonSection(
          title: 'Public does not mean necessary',
          body:
              'Not every service needs every piece of information. Before providing personal information, consider what the service needs and whether the request is legitimate.',
        ),
        LessonSection(
          title: 'Privacy settings',
          body:
              'Review who can see your posts, profile information, location, and contact details. Privacy is an ongoing habit rather than a single setting.',
        ),
      ],
      warningSigns: [
        'A service asks for information unrelated to its purpose.',
        'Sensitive information is publicly visible.',
        'You receive targeted messages based on details you shared.',
        'Privacy settings have never been reviewed.',
      ],
      scenario:
          'You post a photo that publicly shows your full name, workplace, phone number, and a document containing additional identifying information.',
      actions: [
        'Remove unnecessary sensitive information.',
        'Review account privacy settings.',
        'Avoid posting identity or financial details publicly.',
        'Think about what information an unknown person could learn from your profile.',
      ],
      commonMistakes: [
        'Posting sensitive documents publicly.',
        'Sharing location in real time without thinking about the audience.',
        'Giving unfamiliar services more information than they actually need.',
      ],
      tips: [
        'Share only what is necessary.',
        'Review privacy settings regularly.',
        'Treat identity information carefully.',
        'Consider how separate pieces of information can be combined.',
      ],
      takeaway:
          'Privacy is about reducing unnecessary exposure. The less sensitive information you make publicly available, the fewer clues attackers have to work with.',
      quizQuestions: [
        SecurityQuizQuestion(
          question:
              'Why can small pieces of public information be risky together?',
          options: [
            'They disappear automatically.',
            'They can be combined into a more complete profile.',
            'They make your account stronger.',
            'They cannot be copied.',
          ],
          correctIndex: 1,
          explanation:
              'Attackers can combine information from different sources.',
        ),
        SecurityQuizQuestion(
          question:
              'What should you consider before giving information to a service?',
          options: [
            'Whether the information is necessary and the request is legitimate.',
            'Whether the form is colorful.',
            'Whether the service asks urgently.',
            'Whether other people shared theirs.',
          ],
          correctIndex: 0,
          explanation: 'Data minimization reduces unnecessary exposure.',
        ),
        SecurityQuizQuestion(
          question: 'What should privacy settings be treated as?',
          options: [
            'Something you never need to revisit.',
            'An ongoing part of digital safety.',
            'A replacement for passwords.',
            'Something only businesses need.',
          ],
          correctIndex: 1,
          explanation: 'Services and sharing habits change over time.',
        ),
        SecurityQuizQuestion(
          question: 'Which is especially important not to post publicly?',
          options: [
            'A favorite color.',
            'Sensitive identity or financial information.',
            'A general hobby.',
            'A public website.',
          ],
          correctIndex: 1,
          explanation:
              'Sensitive information can be exploited for fraud or impersonation.',
        ),
      ],
    ),

    // ============================================================
    // ONLINE AWARENESS
    // ============================================================

    SecurityLesson(
      title: 'Phishing Awareness',
      description:
          'Learn how phishing messages and fake websites try to steal information or trigger unsafe actions.',
      icon: Icons.phishing_outlined,
      category: SecurityLessonCategory.onlineAwareness,
      estimatedMinutes: 8,
      learningObjectives: [
        'Recognize common phishing indicators.',
        'Inspect links and sender information carefully.',
        'Understand urgency and impersonation tactics.',
        'Know what to do with suspicious messages.',
      ],
      sections: [
        LessonSection(
          title: 'What is phishing?',
          body:
              'Phishing is a social-engineering technique used to trick people into revealing information, clicking links, opening files, or taking another unsafe action. The message may pretend to come from a bank, school, employer, social platform, delivery service, or other trusted organization.',
        ),
        LessonSection(
          title: 'The fake login page',
          body:
              'One common technique is sending a link to a page that looks like a legitimate login page. The page may collect the username and password even though it is not the real service.',
        ),
        LessonSection(
          title: 'Read beyond the appearance',
          body:
              'Look carefully at the sender, website address, wording, unexpected urgency, and what the message asks you to do. A professional appearance does not guarantee legitimacy.',
        ),
        LessonSection(
          title: 'The safest response',
          body:
              'Do not enter sensitive information through an unexpected link. Instead, open the official service directly using a trusted route and check whether the claimed problem actually exists.',
        ),
      ],
      warningSigns: [
        'Unexpected requests to log in or verify an account.',
        'Links leading to unfamiliar or unusual addresses.',
        'Urgent threats about account closure or suspension.',
        'Requests for passwords, verification codes, or financial details.',
      ],
      scenario:
          'You receive a message saying your bank account will be suspended unless you verify your information within 30 minutes. A link is provided to "secure your account".',
      actions: [
        'Do not open the link.',
        'Visit the bank using its official app or website.',
        'Check whether the claimed issue exists.',
        'Report or delete the suspicious message as appropriate.',
      ],
      commonMistakes: [
        'Clicking the link before checking the message.',
        'Trusting a page because it looks like the real site.',
        'Entering passwords into unexpected links.',
      ],
      tips: [
        'Inspect links carefully.',
        'Do not act on unexpected account warnings.',
        'Use official apps or websites directly.',
        'Never share passwords or verification codes.',
      ],
      takeaway:
          'Phishing often works because the message looks believable. Your safest habit is to verify the situation outside the suspicious message.',
      quizQuestions: [
        SecurityQuizQuestion(
          question: 'What is phishing primarily designed to do?',
          options: [
            'Improve your internet speed.',
            'Trick you into taking an unsafe action.',
            'Update your device.',
            'Create a backup.',
          ],
          correctIndex: 1,
          explanation:
              'Phishing uses deception to make people reveal information or perform risky actions.',
        ),
        SecurityQuizQuestion(
          question: 'What should you do with an unexpected bank login link?',
          options: [
            'Click it immediately.',
            'Open the bank using its official app or site.',
            'Enter your password to test it.',
            'Forward it to friends.',
          ],
          correctIndex: 1,
          explanation:
              'Going directly to the legitimate service avoids relying on the suspicious link.',
        ),
        SecurityQuizQuestion(
          question: 'What is one common phishing tactic?',
          options: [
            'Urgency.',
            'Long holidays.',
            'Automatic backups.',
            'Offline storage.',
          ],
          correctIndex: 0,
          explanation:
              'Urgency is commonly used to push people into acting without checking.',
        ),
        SecurityQuizQuestion(
          question: 'What should you avoid entering into a suspicious page?',
          options: [
            'Public information.',
            'Passwords and other sensitive credentials.',
            'A general question.',
            'A public website address.',
          ],
          correctIndex: 1,
          explanation:
              'Suspicious pages may be designed specifically to capture credentials.',
        ),
      ],
    ),

    SecurityLesson(
      title: 'Social Engineering',
      description:
          'Understand the psychological tactics attackers use to manipulate people into unsafe decisions.',
      icon: Icons.psychology_outlined,
      category: SecurityLessonCategory.onlineAwareness,
      estimatedMinutes: 7,
      learningObjectives: [
        'Recognize manipulation tactics.',
        'Identify pressure, authority, fear, and curiosity triggers.',
        'Use safer decision-making habits.',
        'Know when to pause and verify.',
      ],
      sections: [
        LessonSection(
          title: 'People can be the target',
          body:
              'Social engineering attacks target human decisions rather than only technical systems. An attacker may try to convince someone to reveal information, approve a request, transfer money, or grant access.',
        ),
        LessonSection(
          title: 'Common psychological triggers',
          body:
              'Attackers may use authority, fear, urgency, curiosity, familiarity, or helpfulness. The aim is often to make the requested action feel natural before the target has time to question it.',
        ),
        LessonSection(
          title: 'Why slowing down works',
          body:
              'Many social-engineering attempts depend on speed. Taking a short pause creates room to ask whether the request makes sense and whether it can be verified.',
        ),
        LessonSection(
          title: 'Build a verification habit',
          body:
              'When a request involves money, credentials, access, or something unusual, verify it through a trusted route before acting.',
        ),
      ],
      warningSigns: [
        'The person uses authority to pressure you.',
        'The request creates fear or panic.',
        'The sender insists you cannot verify the request.',
        'You are asked to break normal procedures.',
      ],
      scenario:
          'Someone claiming to be a manager tells you to ignore the usual process and urgently send confidential information because senior leadership needs it immediately.',
      actions: [
        'Pause before acting.',
        'Follow normal verification procedures.',
        'Confirm the request with another trusted person or channel.',
        'Do not let authority replace security checks.',
      ],
      commonMistakes: [
        'Assuming a senior person does not need verification.',
        'Skipping normal procedures under pressure.',
        'Making a decision while afraid or rushed.',
      ],
      tips: [
        'Pause when pressure rises.',
        'Verify unusual requests.',
        'Follow established procedures.',
        'Do not let authority override caution.',
      ],
      takeaway:
          'Social engineering succeeds when emotions override verification. Slowing down is one of the simplest defenses.',
      quizQuestions: [
        SecurityQuizQuestion(
          question: 'What does social engineering primarily target?',
          options: [
            'Only hardware.',
            'Human behavior and decisions.',
            'Internet cables.',
            'Battery life.',
          ],
          correctIndex: 1,
          explanation:
              'Social engineering manipulates people into making unsafe decisions.',
        ),
        SecurityQuizQuestion(
          question: 'Which emotion can be used to pressure a target?',
          options: [
            'Fear.',
            'Only happiness.',
            'Only boredom.',
            'None.',
          ],
          correctIndex: 0,
          explanation:
              'Fear, urgency, authority, curiosity, and familiarity are common psychological triggers.',
        ),
        SecurityQuizQuestion(
          question: 'What is one useful defense?',
          options: [
            'Act faster.',
            'Pause and verify.',
            'Skip normal procedures.',
            'Trust authority automatically.',
          ],
          correctIndex: 1,
          explanation: 'A pause creates room for verification.',
        ),
        SecurityQuizQuestion(
          question: 'Should authority remove the need for security checks?',
          options: [
            'Yes.',
            'No.',
            'Only online.',
            'Only on weekends.',
          ],
          correctIndex: 1,
          explanation:
              'Unusual requests should still be verified regardless of who appears to be making them.',
        ),
      ],
    ),

    SecurityLesson(
      title: 'Safe Browsing',
      description:
          'Build safer habits when visiting websites, downloading files, and entering sensitive information online.',
      icon: Icons.language_outlined,
      category: SecurityLessonCategory.onlineAwareness,
      estimatedMinutes: 6,
      learningObjectives: [
        'Check website addresses more carefully.',
        'Understand why trusted sources matter.',
        'Think before downloading files.',
        'Protect sensitive information while browsing.',
      ],
      sections: [
        LessonSection(
          title: 'A website is not automatically trustworthy',
          body:
              'A website can look professional and still be unsafe. Pay attention to the address, how you reached the site, what information it requests, and whether the request makes sense.',
        ),
        LessonSection(
          title: 'Links can mislead',
          body:
              'A message may display one description while sending you somewhere unexpected. Be cautious with shortened links, unfamiliar domains, and links received unexpectedly.',
        ),
        LessonSection(
          title: 'Downloads require judgment',
          body:
              'Files from unknown sources can introduce unwanted or malicious software. Avoid downloading files simply because a website or message tells you to do so.',
        ),
        LessonSection(
          title: 'Before entering sensitive information',
          body:
              'Check that you are using the intended website and that the request is legitimate. For important accounts, it is often safer to navigate to the service directly rather than following an unexpected link.',
        ),
      ],
      warningSigns: [
        'A website address looks unfamiliar or unusual.',
        'A file download appears unexpectedly.',
        'A website requests sensitive information without a clear reason.',
        'The page uses urgent or alarming language.',
      ],
      scenario:
          'A pop-up says your device is infected and instructs you to download a security tool immediately from the displayed website.',
      actions: [
        'Do not download the unexpected file.',
        'Close the suspicious page or tab.',
        'Use trusted security software or official support resources if you are concerned.',
        'Visit the official source directly when looking for software.',
      ],
      commonMistakes: [
        'Downloading software from random pop-ups.',
        'Assuming a professional website must be legitimate.',
        'Entering credentials through unexpected links.',
      ],
      tips: [
        'Check website addresses.',
        'Download software from trusted sources.',
        'Avoid suspicious pop-ups.',
        'Navigate directly to important services.',
      ],
      takeaway:
          'Safe browsing is largely about knowing where you are, how you got there, and whether the request makes sense.',
      quizQuestions: [
        SecurityQuizQuestion(
          question:
              'What should you do with an unexpected software download pop-up?',
          options: [
            'Install it immediately.',
            'Close it and use a trusted source instead.',
            'Share it with friends.',
            'Enter your password first.',
          ],
          correctIndex: 1,
          explanation: 'Unexpected downloads should be treated cautiously.',
        ),
        SecurityQuizQuestion(
          question: 'Why check the website address?',
          options: [
            'To make the page load faster.',
            'To confirm you are visiting the intended site.',
            'To increase battery life.',
            'To remove advertisements.',
          ],
          correctIndex: 1,
          explanation:
              'Attackers can create websites that resemble legitimate services.',
        ),
        SecurityQuizQuestion(
          question: 'What is often safer for an important account?',
          options: [
            'Use an unexpected login link.',
            'Navigate to the official service directly.',
            'Use any search result without checking.',
            'Follow pop-ups.',
          ],
          correctIndex: 1,
          explanation:
              'Direct navigation reduces reliance on suspicious links.',
        ),
        SecurityQuizQuestion(
          question: 'What should make a download more suspicious?',
          options: [
            'It came from an official source.',
            'It appears unexpectedly and urges immediate action.',
            'You intentionally downloaded it from a trusted source.',
            'It is an expected update.',
          ],
          correctIndex: 1,
          explanation:
              'Unexpected and urgent downloads can be a sign of deception.',
        ),
      ],
    ),

    SecurityLesson(
      title: 'Safe Social Media',
      description:
          'Protect your privacy, recognize social-media scams, and think carefully about what you share publicly.',
      icon: Icons.people_outline,
      category: SecurityLessonCategory.onlineAwareness,
      estimatedMinutes: 6,
      learningObjectives: [
        'Reduce unnecessary public exposure.',
        'Recognize suspicious social-media messages.',
        'Verify giveaways and offers.',
        'Protect account credentials and privacy settings.',
      ],
      sections: [
        LessonSection(
          title: 'What your profile can reveal',
          body:
              'Social-media profiles can reveal names, workplaces, relationships, routines, locations, birthdays, and other clues. Attackers may use this information to create targeted scams or impersonation attempts.',
        ),
        LessonSection(
          title: 'Fake profiles and giveaways',
          body:
              'Scammers may create fake accounts that imitate businesses, influencers, friends, or public figures. They may then promote fake giveaways, investment opportunities, jobs, or links.',
        ),
        LessonSection(
          title: 'Direct messages deserve caution',
          body:
              'A friendly message is not automatically safe. Be careful with unexpected requests for money, personal information, or links, particularly from accounts you do not know well.',
        ),
        LessonSection(
          title: 'Control your audience',
          body:
              'Review privacy settings and think about who actually needs access to your posts and profile information. Not everything needs to be public.',
        ),
      ],
      warningSigns: [
        'An unfamiliar account offers an unusually valuable prize.',
        'A profile asks you to pay a fee to claim a reward.',
        'Someone requests private information through a direct message.',
        'A suspicious account copies a known person or business.',
      ],
      scenario:
          'An account that appears to belong to a popular brand messages you saying you have won a prize. You are asked to click a link and pay a small delivery fee.',
      actions: [
        'Do not click the link immediately.',
        'Check the official brand account or website independently.',
        'Do not pay a fee simply to claim an unexpected prize.',
        'Report suspicious accounts or messages.',
      ],
      commonMistakes: [
        'Trusting verified-looking branding alone.',
        'Posting too much personal information publicly.',
        'Paying small fees for unexpected prizes.',
      ],
      tips: [
        'Review privacy settings.',
        'Verify giveaways independently.',
        'Be careful with unexpected direct messages.',
        'Protect your account credentials.',
      ],
      takeaway:
          'Social media can make scams feel personal. Keep control of your information and verify unexpected offers independently.',
      quizQuestions: [
        SecurityQuizQuestion(
          question: 'What is a common social-media scam tactic?',
          options: [
            'An unexpected prize requiring payment.',
            'A normal post from a friend.',
            'A personal photo.',
            'A public hobby.',
          ],
          correctIndex: 0,
          explanation:
              'Unexpected prizes combined with payment requests are common warning signs.',
        ),
        SecurityQuizQuestion(
          question: 'What should you do before trusting a giveaway?',
          options: [
            'Pay immediately.',
            'Verify it through the official account or website.',
            'Send your password.',
            'Share it widely.',
          ],
          correctIndex: 1,
          explanation:
              'Independent verification can distinguish real promotions from impersonation scams.',
        ),
        SecurityQuizQuestion(
          question: 'Why review social-media privacy settings?',
          options: [
            'To expose more information.',
            'To control who can access your information.',
            'To improve battery life.',
            'To guarantee no scam will ever happen.',
          ],
          correctIndex: 1,
          explanation: 'Privacy settings help reduce unnecessary exposure.',
        ),
        SecurityQuizQuestion(
          question:
              'Should a copied logo automatically make an account trustworthy?',
          options: [
            'Yes.',
            'No.',
            'Only on weekends.',
            'Only if the message is urgent.',
          ],
          correctIndex: 1,
          explanation: 'Branding can be copied by scammers.',
        ),
      ],
    ),
  ];
}
