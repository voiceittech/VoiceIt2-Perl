package voiceIt2;

require LWP::UserAgent;
use HTTP::Request::Common qw(POST);
use HTTP::Request::Common qw(DELETE);
use HTTP::Request::Common qw(PUT);
use HTTP::Request::Common qw(GET);

my $self;
my $baseUrl = 'https://api.voiceit.io';
my $apiKey;
my $apiToken;
my $platformId = 38;
use strict;

sub new {
    my $package = shift;
    ($apiKey, $apiToken) = @_;
    $self = bless({apiKey => $apiKey, apiToken => $apiToken}, $package);
    return $self;
  }

  sub getAllUsers() {
    shift;
    my $ua = LWP::UserAgent->new();
    my $request = GET $baseUrl.'/users';
    $request->header('platformId' => $platformId);
    $request->authorization_basic($apiKey, $apiToken);
    my $reply = $ua->request($request);
    return $reply->content();
  }

  sub createUser() {
    shift;
    my $ua = LWP::UserAgent->new();
    my $request = POST $baseUrl.'/users';
    $request->header('platformId' => $platformId);
    $request->authorization_basic($apiKey, $apiToken);
    my $reply = $ua->request($request);
    return $reply->content();
  }

  sub checkUserExists(){
    shift;
    my ($usrId) = @_;
    my $ua = LWP::UserAgent->new();
    my $request = GET $baseUrl.'/users/'.$usrId;
    $request->header('platformId' => $platformId);
    $request->authorization_basic($apiKey, $apiToken);
    my $reply = $ua->request($request);
    return $reply->content();
  }

  sub deleteUser(){
    shift;
    my ($usrId) = @_;
    my $ua = LWP::UserAgent->new();
    my $request = DELETE $baseUrl.'/users/'.$usrId;
    $request->header('platformId' => $platformId);
    $request->authorization_basic($apiKey, $apiToken);
    my $reply = $ua->request($request);
    return $reply->content();
  }

  sub getGroupsForUser(){
    shift;
    my ($usrId) = @_;
    my $ua = LWP::UserAgent->new();
    my $request = GET $baseUrl.'/users/'.$usrId.'/groups';
    $request->header('platformId' => $platformId);
    $request->authorization_basic($apiKey, $apiToken);
    my $reply = $ua->request($request);
    return $reply->content();
  }

  sub getAllGroups(){
    shift;
    my $ua = LWP::UserAgent->new();
    my $request = GET $baseUrl.'/groups';
    $request->header('platformId' => $platformId);
    $request->authorization_basic($apiKey, $apiToken);
    my $reply = $ua->request($request);
    return $reply->content();
  }


  sub getGroup(){
    shift;
    my ($groupId) = @_;
    my $ua = LWP::UserAgent->new();
    my $request = GET $baseUrl.'/groups/'.$groupId;
    $request->header('platformId' => $platformId);
    $request->authorization_basic($apiKey, $apiToken);
    my $reply = $ua->request($request);
    return $reply->content();
}

sub groupExists(){
  shift;
  my ($groupId) = @_;
  my $ua = LWP::UserAgent->new();
  my $request = GET $baseUrl.'/groups/'.$groupId.'/exists';
  $request->header('platformId' => $platformId);
  $request->authorization_basic($apiKey, $apiToken);
  my $reply = $ua->request($request);
  return $reply->content();
}

sub createGroup(){
  shift;
  my ($des)= @_;
  my $ua = LWP::UserAgent->new();
  my $request = POST $baseUrl.'/groups', Content => [
      description => $des
  ];
  $request->header('platformId' => $platformId);
  $request->authorization_basic($apiKey, $apiToken);
  my $reply = $ua->request($request);
  return $reply->content();
}

sub addUserToGroup(){
  shift;
  my ($grpId, $usrId)= @_;
  my $ua = LWP::UserAgent->new();
  my $request = PUT $baseUrl.'/groups/addUser',
    Content => [
        groupId => $grpId,
        userId => $usrId,
    ];
  $request->header('platformId' => $platformId);
  $request->authorization_basic($apiKey, $apiToken);
  my $reply = $ua->request($request);
  return $reply->content();
}

sub removeUserFromGroup(){
  shift;
  my ($grpId, $usrId)= @_;
  my $ua = LWP::UserAgent->new();
  my $request = PUT $baseUrl.'/groups/removeUser',
    Content => [
        groupId => $grpId,
        userId => $usrId,
    ];
  $request->header('platformId' => $platformId);
  $request->authorization_basic($apiKey, $apiToken);
  my $reply = $ua->request($request);
  return $reply->content();
}

