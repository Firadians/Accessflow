class ApiEndpoints {
  static const String baseUrl = 'https://2c29-110-139-21-253.ngrok-free.app';
}

class MainAssets {
  static const String title = 'AccessFlow | Card Registration App';
  static const List<String> levelOnePosition = [
    'validator',
    'supervisor',
    'admin'
  ];
  static const List<String> levelTwoPosition = [
    'karyawan',
    'outsourcing',
    'user'
  ];
}

class GlobalAssets {
  static const String ktpText = 'KTP';
  static const String passwordText = 'Password';
  static const String noConnectionText = 'Tidak ada Koneksi';
  static const String pleaseCheckText = 'Silahkan cek koneksi anda';
  static const String cancelText = 'Batal';
  static const String okText = 'OK';

  static const String noDataImage = 'assets/utils/no_data_available.png';
  static const String noDataText = 'data tidak tersedia.';
  static const String noCardDataText = 'data tidak tersedia.';

  static const String dateFormat = 'yyyy-MM-dd HH:mm:ss';
  static const String noData = 'data tidak tersedia';
}

class HomeAssets {
  //IMAGE
  static const String homeBackgroundImage = 'assets/home/home_background.png';
  static const String accessCardIcon = 'assets/icons/icon_access_card.png';
  static const String createNewIcon = 'assets/icons/icon_create_new.png';
  static const String printAvailableIcon =
      'assets/icons/icon_print_available.png';
  static const String idCardIcon = 'assets/icons/icon_id_card.png';
  static const String aksesPerumdinIcon =
      'assets/icons/icon_akses_perumdin.png';
  static const String makeCardIcon = 'assets/icons/icon_make_card.png';
  static const String informationIcon = 'assets/icons/icon_information.png';
  static const String userGuideIcon = 'assets/icons/icon_user_guide.png';

  //TEXT
  static const String welcomeText = 'Selamat Datang';
  static const String nameGuestText = 'Pengunjung';
  static const String historyText = 'Riwayat';
  static const String cardStatusText = 'Status Pengisian Data';
  static const String createNewText = 'Buat Baru';
  static const String printAvailableText = 'Cetak Ulang';
  static const String accessCardExistText = 'Access Card Sudah Pernah';
  static const String accessCardText = 'Access Card';
  static const String idCardText = 'ID Card';
  static const String aksesPerumdinText = 'Akses Perumdin';
  static const String accessCardNAText = 'Access Card (Card Not Available)';
  static const String idCardNAText = 'ID Card (Card Not Available)';
  static const String aksesPerumdinNAText =
      'Akses Perumdin (Card Not Available)';
  static const String aksesPerumdinExistText = 'Akses Perumdin Sudah Pernah';
  static const String cardCreateStatusText = 'Status Pembuatan Kartu';

  //CUSTOM CARD
  static const String createCardText = 'Buat Kartu';
  static const String informationText = 'Informasi';
  static const String userGuideText = 'Panduan Aplikasi';

  //IMAGE GALLERY
  static const String imageGalleryTitle = 'Layanan Kami';
  static const String contentTitle = 'Kartu Yang Tersedia';
  //GUIDE

  static const List<String> validPositions = ['admin', 'supervisor', 'user'];
}

class CreateCardAssets {
//TEXT
  static const String accessCardText = 'Access Card';
  static const String idCardText = 'ID Card';
  static const String aksesPerumdinText = 'Akses Perumdin';
  static const String nameLabelText = 'Nama';
  static const String ktpLabelText = 'Nomor KTP';
  static const String nameHintText = 'Masukkan Nama Anda';
  static const String ktpHintText = 'Masukkan Nomor KTP Anda';
  static const String choosePhotoText = 'Pilih Pas Foto';
}

class CardAssets {
  //ACCESS CARD
  static const String accessCardTitle = 'Access Card';
  static const String accessCardImage = 'assets/card/card_bni.jpg';
  static const String accessCardDescText =
      'Merupakan kartu akses khusus yang digunakan untuk memasuki area kerja PT Petrokimia Gresik. Kartu ini digunakan saat ada keperluan untuk memasuki kawasan yang membutuhkan kartu akses.';
  static const String accessCardPositionText = 'Visitor, Karyawan';

  //ID CARD
  static const String idCardTitle = 'ID Card';
  static const String idCardImage = 'assets/card/card_id.jpg';
  static const String idCardDescText =
      'Merupakan kartu akses khusus yang digunakan untuk memasuki area kerja PT Petrokimia Gresik. Kartu ini digunakan oleh seluruh karyawan.';
  static const String idCardPositionText = 'Karyawan';

