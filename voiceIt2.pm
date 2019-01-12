package voiceIt2;

use strict;
require LWP::UserAgent;
use HTTP::Request::Common qw(POST);
use HTTP::Request::Common qw(DELETE);
use HTTP::Request::Common qw(PUT);
use HTTP::Request::Common qw(GET);
use URI::Escape;

my $self;
my $baseUrl = 'https://api.voiceit.io';
my $notificationUrl = '';
my $apiKey;
my $apiToken;
my $platformId = 38;
my $platformVersion = '3.16';

  sub new {
    my $package = shift;
    ($apiKey, $apiToken) = @_;
    $self = bless({apiKey => $apiKey, apiToken => $apiToken}, $package);
    return $self;
  }

  sub getPlatformVersion() {
    shift;
    return $platformVersion;
  }

  sub addNotificationUrl() {
    shift;
    $self->{notificationUrl} = '?notificationURL='.uri_escape(@_);
  }

  sub removeNotificationUrl() {
    shift;
    $self->{notificationUrl} = '';
  }

  sub getAllUsers() {
    shift;
    my $ua = LWP::UserAgent->new();
    my $request = GET $baseUrl.'/users'.$self->{notificationUrl};
    $request->header('platformId' => $platformId);
    $request->header('platformVersion' => $platformVersion);
    $request->authorization_basic($apiKey, $apiToken);
    my $reply = $ua->request($request);
    return $reply->content();
  }

  sub createUser() {
    shift;
    my $ua = LWP::UserAgent->new();
    my $request = POST $baseUrl.'/users'.$self->{notificationUrl};
    $request->header('platformId' => $platformId);
    $request->header('platformVersion' => $platformVersion);
    $request->authorization_basic($apiKey, $apiToken);
    my $reply = $ua->request($request);
    return $reply->content();
  }

  sub checkUserExists(){
    shift;
    my ($usrId) = @_;
    my $ua = LWP::UserAgent->new();
    my $request = GET $baseUrl.'/users/'.$usrId.$self->{notificationUrl};
    $request->header('platformId' => $platformId);
    $request->header('platformVersion' => $platformVersion);
    $request->authorization_basic($apiKey, $apiToken);
    my $reply = $ua->request($request);
    return $reply->content();
  }

  sub deleteUser(){
    shift;
    my ($usrId) = @_;
    my $ua = LWP::UserAgent->new();
    my $request = DELETE $baseUrl.'/users/'.$usrId.$self->{notificationUrl};
    $request->header('platformId' => $platformId);
    $request->header('platformVersion' => $platformVersion);
    $request->authorization_basic($apiKey, $apiToken);
    my $reply = $ua->request($request);
    return $reply->content();
  }

  sub getGroupsForUser(){
    shift;
    my ($usrId) = @_;
    my $ua = LWP::UserAgent->new();
    my $request = GET $baseUrl.'/users/'.$usrId.'/groups'.$self->{notificationUrl};
    $request->header('platformId' => $platformId);
    $request->header('platformVersion' => $platformVersion);
    $request->authorization_basic($apiKey, $apiToken);
    my $reply = $ua->request($request);
    return $reply->content();
  }

  sub getAllGroups(){
    shift;
    my $ua = LWP::UserAgent->new();
    my $request = GET $baseUrl.'/groups'.$self->{notificationUrl};
    $request->header('platformId' => $platformId);
    $request->header('platformVersion' => $platformVersion);
    $request->authorization_basic($apiKey, $apiToken);
    my $reply = $ua->request($request);
    return $reply->content();
  }


  sub getGroup(){
    shift;
    my ($groupId) = @_;
    my $ua = LWP::UserAgent->new();
    my $request = GET $baseUrl.'/groups/'.$groupId.$self->{notificationUrl};
    $request->header('platformId' => $platformId);
    $request->header('platformVersion' => $platformVersion);
    $request->authorization_basic($apiKey, $apiToken);
    my $reply = $ua->request($request);
    return $reply->content();
  }