sub deleteGroup(){
  shift;
  my ($grpId)= @_;
  my $ua = LWP::UserAgent->new();
  my $request = DELETE $baseUrl.'/groups/'.$grpId;
  $request->header('platformId' => $platformId);
  $request->authorization_basic($apiKey, $apiToken);
  my $reply = $ua->request($request);
  return $reply->content();
}

sub getAllPhrases(){
  shift;
  my ($contentLanguage)= @_;
  my $ua = LWP::UserAgent->new();
  my $request = GET $baseUrl.'/phrases/'.$contentLanguage;
  $request->header('platformId' => $platformId);
  $request->authorization_basic($apiKey, $apiToken);
  my $reply = $ua->request($request);
  return $reply->content();
}

sub getAllFaceEnrollmentsForUser(){
  shift;
  my ($usrId)= @_;
  my $ua = LWP::UserAgent->new();
  my $request = GET $baseUrl.'/enrollments/face/'.$usrId;
  $request->header('platformId' => $platformId);
  $request->authorization_basic($apiKey, $apiToken);
  my $reply = $ua->request($request);
  return $reply->content();
}

sub getAllVoiceEnrollmentsForUser(){
  shift;
  my ($usrId)= @_;
  my $ua = LWP::UserAgent->new();
  my $request = GET $baseUrl.'/enrollments/voice/'.$usrId;
  $request->header('platformId' => $platformId);
  $request->authorization_basic($apiKey, $apiToken);
  my $reply = $ua->request($request);
  return $reply->content();
}

sub getAllVideoEnrollmentsForUser(){
  shift;
  my ($usrId)= @_;
  my $ua = LWP::UserAgent->new();
  my $request = GET $baseUrl.'/enrollments/video/'.$usrId;
  $request->header('platformId' => $platformId);
  $request->authorization_basic($apiKey, $apiToken);
  my $reply = $ua->request($request);
  return $reply->content();
}

sub createVoiceEnrollment(){
  shift;
  my ($usrId, $lang, $phrase, $filePath) = @_;
  if (!(-e $filePath)) {
    die "FileNotFound: No such file or directory \"".$filePath."\" \@createVoiceEnrollment";
  }
  my $ua = LWP::UserAgent->new();
  my $request = POST $baseUrl.'/enrollments/voice', Content_Type => 'form-data',  Content => [
        recording => [$filePath],
        userId => $usrId,
        contentLanguage => $lang,
        phrase => $phrase
    ];
  $request->header('platformId' => $platformId);
  $request->authorization_basic($apiKey, $apiToken);
  my $reply = $ua->request($request);
  return $reply->content();
}

sub createVoiceEnrollmentByUrl(){
  shift;
  my ($usrId, $lang,  $phrase, $fileUrl) = @_;
  my $ua = LWP::UserAgent->new();
  my $request = POST $baseUrl.'/enrollments/voice/byUrl', Content_Type => 'form-data',  Content => [
        fileUrl => $fileUrl,
        userId => $usrId,
        phrase => $phrase,
        contentLanguage => $lang
    ];
  $request->header('platformId' => $platformId);
  $request->authorization_basic($apiKey, $apiToken);
  my $reply = $ua->request($request);
  return $reply->content();
}

sub createFaceEnrollment(){
  shift;
  my $blink = 0;
  my ($usrId, $filePath, $doBlink) = @_;
  my $ua = LWP::UserAgent->new();
  if($doBlink){
    $blink = $doBlink;
  }
  if (!(-e $filePath)) {
    die "FileNotFound: No such file or directory \"".$filePath."\" \@createFaceEnrollment";
  }
  my $request = POST $baseUrl.'/enrollments/face', Content_Type => 'form-data',  Content => [
        video => [$filePath],
        userId => $usrId,
        doBlinkDetection => $blink
    ];
  $request->header('platformId' => $platformId);
  $request->authorization_basic($apiKey, $apiToken);
  my $reply = $ua->request($request);
  print $reply->content();
  return $reply->content();
}