  //AKSES PERUMDIN
  static const String aksesPerumdinTitle = 'Akses Perumdin';
  static const String aksesPerumdinImage = 'assets/card/card_perumdin.jpg';
  static const String aksesPerumdinDescText =
      'Merupakan kartu akses khusus yang digunakan untuk memasuki area perumahan PT Petrokimia Gresik. Kartu ini hanya diperuntukkan untuk keluarga yang menempati perumahan dinas.';
  static const String aksesPerumdinPositionText = 'Penghuni Perumahan Dinas';

  //TITLE
  static const String cardDescTitle = 'Deskripsi :';
  static const String cardPositionTitle = 'Diperuntukkan untuk :';
  static const String cardAvailable = 'Tersedia';
  static const String cardAvailableText = 'Buat Sekarang';
}

class LoginAssets {
  static const String appLogo = 'assets/logo/logo_app.png';
  static const String loginBackground = 'assets/auth/login_background.png';
  static const String bumnLogo = 'assets/logo/logo_bumn.png';
  static const String pupukIndonesiaLogo =
      'assets/logo/logo_pupuk_indonesia.png';
  static const String petrokimiaGresikLogo =
      'assets/logo/logo_petrokimia_gresik.png';
  static const String sacText = 'System Access Control';
  static const String loginText = 'Masuk';
  static const String forgotPasswordText = 'Lupa password?';
}

class DraftAssets {
  static const String draftBackgroundImage =
      'assets/draft/draft_background.png';
  static const String draftText = 'Draf';
}

class HistoryAssets {
  static const String historyBackgroundImage =
      'assets/history/history_background.png';
  static const String takeCardLocationImage =
      'assets/history/take_card_location.png';
  static const String historyText = 'Riwayat';
  static const String tabAllText = 'Semua';
  static const String tabOnProgressText = 'Berlangsung';
  static const String tabCompletedText = 'Selesai';
  static const String cardSaveDateText = 'Disimpan pada';
  static const String statusIndicatorOne = 'Diajukan';
  static const String statusIndicatorTwo = 'Diproses';
  static const String statusIndicatorThree = 'Dapat Diambil';
  static const String statusIndicatorFour = 'Selesai';
  static const String statusIndicatorFive = 'Ditolak';

  //detail card
  static const String detailCardTitle = 'Status Pengajuan';
  static const List<String> stepTitles = [
    'Diajukan',
    'Diproses',
    'Dapat Diambil',
    'Selesai',
  ];
  static const String takeCardText =
      'Silahkan ambil kartu anda di kantor Departemen Keamanan. Gunakan kode dibawah ini untuk ditukarkan kepada admin.';
  static const String cardCredentialText = 'Kode Kredensial :';
  static const String alreadyTakeText = 'Anda telah mengambil kartu.';
  static const String fieldText = 'Value';
  static const String valueText = 'Field';
  static const String cardTypeText = 'Tipe Kartu';
  static const String holderPositionText = 'Posisi Pemegang';
  static const String nameText = 'Nama';
  static const String ktpNumberText = 'Nomor KTP';
  static const String statusText = 'Status';
  static const String messageText = 'Pesan';
}

class ProfileAssets {
  static const List<Map<String, String>> callCenterData = [
    {
      'title': 'Ahmad Baihaqi as CP',
      'content': '+628785210312',
      'phoneNumber': '087859218995',
    },
    {
      'title': 'Ridho Alim as SVP',
      'content': '+628785210313',
      'phoneNumber': '087859218995',
    },
    {
      'title': 'Veerda as Secretary',
      'content': '+628785210314',
      'phoneNumber': '087859218995',
    },
  ];

  static const List<Map<String, String>> faqData = [
    {
      'title': 'How do I get started with the app?',
      'content':
          'To get started with the app, simply download it from the app store...',
    },
    {
      'title': 'Can I change my account settings?',
      'content':
          'Yes, you can change your account settings by going to the "Settings" tab...',
    },
    {
      'title': 'What should I do if I forgot my password?',
      'content':
          'If you forgot your password, you can reset it by clicking on the "Forgot Password" link on the login screen...',
    },
    {
      'title': 'How can I contact customer support?',
      'content':
          'You can contact our customer support team by emailing support@example.com...',
    },
  ];
}

class UtilsAssets {
  static const String iconSplashImage = 'assets/icons/icon_splash.png';

  static const String successLottieJson = 'assets/lottie/success.json';
  static const String successTitle = 'Pengajuan Sukses!';
  static const String successdesc =
      'Silahkan cek detail pengajuan kartu akses anda di riwayat.';
}