sub groupExists(){
  shift;
  my ($groupId) = @_;
  my $ua = LWP::UserAgent->new();
  my $request = GET $baseUrl.'/groups/'.$groupId.'/exists'.$self->{notificationUrl};
  $request->header('platformId' => $platformId);
    $request->header('platformVersion' => $platformVersion);
  $request->authorization_basic($apiKey, $apiToken);
  my $reply = $ua->request($request);
  return $reply->content();
}

sub createGroup(){
  shift;
  my ($des)= @_;
  my $ua = LWP::UserAgent->new();
  my $request = POST $baseUrl.'/groups'.$self->{notificationUrl}, Content => [
      description => $des
  ];
  $request->header('platformId' => $platformId);
    $request->header('platformVersion' => $platformVersion);
  $request->authorization_basic($apiKey, $apiToken);
  my $reply = $ua->request($request);
  return $reply->content();
}

  sub addUserToGroup(){
    shift;
    my ($grpId, $usrId)= @_;
    my $ua = LWP::UserAgent->new();
    my $request = PUT $baseUrl.'/groups/addUser'.$self->{notificationUrl},
      Content => [
          groupId => $grpId,
          userId => $usrId,
      ];
    $request->header('platformId' => $platformId);
    $request->header('platformVersion' => $platformVersion);
    $request->authorization_basic($apiKey, $apiToken);
    my $reply = $ua->request($request);
    return $reply->content();
  }

  sub removeUserFromGroup(){
    shift;
    my ($grpId, $usrId)= @_;
    my $ua = LWP::UserAgent->new();
    my $request = PUT $baseUrl.'/groups/removeUser'.$self->{notificationUrl},
      Content => [
          groupId => $grpId,
          userId => $usrId,
      ];
    $request->header('platformId' => $platformId);
    $request->header('platformVersion' => $platformVersion);
    $request->authorization_basic($apiKey, $apiToken);
    my $reply = $ua->request($request);
    return $reply->content();
  }

  sub deleteGroup(){
    shift;
    my ($grpId)= @_;
    my $ua = LWP::UserAgent->new();
    my $request = DELETE $baseUrl.'/groups/'.$grpId.$self->{notificationUrl};
    $request->header('platformId' => $platformId);
    $request->header('platformVersion' => $platformVersion);
    $request->authorization_basic($apiKey, $apiToken);
    my $reply = $ua->request($request);
    return $reply->content();
  }

  sub getPhrases(){
    shift;
    my ($contentLanguage)= @_;
    my $ua = LWP::UserAgent->new();
    my $request = GET $baseUrl.'/phrases/'.$contentLanguage.$self->{notificationUrl};
    $request->header('platformId' => $platformId);
    $request->header('platformVersion' => $platformVersion);
    $request->authorization_basic($apiKey, $apiToken);
    my $reply = $ua->request($request);
    return $reply->content();
  }

  sub getAllFaceEnrollments(){
    shift;
    my ($usrId)= @_;
    my $ua = LWP::UserAgent->new();
    my $request = GET $baseUrl.'/enrollments/face/'.$usrId.$self->{notificationUrl};
    $request->header('platformId' => $platformId);
    $request->header('platformVersion' => $platformVersion);
    $request->authorization_basic($apiKey, $apiToken);
    my $reply = $ua->request($request);
    return $reply->content();
  }

  sub getAllVoiceEnrollments(){
    shift;
    my ($usrId)= @_;
    my $ua = LWP::UserAgent->new();
    my $request = GET $baseUrl.'/enrollments/voice/'.$usrId.$self->{notificationUrl};
    $request->header('platformId' => $platformId);
    $request->header('platformVersion' => $platformVersion);
    $request->authorization_basic($apiKey, $apiToken);
    my $reply = $ua->request($request);
    return $reply->content();
  }

  sub getAllVideoEnrollments(){
    shift;
    my ($usrId)= @_;
    my $ua = LWP::UserAgent->new();
    my $request = GET $baseUrl.'/enrollments/video/'.$usrId.$self->{notificationUrl};
    $request->header('platformId' => $platformId);
    $request->header('platformVersion' => $platformVersion);
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
    my $request = POST $baseUrl.'/enrollments/voice'.$self->{notificationUrl}, Content_Type => 'form-data',  Content => [
          recording => [$filePath],
          userId => $usrId,
          contentLanguage => $lang,
          phrase => $phrase
      ];
    $request->header('platformId' => $platformId);
    $request->header('platformVersion' => $platformVersion);
    $request->authorization_basic($apiKey, $apiToken);
    my $reply = $ua->request($request);
    return $reply->content();
  }

  sub createVoiceEnrollmentByUrl(){
    shift;
    my ($usrId, $lang,  $phrase, $fileUrl) = @_;
    my $ua = LWP::UserAgent->new();
    my $request = POST $baseUrl.'/enrollments/voice/byUrl'.$self->{notificationUrl}, Content_Type => 'form-data',  Content => [
          fileUrl => $fileUrl,
          userId => $usrId,
          phrase => $phrase,
          contentLanguage => $lang
      ];
    $request->header('platformId' => $platformId);
    $request->header('platformVersion' => $platformVersion);
    $request->authorization_basic($apiKey, $apiToken);
    my $reply = $ua->request($request);
    return $reply->content();
  }

  sub createFaceEnrollment(){
    shift;
    my ($usrId, $filePath) = @_;
    my $ua = LWP::UserAgent->new();
    if (!(-e $filePath)) {
      die "FileNotFound: No such file or directory \"".$filePath."\" \@createFaceEnrollment";
    }
    my $request = POST $baseUrl.'/enrollments/face'.$self->{notificationUrl}, Content_Type => 'form-data',  Content => [
          video => [$filePath],
          userId => $usrId
      ];
    $request->header('platformId' => $platformId);
    $request->header('platformVersion' => $platformVersion);
    $request->authorization_basic($apiKey, $apiToken);
    my $reply = $ua->request($request);
    return $reply->content();
  }

  sub createFaceEnrollmentByUrl(){
    shift;
    my ($usrId, $fileUrl) = @_;
    my $ua = LWP::UserAgent->new();
    my $request = POST $baseUrl.'/enrollments/face/byUrl'.$self->{notificationUrl}, Content_Type => 'form-data', Content => [
          fileUrl => $fileUrl,
          userId => $usrId
    ];
    $request->header('platformId' => $platformId);
    $request->header('platformVersion' => $platformVersion);
    $request->authorization_basic($apiKey, $apiToken);
    my $reply = $ua->request($request);
    return $reply->content();
  }

  sub createVideoEnrollment(){
    shift;
    my ($usrId, $lang,  $phrase,$filePath) = @_;
    my $ua = LWP::UserAgent->new();
    if (!(-e $filePath)) {
      die "FileNotFound: No such file or directory \"".$filePath."\" \@createVideoEnrollment";
    }
    my $request = POST $baseUrl.'/enrollments/video'.$self->{notificationUrl}, Content_Type => 'form-data', Content => [
          video => [$filePath],
          userId => $usrId,
          contentLanguage => $lang,
          phrase => $phrase
    ];
    $request->header('platformId' => $platformId);
    $request->header('platformVersion' => $platformVersion);
    $request->authorization_basic($apiKey, $apiToken);
    my $reply = $ua->request($request);
    return $reply->content();
  }

  sub createVideoEnrollmentByUrl(){
    shift;
    my ($usrId, $lang,  $phrase,$fileUrl) = @_;
    my $ua = LWP::UserAgent->new();
    my $request = POST $baseUrl.'/enrollments/video/byUrl'.$self->{notificationUrl}, Content_Type => 'form-data', Content => [
          fileUrl => $fileUrl,
          userId => $usrId,
          contentLanguage => $lang,
          phrase => $phrase
    ];
    $request->header('platformId' => $platformId);
    $request->header('platformVersion' => $platformVersion);
    $request->authorization_basic($apiKey, $apiToken);
    my $reply = $ua->request($request);
    return $reply->content();
  }

  sub deleteAllEnrollments() {
    shift;
    my ($usrId) = @_;
    my $ua = LWP::UserAgent->new();
    my $request = DELETE $baseUrl.'/enrollments/'.$usrId.'/all'.$self->{notificationUrl}, Content_Type => 'form-data';
    $request->header('platformId' => $platformId);
    $request->header('platformVersion' => $platformVersion);
    $request->authorization_basic($apiKey, $apiToken);
    my $reply = $ua->request($request);
    return $reply->content();
  }

  sub deleteAllVoiceEnrollments() {
    shift;
    my ($usrId) = @_;
    my $ua = LWP::UserAgent->new();
    my $request = DELETE $baseUrl.'/enrollments/'.$usrId.'/voice'.$self->{notificationUrl}, Content_Type => 'form-data';
    $request->header('platformId' => $platformId);
    $request->header('platformVersion' => $platformVersion);
    $request->authorization_basic($apiKey, $apiToken);
    my $reply = $ua->request($request);
    return $reply->content();
  }

  sub deleteAllFaceEnrollments() {
    shift;
    my ($usrId) = @_;
    my $ua = LWP::UserAgent->new();
    my $request = DELETE $baseUrl.'/enrollments/'.$usrId.'/face'.$self->{notificationUrl}, Content_Type => 'form-data';
    $request->header('platformId' => $platformId);
    $request->header('platformVersion' => $platformVersion);
    $request->authorization_basic($apiKey, $apiToken);
    my $reply = $ua->request($request);
    return $reply->content();
  }

  sub deleteAllVideoEnrollments() {
    shift;
    my ($usrId) = @_;
    my $ua = LWP::UserAgent->new();
    my $request = DELETE $baseUrl.'/enrollments/'.$usrId.'/video', Content_Type => 'form-data';
    $request->header('platformId' => $platformId);
    $request->header('platformVersion' => $platformVersion);
    $request->authorization_basic($apiKey, $apiToken);
    my $reply = $ua->request($request);
    return $reply->content();
  }

  sub deleteFaceEnrollment(){
    shift;
    my ($usrId, $faceEnrollmentId) = @_;
    my $ua = LWP::UserAgent->new();
    my $request = DELETE $baseUrl.'/enrollments/face/'.$usrId.'/'.$faceEnrollmentId.$self->{notificationUrl}, Content_Type => 'form-data';
    $request->header('platformId' => $platformId);
    $request->header('platformVersion' => $platformVersion);
    $request->authorization_basic($apiKey, $apiToken);
    my $reply = $ua->request($request);
    return $reply->content();
  }

  sub deleteVoiceEnrollment(){
    shift;
    my ($usrId, $voiceEnrollmentId) = @_;
    my $ua = LWP::UserAgent->new();
    my $request = DELETE $baseUrl.'/enrollments/voice/'.$usrId.'/'.$voiceEnrollmentId.$self->{notificationUrl}, Content_Type => 'form-data';
    $request->header('platformId' => $platformId);
    $request->header('platformVersion' => $platformVersion);
    $request->authorization_basic($apiKey, $apiToken);
    my $reply = $ua->request($request);
    return $reply->content();
  }


  sub deleteVideoEnrollment(){
    shift;
    my ($usrId, $videoEnrollmentId) = @_;
    my $ua = LWP::UserAgent->new();
    my $request = DELETE $baseUrl.'/enrollments/video/'.$usrId.'/'.$videoEnrollmentId.$self->{notificationUrl}.$self->{notificationUrl}, Content_Type => 'form-data';
    $request->header('platformId' => $platformId);
    $request->header('platformVersion' => $platformVersion);
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
    my $request = POST $baseUrl.'/verification/voice'.$self->{notificationUrl}, Content_Type => 'form-data', Content => [
          recording => [$filePath],
          userId => $usrId,
          phrase => $phrase,
          contentLanguage => $lang
    ];
    $request->header('platformId' => $platformId);
    $request->header('platformVersion' => $platformVersion);
    $request->authorization_basic($apiKey, $apiToken);
    my $reply = $ua->request($request);
    return $reply->content();
  }

  sub voiceVerificationByUrl(){
    shift;
    my ($usrId, $lang,  $phrase,$fileUrl) = @_;
    my $ua = LWP::UserAgent->new();
    my $request = POST $baseUrl.'/verification/voice/byUrl'.$self->{notificationUrl}, Content_Type => 'form-data', Content => [
          fileUrl => $fileUrl,
          userId => $usrId,
          phrase => $phrase,
          contentLanguage => $lang
    ];
    $request->header('platformId' => $platformId);
    $request->header('platformVersion' => $platformVersion);
    $request->authorization_basic($apiKey, $apiToken);
    my $reply = $ua->request($request);
    return $reply->content();
  }

  sub faceVerification(){
    shift;
    my ($usrId, $filePath) = @_;
    my $ua = LWP::UserAgent->new();
    if (!(-e $filePath)) {
      die "FileNotFound: No such file or directory \"".$filePath."\" \@faceVerification";
    }
    my $request = POST $baseUrl.'/verification/face'.$self->{notificationUrl}, Content_Type => 'form-data', Content => [
          video => [$filePath],
          userId => $usrId
    ];
    $request->header('platformId' => $platformId);
    $request->header('platformVersion' => $platformVersion);
    $request->authorization_basic($apiKey, $apiToken);
    my $reply = $ua->request($request);
    return $reply->content();
  }

  sub faceVerificationByUrl(){
    shift;
    my ($usrId, $fileUrl) = @_;
    my $ua = LWP::UserAgent->new();
    my $request = POST $baseUrl.'/verification/face/byUrl'.$self->{notificationUrl}, Content_Type => 'form-data', Content => [
          fileUrl => $fileUrl,
          userId => $usrId
    ];
    $request->header('platformId' => $platformId);
    $request->header('platformVersion' => $platformVersion);
    $request->authorization_basic($apiKey, $apiToken);
    my $reply = $ua->request($request);
    return $reply->content();
  }

  sub videoVerification(){
    shift;
    my ($usrId, $lang, $phrase, $filePath) = @_;
    if (!(-e $filePath)) {
      die "FileNotFound: No such file or directory \"".$filePath."\" \@videoVerification";
    }
    my $ua = LWP::UserAgent->new();
    my $request = POST $baseUrl.'/verification/video'.$self->{notificationUrl}, Content_Type => 'form-data', Content => [
          video => [$filePath],
          userId => $usrId,
          phrase => $phrase,
          contentLanguage => $lang
    ];
    $request->header('platformId' => $platformId);
    $request->header('platformVersion' => $platformVersion);
    $request->authorization_basic($apiKey, $apiToken);
    my $reply = $ua->request($request);
    return $reply->content();
  }


  sub videoVerificationByUrl(){
    shift;
    my ($usrId, $lang, $phrase, $fileUrl) = @_;
    my $ua = LWP::UserAgent->new();
    my $request = POST $baseUrl.'/verification/video/byUrl'.$self->{notificationUrl}, Content_Type => 'form-data', Content => [
          fileUrl => $fileUrl,
          userId => $usrId,
          phrase => $phrase,
          contentLanguage => $lang
    ];
    $request->header('platformId' => $platformId);
    $request->header('platformVersion' => $platformVersion);
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
    my $request = POST $baseUrl.'/identification/voice'.$self->{notificationUrl}, Content_Type => 'form-data', Content => [
          recording => [$filePath],
          groupId => $grpId,
          phrase => $phrase,
          contentLanguage => $lang,
    ];
    $request->header('platformId' => $platformId);
    $request->header('platformVersion' => $platformVersion);
    $request->authorization_basic($apiKey, $apiToken);
    my $reply = $ua->request($request);
    return $reply->content();
  }

  sub voiceIdentificationByUrl(){
    shift;
    my ($grpId, $lang, $phrase, $fileUrl) = @_;
    my $ua = LWP::UserAgent->new();
    my $request = POST $baseUrl.'/identification/voice/byUrl'.$self->{notificationUrl}, Content_Type => 'form-data', Content => [
          fileUrl => $fileUrl,
          groupId => $grpId,
          phrase => $phrase,
          contentLanguage => $lang,
    ];
    $request->header('platformId' => $platformId);
    $request->header('platformVersion' => $platformVersion);
    $request->authorization_basic($apiKey, $apiToken);
    my $reply = $ua->request($request);
    return $reply->content();
  }

  sub faceIdentification(){
    shift;
    my ($grpId, $filePath) = @_;
    if (!(-e $filePath)) {
      die "FileNotFound: No such file or directory \"".$filePath."\" \@faceIdentification";
    }
    my $ua = LWP::UserAgent->new();
    my $request = POST $baseUrl.'/identification/face'.$self->{notificationUrl}, Content_Type => 'form-data', Content => [
          video => [$filePath],
          groupId => $grpId
    ];
    $request->header('platformId' => $platformId);
    $request->header('platformVersion' => $platformVersion);
    $request->authorization_basic($apiKey, $apiToken);
    my $reply = $ua->request($request);
    return $reply->content();
  }

  sub faceIdentificationByUrl(){
    shift;
    my ($grpId, $fileUrl) = @_;
    my $ua = LWP::UserAgent->new();
    my $request = POST $baseUrl.'/identification/face/byUrl'.$self->{notificationUrl}, Content_Type => 'form-data', Content => [
          fileUrl => $fileUrl,
          groupId => $grpId
    ];
    $request->header('platformId' => $platformId);
    $request->header('platformVersion' => $platformVersion);
    $request->authorization_basic($apiKey, $apiToken);
    my $reply = $ua->request($request);
    return $reply->content();
  }

  sub videoIdentification(){
    shift;
    my ($grpId, $lang, $phrase, $filePath) = @_;
    if (!(-e $filePath)) {
      die "FileNotFound: No such file or directory \"".$filePath."\" \@videoIdentification";
    }
    my $ua = LWP::UserAgent->new();
    my $request = POST $baseUrl.'/identification/video'.$self->{notificationUrl}, Content_Type => 'form-data', Content => [
          video => [$filePath],
          groupId => $grpId,
          phrase => $phrase,
          contentLanguage => $lang
    ];
    $request->header('platformId' => $platformId);
    $request->header('platformVersion' => $platformVersion);
    $request->authorization_basic($apiKey, $apiToken);
    my $reply = $ua->request($request);
    return $reply->content();
  }


  sub videoIdentificationByUrl(){
    shift;
    my ($grpId, $lang,  $phrase,$fileUrl) = @_;
    my $ua = LWP::UserAgent->new();
    my $request = POST $baseUrl.'/identification/video/byUrl'.$self->{notificationUrl}, Content_Type => 'form-data', Content => [
          fileUrl => $fileUrl,
          groupId => $grpId,
          contentLanguage => $lang,
          phrase => $phrase
    ];
    $request->header('platformId' => $platformId);
    $request->header('platformVersion' => $platformVersion);
    $request->authorization_basic($apiKey, $apiToken);
    my $reply = $ua->request($request);
    return $reply->content();
  }

  sub createUserToken() {
    shift;
    my ($userId, $secondsToTimeout) = @_;
    my $ua = LWP::UserAgent->new();
    my $request = POST $baseUrl.'/users/'.$userId.'/token?timeOut='.$secondsToTimeout;
    $request->header('platformId' => $platformId);
    $request->header('platformVersion' => $platformVersion);
    $request->authorization_basic($apiKey, $apiToken);
    my $reply = $ua->request($request);
    return $reply->content();
  }

1;