sub createFaceEnrollmentByUrl(){
  shift;
  my $blink = 0;
  my ($usrId, $fileUrl, $doBlink) = @_;
  my $ua = LWP::UserAgent->new();
  if($doBlink){
    $blink = $doBlink;
  }
  my $request = POST $baseUrl.'/enrollments/face/byUrl', Content_Type => 'form-data', Content => [
        fileUrl => $fileUrl,
        userId => $usrId,
        doBlinkDetection => $blink
  ];
  $request->header('platformId' => $platformId);
  $request->authorization_basic($apiKey, $apiToken);
  my $reply = $ua->request($request);
  return $reply->content();
}

sub createVideoEnrollment(){
  shift;
  my $blink = 0;
  my ($usrId, $lang,  $phrase,$filePath, $doBlink) = @_;
  my $ua = LWP::UserAgent->new();
  if($doBlink){
    $blink = $doBlink;
  }
  if (!(-e $filePath)) {
    die "FileNotFound: No such file or directory \"".$filePath."\" \@createVideoEnrollment";
  }
  my $request = POST $baseUrl.'/enrollments/video', Content_Type => 'form-data', Content => [
        video => [$filePath],
        userId => $usrId,
        contentLanguage => $lang,
        phrase => $phrase,
        doBlinkDetection => $blink
  ];
  $request->header('platformId' => $platformId);
  $request->authorization_basic($apiKey, $apiToken);
  my $reply = $ua->request($request);
  return $reply->content();
}

sub createVideoEnrollmentByUrl(){
  shift;
  my $blink = 0;
  my ($usrId, $lang,  $phrase,$fileUrl, $doBlink) = @_;
  my $ua = LWP::UserAgent->new();
  if($doBlink){
    $blink = $doBlink;
  }
  my $request = POST $baseUrl.'/enrollments/video/byUrl', Content_Type => 'form-data', Content => [
        fileUrl => $fileUrl,
        userId => $usrId,
        contentLanguage => $lang,
        phrase => $phrase,
        doBlinkDetection => $blink
  ];
  $request->header('platformId' => $platformId);
  $request->authorization_basic($apiKey, $apiToken);
  my $reply = $ua->request($request);
  return $reply->content();
}

sub deleteAllEnrollmentsForUser() {
  shift;
  my ($usrId) = @_;
  my $ua = LWP::UserAgent->new();
  my $request = DELETE $baseUrl.'/enrollments/'.$usrId."/all", Content_Type => 'form-data';
  $request->header('platformId' => $platformId);
  $request->authorization_basic($apiKey, $apiToken);
  my $reply = $ua->request($request);
  return $reply->content();
}

sub deleteAllVoiceEnrollmentsForUser() {
  shift;
  my ($usrId) = @_;
  my $ua = LWP::UserAgent->new();
  my $request = DELETE $baseUrl.'/enrollments/'.$usrId."/voice", Content_Type => 'form-data';
  $request->header('platformId' => $platformId);
  $request->authorization_basic($apiKey, $apiToken);
  my $reply = $ua->request($request);
  return $reply->content();
}

sub deleteAllFaceEnrollmentsForUser() {
  shift;
  my ($usrId) = @_;
  my $ua = LWP::UserAgent->new();
  my $request = DELETE $baseUrl.'/enrollments/'.$usrId."/face", Content_Type => 'form-data';
  $request->header('platformId' => $platformId);
  $request->authorization_basic($apiKey, $apiToken);
  my $reply = $ua->request($request);
  return $reply->content();
}

sub deleteAllVideoEnrollmentsForUser() {
  shift;
  my ($usrId) = @_;
  my $ua = LWP::UserAgent->new();
  my $request = DELETE $baseUrl.'/enrollments/'.$usrId."/video", Content_Type => 'form-data';
  $request->header('platformId' => $platformId);
  $request->authorization_basic($apiKey, $apiToken);
  my $reply = $ua->request($request);
  return $reply->content();
}

sub deleteFaceEnrollment(){
  shift;
  my ($usrId, $faceEnrollmentId) = @_;
  my $ua = LWP::UserAgent->new();
  my $request = DELETE $baseUrl.'/enrollments/face/'.$usrId."/" . $faceEnrollmentId, Content_Type => 'form-data';
  $request->header('platformId' => $platformId);
  $request->authorization_basic($apiKey, $apiToken);
  my $reply = $ua->request($request);
  return $reply->content();
}

sub deleteVoiceEnrollment(){
  shift;
  my ($usrId, $voiceEnrollmentId) = @_;
  my $ua = LWP::UserAgent->new();
  my $request = DELETE $baseUrl.'/enrollments/voice/'.$usrId."/" . $voiceEnrollmentId, Content_Type => 'form-data';
  $request->header('platformId' => $platformId);
  $request->authorization_basic($apiKey, $apiToken);
  my $reply = $ua->request($request);
  return $reply->content();
}


