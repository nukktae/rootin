import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appTitle': 'Rootin',
      'home': 'Home',
      'settings': 'Settings',
      'profile': 'Profile',
      'notifications': 'Notifications',
      'search': 'Search',
      'camera': 'Camera',
      'gallery': 'Gallery',
      'save': 'Save',
      'cancel': 'Cancel',
      'language': 'Language',
      'selectLanguage': 'Select Language',
      'myPage': 'My Page',
      'appGuide': 'App Guide',
      'shopSensor': 'Shop Sensor',
      'sensorSettings': 'Sensor Settings',
      'help': 'Help',
      'privacyPolicy': 'Privacy Policy',
      'termsOfService': 'Terms of Service',
      'couldNotOpenWebsite': 'Could not open website',
      'allLocations': 'All Locations',
      'livingroom': 'Livingroom',
      'bedroom': 'Bedroom',
      'office': 'Office',
      'porch': 'Porch',
      'allRooms': 'All Rooms',
      'locations': 'Locations',
      'rooms': 'Rooms',
      'done': 'Done',
      'todaysWatering': "Today's watering",
      'myPlants': 'My plants',
      'tryToAddPlant': 'Try to add a plant!',
      'today': 'Today',
      'upcoming': 'Upcoming',
      'in': 'In',
      'todo': 'To-Do',
      'underwater': 'Underwater',
      'inProgress': 'In progress',
      'measuring': 'Measuring',
      'ideal': 'Ideal',
      'movesToHistory': 'Moves to history in 24 hours.',
      'sendMeNotifications': 'Send me Notifications',
      'wateringReminders': 'Watering Reminders',
      'underwaterReminder': 'Underwater Reminder',
      'measuringReminder': 'Measuring Reminder',
      'idealReminder': 'Ideal Reminder',
      'overwaterReminder': 'Overwater Reminder',
      'waterloggedReminder': 'Water-logged Reminder',
      'overallTips': 'Overall Tips',
      'difficulty': 'Difficulty',
      'watering': 'Watering',
      'light': 'Light',
      'soilType': 'Soil Type',
      'repotting': 'Repotting',
      'toxicity': 'Toxicity',
      'overview': 'Overview',
      'soilMoistureUpdates': 'Soil moisture updates every minute for real-time care!',
      'currentSoilMoisture': 'Current\nSoil Moisture',
      'upcomingWatering': 'Upcoming\nWatering',
      'daysLater': 'days later',
      'unknown': 'Unknown',
      'overwatered': 'Overwatered',
      'upcomingWateringInfo': 'Upcoming Watering Information',
      'upcomingWateringDesc': 'The upcoming watering section shows how many days until the next scheduled watering for optimal plant care.',
      'plant': 'plant',
      'plants': 'plants',
      'waitingToBeWatered': 'waiting to be watered',
      'checkYourWatering': 'Check your watering',
      'backToIdeal': 'Back to Ideal!',
      'dryingOut': 'Drying Out!',
      'waterloggedIssue': 'Water-logged issue!',
      'statusUnknown': 'Status Unknown',
      'plantLivelyAgain': 'Nice job! Your plant looks lively again.',
      'waterToIdeal': 'Water your plant to bring it back to ideal moisture.',
      'notifyWhenComplete': 'Notify you as soon as the measurement is complete!',
      'insufficientDrainage': 'Drainage hasn\'t been sufficient for the past 3 days.',
      'tooMuchWater': 'Your plant has too much water. Let it dry out a bit.',
      'noDetailsAvailable': 'No details available.',
      'goToWatering': 'Go to watering',
      'checkInstructions': 'Check instructions',
      'learnMore': 'Learn more',
      'askChatbot': 'Ask our Chatbot and resolve your curiosities.',
      'goToChatbot': 'Go to Chatbot',
      'soilMoisture': 'Soil Moisture',
      'idealRange': 'Ideal Range (30-70%)',
      'weeklyTrends': 'Weekly trends',
      'needHelpWith': 'Need help with your {plantName}?',
      'identifyPlantFirst': 'Identify your plant first',
      'searchByNameOrImage': 'Search by plant name or use an image to identify.',
      'identifiedPlant': 'Identified Plant',
      'scientificName': 'Scientific Name',
      'addPlant': 'Add Plant',
      'retakePhoto': 'Retake Photo',
      'failedToIdentify': 'Failed to identify plant',
      'searchAgain': 'Search again',
      'whichOneToAdd': 'Which one to add?',
      'nameYourPlant': 'Name your plant!',
      'nameWithinCharacters': 'Name within 20 characters',
      'plantNickname': 'Plant Nickname',
      'continue': 'Continue',
      'chooseSite': 'Choose site of the plant',
      'selectSiteOrCustom': 'Select a site or add a custom option.',
      'addYourOwn': '+ Add your own',
      'location': 'Location',
      'chooseArea': 'Choose area of the plant',
      'addRoom': '+ Add Room',
      'readyToAddPlant': 'Ready to add the plant?',
      'skipForNow': 'Feel free to skip for now—you can easily add later in the plant\'s detail settings.',
      'inRoom': 'In {room}',
      'askAboutWatering': 'How to solve water-logged problems',
      'properWatering': 'Proper watering techniques',
      'wateringFrequency': 'Frequency of watering',
      'careInstructions': 'How to care for',
      'wateringSchedule': "What's the ideal watering schedule for",
      'commonProblems': 'Common problems with',
      'waterLogged': 'Water-Logged',
      'waterLoggedDesc': 'There can be various causes of water-logging. Follow the instructions below and maintain your healthy plant.',
      'instructions': 'Instructions',
      'checkDrainageHole': 'Check the pot\'s drainage hole',
      'drainageHoleDesc': 'Ensure the pot has a proper drainage hole to allow water to flow out freely. Without it, excess water gets trapped in the soil, creating a waterlogged environment that suffocates roots and leads to problems like root rot. If there\'s no drainage hole, consider repotting into a pot that has one to prevent future issues.',
      'emptyDripTray': 'Empty the drip tray',
      'dripTrayDesc': 'Check the tray under your plant for standing water and empty it promptly. If water sits in the tray, it keeps the plant\'s roots in contact with stagnant water, which can cause them to rot over time. The best way is to empty the drip tray every 15-30 minutes after watering.',
      'tryRepotting': 'Try repotting',
      'repottingDesc': 'If your plant seems stressed or its growth has slowed, it might benefit from being repotted. Repotting not only provides fresh soil with better nutrients but also gives you a chance to check for pests or diseases. Additionally, it can prevent the roots from becoming bound or tangled in the pot.',
      'checkSensor': 'Check sensor',
      'sensorDesc': 'The sensor might have a problem. Check if it is securely inserted into the soil at the appropriate depth and in the correct location. Verify that there are no connection issues, such as a weak signal or low battery, and ensure the device is calibrated and providing accurate readings.',
      'cantFindReason': 'If you can\'t find the exact reason, chat with our AI diagnosing and figure out the problems.',
      'careTips': 'Care Tips',
      'realTimeSoilMoisture': 'Real-time Soil Moisture',
      'underwatered': 'Underwatered',
      'editPlant': 'Edit Plant',
      'plantUpdated': 'Plant updated',
      'failedToUpdate': 'Failed to update',
      'selectRoomOrCustom': 'Select a room or add a custom location',
    },
    'ko': {
      'appTitle': '루틴',
      'home': '홈',
      'settings': '설정',
      'profile': '프로필',
      'notifications': '알림',
      'search': '검색',
      'camera': '카메라',
      'gallery': '갤러리',
      'save': '저장',
      'cancel': '취소',
      'language': '언어',
      'selectLanguage': '언어 선택',
      'myPage': '마이 페이지',
      'appGuide': '앱 가이드',
      'shopSensor': '센서 구매',
      'sensorSettings': '센서 설정',
      'help': '도움말',
      'privacyPolicy': '개인정보 처리방침',
      'termsOfService': '이용약관',
      'couldNotOpenWebsite': '웹사이트를 열 수 없습니다',
      'allLocations': '전체 위치',
      'livingroom': '거실',
      'bedroom': '침실',
      'kitchen': '방',
      'office': '사무실',
      'porch': '현관',
      'allRooms': '전체 방',
      'locations': '위치',
      'rooms': '방',
      'done': '완료',
      'todaysWatering': '오늘의 물주기',
      'myPlants': '내 식물',
      'tryToAddPlant': '식물을 추가해보세요!',
      'today': '오늘',
      'upcoming': '예정',
      'in': '위치',
      'todo': '할 일',
      'underwater': '물 부족',
      'inProgress': '진행 중',
      'measuring': '측정 중',
      'ideal': '이상적',
      'movesToHistory': '24시간 후 기록으로 이동됩니다.',
      'sendMeNotifications': '알림 받기',
      'wateringReminders': '물주기 알림',
      'underwaterReminder': '물 부족 알림',
      'measuringReminder': '측정 중 알림',
      'idealReminder': '이상적 상태 알림',
      'overwaterReminder': '과습 알림',
      'waterloggedReminder': '물에 잠긴 상태 알림',
      'overallTips': '전반적인 팁',
      'difficulty': '난이도',
      'watering': '물주기',
      'light': '빛',
      'soilType': '토양 유형',
      'repotting': '분갈이',
      'toxicity': '독성',
      'overview': '개요',
      'soilMoistureUpdates': '실시간 관리 위해 매 토양 수분이 업데이트니다!',
      'currentSoilMoisture': '현재\n양 수분',
      'upcomingWatering': '다음\n물주기',
      'daysLater': '일 후',
      'unknown': '알 수 없음',
      'overwatered': '과습',
      'upcomingWateringInfo': '다음 물주기 정보',
      'upcomingWateringDesc': '다음 물주기 섹션은 최적의 식물 관리를 위한 다음 예정된 물주기까지 남은 일수를 보여줍니다.',
      'plant': '식물이',
      'plants': '식이',
      'waitingToBeWatered': '물을 기다 있어요',
      'checkYourWatering': '물주기 확인하기',
      'backToIdeal': '이상적인 상태로 돌아왔어요!',
      'dryingOut': '건조해지고 있어요!',
      'waterloggedIssue': '물에 잠긴 상태예요!',
      'statusUnknown': '상태 알 수 없음',
      'plantLivelyAgain': '잘했어요! 식물이 다시 생기를 찾았어요.',
      'waterToIdeal': '이상적인 수분 상태로 돌아가기 위해 물을 주세요.',
      'notifyWhenComplete': '측정이 완료되면 바로 알려드릴게요!',
      'insufficientDrainage': '지난 3일 동안 배수가 충분하지 않았어요.',
      'tooMuchWater': '식물에 물이 너무 많아요. 조금 말리세요.',
      'noDetailsAvailable': '상세 정보가 없습니다.',
      'goToWatering': '물주기로 이동',
      'checkInstructions': '안내사항 확인',
      'learnMore': '더 알아보기',
      'askChatbot': '챗봇에게 물어보고 궁금증을 해결하세요.',
      'goToChatbot': '챗봇으로 이동',
      'soilMoisture': '토양 수분',
      'idealRange': '이상적인 범위 (30-70%)',
      'weeklyTrends': '주간 동향',
      'needHelpWith': '{plantName}에 대해 도움이 필요하신가요?',
      'identifyPlantFirst': '먼저 물을 식별하세요',
      'searchByNameOrImage': '식물 이름으로 검하거나 이미지를 사용하여 식별하세요.',
      'identifiedPlant': '식별된 식물',
      'scientificName': '학명',
      'addPlant': '식물 추가',
      'retakePhoto': '사진 다시 찍기',
      'failedToIdentify': '식물 식별 실패',
      'searchAgain': '다시 검',
      'whichOneToAdd': '어떤 식물을 추가하시겠어요?',
      'nameYourPlant': '식물의 이름을 지어주세요!',
      'nameWithinCharacters': '20자 이내로 입력해주세요',
      'plantNickname': '식물 애칭',
      'continue': '계속하기',
      'chooseSite': '식물의 위치를 선택하세요',
      'selectSiteOrCustom': '위치를 선택하거나 직접 추가하세요.',
      'addYourOwn': '+ 직접 추가',
      'location': '치',
      'chooseArea': '식물의 구역을 선택하세요',
      'addRoom': '+ 방 추가',
      'readyToAddPlant': '식물을 추가할 준비가 되었나요?',
      'skipForNow': '나중에 식물 상세 설정에서 쉽게 추가할 수 있어요.',
      'inRoom': '{room}에 있음',
      'askAboutWatering': '물 과다 문제 해결 방법',
      'properWatering': '올바른 물주기 방법',
      'wateringFrequency': '물주기 빈도',
      'careInstructions': '관리 방법',
      'wateringSchedule': '이상적인 물주기 일정',
      'commonProblems': '일반적인 문제',
      'waterLogged': '물 과다',
      'waterLoggedDesc': '물 과다 현상에는 여러 가지 원인이 있을 수 있습니다. 아래 지침을 따라 건강한 식물을 유지하세요.',
      'instructions': '지침',
      'checkDrainageHole': '화분의 배수 구멍 확인',
      'drainageHoleDesc': '화분에 물이 자유롭게 흐를 수 있는 적절한 배수 구멍이 있는지 확인하세요. 배수 구멍이 없으면 과도한 물이 토양에 갇혀 뿌리를 질식시키고 뿌리 썩음과 같은 문제를 일으킬 수 있습니다. 배수 구멍이 없다면 향후 문제를 방지하기 위해 배수 구멍이 있는 화분으로 분갈이를 고려하세요.',
      'emptyDripTray': '받침대 비우기',
      'dripTrayDesc': '물 아래 받침대에 고인 물이 있는지 확인하고 즉시 비우세요. 받침대에 물이 고여 있으면 식물의 뿌리가 고인 물과 계속 접촉하여 시간이 지나면서 썩을 수 있습니다. 물을 준 후 15-30분마다 받침대를 비우는 것이 가장 좋습니다.',
      'tryRepotting': '분갈이 시도',
      'repottingDesc': '식물이 스트레스를 받거나 성장이 느려진 것 같다면 분갈이가 도움 될 수 있습니다. 분갈이는 더 나은 영양분이 있는 ��로운 흙을 제공할 뿐만 아니라 해충이나 질병을 확인할 수 있는 기회도 제공합니다. 또한 뿌리가 화분에 묶이거나 엉키는 것을 방지할 수 있습니다.',
      'checkSensor': '센서 확인',
      'sensorDesc': '센서에 문제가 있을 수 있습니다. 센서가 적절한 깊이와 올바른 위치에 안전하게 삽입되어 있는지 확인하세요. 신호가 약하거나 배터리가 부족한 것과 같은 연결 문제가 없는지 확인하고 장치가 보정되어 정확한 판독값을 제공하는지 확인하세요.',
      'cantFindReason': '정확한 원인을 찾을 수 없다면, AI 진단과 채팅하여 문제를 파악하세요.',
      'careTips': '관리 팁',
      'realTimeSoilMoisture': '실시간 토양 수분',
      'underwatered': 'Underwatered',
      'editPlant': '식물 수정',
      'plantUpdated': '식물이 업데이트되었습니다',
      'failedToUpdate': '업데이트 실패',
      'selectRoomOrCustom': '방을 선택하거나 직접 추가하세요',
    },
  };

  String get appTitle => _localizedValues[locale.languageCode]!['appTitle']!;
  String get home => _localizedValues[locale.languageCode]!['home']!;
  String get settings => _localizedValues[locale.languageCode]!['settings']!;
  String get profile => _localizedValues[locale.languageCode]!['profile']!;
  String get notifications => _localizedValues[locale.languageCode]!['notifications']!;
  String get search => _localizedValues[locale.languageCode]!['search']!;
  String get camera => _localizedValues[locale.languageCode]!['camera']!;
  String get gallery => _localizedValues[locale.languageCode]!['gallery']!;
  String get save => _localizedValues[locale.languageCode]!['save']!;
  String get cancel => _localizedValues[locale.languageCode]!['cancel']!;
  String get language => _localizedValues[locale.languageCode]!['language']!;
  String get selectLanguage => _localizedValues[locale.languageCode]!['selectLanguage']!;
  String get myPage => _localizedValues[locale.languageCode]!['myPage']!;
  String get appGuide => _localizedValues[locale.languageCode]!['appGuide']!;
  String get shopSensor => _localizedValues[locale.languageCode]!['shopSensor']!;
  String get sensorSettings => _localizedValues[locale.languageCode]!['sensorSettings']!;
  String get help => _localizedValues[locale.languageCode]!['help']!;
  String get privacyPolicy => _localizedValues[locale.languageCode]!['privacyPolicy']!;
  String get termsOfService => _localizedValues[locale.languageCode]!['termsOfService']!;
  String get couldNotOpenWebsite => _localizedValues[locale.languageCode]!['couldNotOpenWebsite']!;
  String get allLocations => _localizedValues[locale.languageCode]!['allLocations']!;
  String get livingroom => _localizedValues[locale.languageCode]!['livingroom']!;
  String get bedroom => _localizedValues[locale.languageCode]!['bedroom']!;
  String get kitchen => _localizedValues[locale.languageCode]!['kitchen']!;
  String get office => _localizedValues[locale.languageCode]!['office']!;
  String get porch => _localizedValues[locale.languageCode]!['porch']!;
  String get allRooms => _localizedValues[locale.languageCode]!['allRooms']!;
  String get locations => _localizedValues[locale.languageCode]!['locations']!;
  String get rooms => _localizedValues[locale.languageCode]!['rooms']!;
  String get done => _localizedValues[locale.languageCode]!['done']!;
  String get todaysWatering => _localizedValues[locale.languageCode]!['todaysWatering']!;
  String get myPlants => _localizedValues[locale.languageCode]!['myPlants']!;
  String get tryToAddPlant => _localizedValues[locale.languageCode]!['tryToAddPlant']!;
  String get today => _localizedValues[locale.languageCode]!['today']!;
  String get upcoming => _localizedValues[locale.languageCode]!['upcoming']!;
  String get in_ => _localizedValues[locale.languageCode]!['in']!;
  String get todo => _localizedValues[locale.languageCode]!['todo']!;
  String get underwater => _localizedValues[locale.languageCode]!['underwater']!;
  String get inProgress => _localizedValues[locale.languageCode]!['inProgress']!;
  String get measuring => _localizedValues[locale.languageCode]!['measuring']!;
  String get ideal => _localizedValues[locale.languageCode]!['ideal']!;
  String get movesToHistory => _localizedValues[locale.languageCode]!['movesToHistory']!;
  String get sendMeNotifications => _localizedValues[locale.languageCode]!['sendMeNotifications']!;
  String get wateringReminders => _localizedValues[locale.languageCode]!['wateringReminders']!;
  String get underwaterReminder => _localizedValues[locale.languageCode]!['underwaterReminder']!;
  String get measuringReminder => _localizedValues[locale.languageCode]!['measuringReminder']!;
  String get idealReminder => _localizedValues[locale.languageCode]!['idealReminder']!;
  String get overwaterReminder => _localizedValues[locale.languageCode]!['overwaterReminder']!;
  String get waterloggedReminder => _localizedValues[locale.languageCode]!['waterloggedReminder']!;
  String get overallTips => _localizedValues[locale.languageCode]!['overallTips']!;
  String get difficulty => _localizedValues[locale.languageCode]!['difficulty']!;
  String get watering => _localizedValues[locale.languageCode]!['watering']!;
  String get light => _localizedValues[locale.languageCode]!['light']!;
  String get soilType => _localizedValues[locale.languageCode]!['soilType']!;
  String get repotting => _localizedValues[locale.languageCode]!['repotting']!;
  String get toxicity => _localizedValues[locale.languageCode]!['toxicity']!;
  String get overview => _localizedValues[locale.languageCode]!['overview']!;
  String get soilMoistureUpdates => _localizedValues[locale.languageCode]!['soilMoistureUpdates']!;
  String get currentSoilMoisture => _localizedValues[locale.languageCode]!['currentSoilMoisture']!;
  String get upcomingWatering => _localizedValues[locale.languageCode]!['upcomingWatering']!;
  String get daysLater => _localizedValues[locale.languageCode]!['daysLater']!;
  String get unknown => _localizedValues[locale.languageCode]!['unknown']!;
  String get overwatered => _localizedValues[locale.languageCode]!['overwatered']!;
  String get upcomingWateringInfo => _localizedValues[locale.languageCode]!['upcomingWateringInfo']!;
  String get upcomingWateringDesc => _localizedValues[locale.languageCode]!['upcomingWateringDesc']!;
  String get plant => _localizedValues[locale.languageCode]!['plant']!;
  String get plants => _localizedValues[locale.languageCode]!['plants']!;
  String get waitingToBeWatered => _localizedValues[locale.languageCode]!['waitingToBeWatered']!;
  String get checkYourWatering => _localizedValues[locale.languageCode]!['checkYourWatering']!;
  String get backToIdeal => _localizedValues[locale.languageCode]!['backToIdeal']!;
  String get dryingOut => _localizedValues[locale.languageCode]!['dryingOut']!;
  String get waterloggedIssue => _localizedValues[locale.languageCode]!['waterloggedIssue']!;
  String get statusUnknown => _localizedValues[locale.languageCode]!['statusUnknown']!;
  String get plantLivelyAgain => _localizedValues[locale.languageCode]!['plantLivelyAgain']!;
  String get waterToIdeal => _localizedValues[locale.languageCode]!['waterToIdeal']!;
  String get notifyWhenComplete => _localizedValues[locale.languageCode]!['notifyWhenComplete']!;
  String get insufficientDrainage => _localizedValues[locale.languageCode]!['insufficientDrainage']!;
  String get tooMuchWater => _localizedValues[locale.languageCode]!['tooMuchWater']!;
  String get noDetailsAvailable => _localizedValues[locale.languageCode]!['noDetailsAvailable']!;
  String get goToWatering => _localizedValues[locale.languageCode]!['goToWatering']!;
  String get checkInstructions => _localizedValues[locale.languageCode]!['checkInstructions']!;
  String get learnMore => _localizedValues[locale.languageCode]!['learnMore']!;
  String get askChatbot => _localizedValues[locale.languageCode]!['askChatbot']!;
  String get goToChatbot => _localizedValues[locale.languageCode]!['goToChatbot']!;
  String get soilMoisture => _localizedValues[locale.languageCode]!['soilMoisture']!;
  String get idealRange => _localizedValues[locale.languageCode]!['idealRange']!;
  String get weeklyTrends => _localizedValues[locale.languageCode]!['weeklyTrends']!;
  String get needHelpWith => _localizedValues[locale.languageCode]!['needHelpWith']!;
  String get identifyPlantFirst => _localizedValues[locale.languageCode]!['identifyPlantFirst']!;
  String get searchByNameOrImage => _localizedValues[locale.languageCode]!['searchByNameOrImage']!;
  String get identifiedPlant => _localizedValues[locale.languageCode]!['identifiedPlant']!;
  String get scientificName => _localizedValues[locale.languageCode]!['scientificName']!;
  String get addPlant => _localizedValues[locale.languageCode]!['addPlant']!;
  String get retakePhoto => _localizedValues[locale.languageCode]!['retakePhoto']!;
  String get failedToIdentify => _localizedValues[locale.languageCode]!['failedToIdentify']!;
  String get searchAgain => _localizedValues[locale.languageCode]!['searchAgain']!;
  String get whichOneToAdd => _localizedValues[locale.languageCode]!['whichOneToAdd']!;
  String get nameYourPlant => _localizedValues[locale.languageCode]!['nameYourPlant']!;
  String get nameWithinCharacters => _localizedValues[locale.languageCode]!['nameWithinCharacters']!;
  String get plantNickname => _localizedValues[locale.languageCode]!['plantNickname']!;
  String get continueText => _localizedValues[locale.languageCode]!['continue']!;
  String get chooseSite => _localizedValues[locale.languageCode]!['chooseSite']!;
  String get selectSiteOrCustom => _localizedValues[locale.languageCode]!['selectSiteOrCustom']!;
  String get addYourOwn => _localizedValues[locale.languageCode]!['addYourOwn']!;
  String get location => _localizedValues[locale.languageCode]!['location']!;
  String get chooseArea => _localizedValues[locale.languageCode]!['chooseArea']!;
  String get addRoom => _localizedValues[locale.languageCode]!['addRoom']!;
  String get readyToAddPlant => _localizedValues[locale.languageCode]!['readyToAddPlant']!;
  String get skipForNow => _localizedValues[locale.languageCode]!['skipForNow']!;
  String inRoom(String room) => _localizedValues[locale.languageCode]!['inRoom']!.replaceAll('{room}', room);
  String get askAboutWatering => _localizedValues[locale.languageCode]!['askAboutWatering']!;
  String get properWatering => _localizedValues[locale.languageCode]!['properWatering']!;
  String get wateringFrequency => _localizedValues[locale.languageCode]!['wateringFrequency']!;
  String get careInstructions => _localizedValues[locale.languageCode]!['careInstructions']!;
  String get wateringSchedule => _localizedValues[locale.languageCode]!['wateringSchedule']!;
  String get commonProblems => _localizedValues[locale.languageCode]!['commonProblems']!;
  String get waterLogged => _localizedValues[locale.languageCode]!['waterLogged']!;
  String get waterLoggedDesc => _localizedValues[locale.languageCode]!['waterLoggedDesc']!;
  String get instructions => _localizedValues[locale.languageCode]!['instructions']!;
  String get checkDrainageHole => _localizedValues[locale.languageCode]!['checkDrainageHole']!;
  String get drainageHoleDesc => _localizedValues[locale.languageCode]!['drainageHoleDesc']!;
  String get emptyDripTray => _localizedValues[locale.languageCode]!['emptyDripTray']!;
  String get dripTrayDesc => _localizedValues[locale.languageCode]!['dripTrayDesc']!;
  String get tryRepotting => _localizedValues[locale.languageCode]!['tryRepotting']!;
  String get repottingDesc => _localizedValues[locale.languageCode]!['repottingDesc']!;
  String get checkSensor => _localizedValues[locale.languageCode]!['checkSensor']!;
  String get sensorDesc => _localizedValues[locale.languageCode]!['sensorDesc']!;
  String get cantFindReason => _localizedValues[locale.languageCode]!['cantFindReason']!;
  String get careTips => _localizedValues[locale.languageCode]!['careTips']!;
  String get realTimeSoilMoisture => _localizedValues[locale.languageCode]!['realTimeSoilMoisture']!;
  String get underwatered => _localizedValues[locale.languageCode]!['underwatered']!;
  String get editPlant => _localizedValues[locale.languageCode]!['editPlant']!;
  String get plantUpdated => _localizedValues[locale.languageCode]!['plantUpdated']!;
  String get failedToUpdate => _localizedValues[locale.languageCode]!['failedToUpdate']!;
  String get selectRoomOrCustom => _localizedValues[locale.languageCode]!['selectRoomOrCustom']!;
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ko'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