sub deleteVideoEnrollment(){
  shift;
  my ($usrId, $videoEnrollmentId) = @_;
  my $ua = LWP::UserAgent->new();
  my $request = DELETE $baseUrl.'/enrollments/video/'.$usrId."/" . $videoEnrollmentId, Content_Type => 'form-data';
  $request->header('platformId' => $platformId);
  $request->authorization_basic($apiKey, $apiToken);
  my $reply = $ua->request($request);
  return $reply->content();
}

sub voiceVerification(){
  shift;
  my ($usrId, $lang,  $phrase,$filePath) = @_;
  if (!(-e $filePath)) {
    die "FileNotFound: No such file or directory \"".$filePath."\" \@voiceVerification";
  }
  my $ua = LWP::UserAgent->new();
  my $request = POST $baseUrl.'/verification/voice', Content_Type => 'form-data', Content => [
        recording => [$filePath],
        userId => $usrId,
        phrase => $phrase,
        contentLanguage => $lang
  ];
  $request->header('platformId' => $platformId);
  $request->authorization_basic($apiKey, $apiToken);
  my $reply = $ua->request($request);
  return $reply->content();
}

sub voiceVerificationByUrl(){
  shift;
  my ($usrId, $lang,  $phrase,$fileUrl) = @_;
  my $ua = LWP::UserAgent->new();
  my $request = POST $baseUrl.'/verification/voice/byUrl', Content_Type => 'form-data', Content => [
        fileUrl => $fileUrl,
        userId => $usrId,
        phrase => $phrase,
        contentLanguage => $lang
  ];
  $request->header('platformId' => $platformId);
  $request->authorization_basic($apiKey, $apiToken);
  my $reply = $ua->request($request);
  return $reply->content();
}

sub faceVerification(){
  shift;
  my $blink = 0;
  my ($usrId, $filePath, $doBlink) = @_;
  my $ua = LWP::UserAgent->new();
  if($doBlink){
    $blink = $doBlink;
  }
  if (!(-e $filePath)) {
    die "FileNotFound: No such file or directory \"".$filePath."\" \@faceVerification";
  }
  my $request = POST $baseUrl.'/verification/face', Content_Type => 'form-data', Content => [
        video => [$filePath],
        userId => $usrId,
        doBlinkDetection => $blink
  ];
  $request->header('platformId' => $platformId);
  $request->authorization_basic($apiKey, $apiToken);
  my $reply = $ua->request($request);
  return $reply->content();
}

sub faceVerificationByUrl(){
  shift;
  my $blink = 0;
  my ($usrId, $fileUrl, $doBlink) = @_;
  my $ua = LWP::UserAgent->new();
  if($doBlink){
    $blink = $doBlink;
  }
  my $request = POST $baseUrl.'/verification/face/byUrl', Content_Type => 'form-data', Content => [
        fileUrl => $fileUrl,
        userId => $usrId,
        doBlinkDetection => $blink
  ];
  $request->header('platformId' => $platformId);
  $request->authorization_basic($apiKey, $apiToken);
  my $reply = $ua->request($request);
  return $reply->content();
}

sub videoVerification(){
  shift;
  my $blink = 0;
  my ($usrId, $lang, $phrase, $filePath, $doBlink) = @_;
  if (!(-e $filePath)) {
    die "FileNotFound: No such file or directory \"".$filePath."\" \@videoVerification";
  }
  my $ua = LWP::UserAgent->new();
  if($doBlink){
    $blink = $doBlink;
  }
  my $request = POST $baseUrl.'/verification/video', Content_Type => 'form-data', Content => [
        video => [$filePath],
        userId => $usrId,
        phrase => $phrase,
        contentLanguage => $lang,
        doBlinkDetection => $blink
  ];
  $request->header('platformId' => $platformId);
  $request->authorization_basic($apiKey, $apiToken);
  my $reply = $ua->request($request);
  return $reply->content();
}


sub videoVerificationByUrl(){
  shift;
  my $blink = 0;
  my ($usrId, $lang, $phrase, $fileUrl, $doBlink) = @_;
  my $ua = LWP::UserAgent->new();
  if($doBlink){
    $blink = $doBlink;
  }
  my $request = POST $baseUrl.'/verification/video/byUrl', Content_Type => 'form-data', Content => [
        fileUrl => $fileUrl,
        userId => $usrId,
        phrase => $phrase,
        contentLanguage => $lang,
        doBlinkDetection => $blink
  ];
  $request->header('platformId' => $platformId);
  $request->authorization_basic($apiKey, $apiToken);
  my $reply = $ua->request($request);
  return $reply->content();
}

sub voiceIdentification(){
  shift;
  my ($grpId, $lang, $phrase,$filePath) = @_;
  if (!(-e $filePath)) {
    die "FileNotFound: No such file or directory \"".$filePath."\" \@voiceIdentification";
  }
  my $ua = LWP::UserAgent->new();
  my $request = POST $baseUrl.'/identification/voice', Content_Type => 'form-data', Content => [
        recording => [$filePath],
        groupId => $grpId,
        phrase => $phrase,
        contentLanguage => $lang,
  ];
  $request->header('platformId' => $platformId);
  $request->authorization_basic($apiKey, $apiToken);
  my $reply = $ua->request($request);
  return $reply->content();
}

sub voiceIdentificationByUrl(){
  shift;
  my ($grpId, $lang, $phrase, $fileUrl) = @_;
  my $ua = LWP::UserAgent->new();
  my $request = POST $baseUrl.'/identification/voice/byUrl', Content_Type => 'form-data', Content => [
        fileUrl => $fileUrl,
        groupId => $grpId,
        phrase => $phrase,
        contentLanguage => $lang,
  ];
  $request->header('platformId' => $platformId);
  $request->authorization_basic($apiKey, $apiToken);
  my $reply = $ua->request($request);
  return $reply->content();
}

sub faceIdentification(){
  shift;
  my $blink = 0;
  my ($grpId, $filePath, $doBlink) = @_;
  if (!(-e $filePath)) {
    die "FileNotFound: No such file or directory \"".$filePath."\" \@faceIdentification";
  }
  if($doBlink){
    $blink = $doBlink;
  }
  my $ua = LWP::UserAgent->new();
  my $request = POST $baseUrl.'/identification/face', Content_Type => 'form-data', Content => [
        video => [$filePath],
        groupId => $grpId,
        doBlinkDetection => $blink
  ];
  $request->header('platformId' => $platformId);
  $request->authorization_basic($apiKey, $apiToken);
  my $reply = $ua->request($request);
  return $reply->content();
}

sub faceIdentificationByUrl(){
  shift;
  my $blink = 0;
  my ($grpId, $fileUrl, $doBlink) = @_;
  my $ua = LWP::UserAgent->new();
  if($doBlink){
    $blink = $doBlink;
  }
  my $request = POST $baseUrl.'/identification/face/byUrl', Content_Type => 'form-data', Content => [
        fileUrl => $fileUrl,
        groupId => $grpId,
        doBlinkDetection => $blink
  ];
  $request->header('platformId' => $platformId);
  $request->authorization_basic($apiKey, $apiToken);
  my $reply = $ua->request($request);
  return $reply->content();
}

sub videoIdentification(){
  shift;
  my $blink = 0;
  my ($grpId, $lang, $phrase, $filePath, $doBlink) = @_;
  if (!(-e $filePath)) {
    die "FileNotFound: No such file or directory \"".$filePath."\" \@videoIdentification";
  }
  my $ua = LWP::UserAgent->new();
  if($doBlink){
    $blink = $doBlink;
  }
  my $request = POST $baseUrl.'/identification/video', Content_Type => 'form-data', Content => [
        video => [$filePath],
        groupId => $grpId,
        phrase => $phrase,
        contentLanguage => $lang,
        doBlinkDetection => $blink
  ];
  $request->header('platformId' => $platformId);
  $request->authorization_basic($apiKey, $apiToken);
  my $reply = $ua->request($request);
  return $reply->content();
}


sub videoIdentificationByUrl(){
  shift;
  my $blink = 0;
  my ($grpId, $lang,  $phrase,$fileUrl, $doBlink) = @_;
  my $ua = LWP::UserAgent->new();
  if($doBlink){
    $blink = $doBlink;
  }
  my $request = POST $baseUrl.'/identification/video/byUrl', Content_Type => 'form-data', Content => [
        fileUrl => $fileUrl,
        groupId => $grpId,
        contentLanguage => $lang,
        phrase => $phrase,
        doBlinkDetection => $blink
  ];
  $request->header('platformId' => $platformId);
  $request->authorization_basic($apiKey, $apiToken);
  my $reply = $ua->request($request);
  return $reply->content();
}

1;
