require './voiceIt2.pm';
use JSON::Parse 'parse_json';
use LWP::Simple;
print "**** Started Testing ****\n";
my $self;

my $myVoiceIt = voiceIt2->new($ENV{'VIAPIKEY'}, $ENV{'VIAPITOKEN'});

# Test Webhook
$myVoiceIt->addNotificationUrl('https://voiceit.io');
if ($ENV{'BOXFUSE_ENV'} == 'voiceittest') {
  my $filename = $ENV{'HOME'}.'/platformVersion';
  open(my $fh, '>', $filename) or die "Could not open file '$filename' $!";
  print $fh $myVoiceIt->getPlatformVersion();
  close $fh;
}

assertEqual('?notificationURL=https%3A%2F%2Fvoiceit.io', $myVoiceIt->{notificationUrl}, __LINE__);
$myVoiceIt->removeNotificationUrl();
assertEqual('', $myVoiceIt->{notificationUrl}, __LINE__);

print "**** Webhooks Tests All Passed ****\n";

# Test Basics
my $json = parse_json($myVoiceIt->createUser());
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);
my $userId = $json->{userId};

$json = parse_json($myVoiceIt->getAllUsers());
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);
assertGreaterThan(0, length $json->{users}, __LINE__);

$json = parse_json($myVoiceIt->checkUserExists($userId));
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

$json = parse_json($myVoiceIt->createGroup('Sample Group Description'));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);
my $groupId = $json->{groupId};

$json = parse_json($myVoiceIt->getAllGroups());
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);
assertGreaterThan(0, length $json->{groups}, __LINE__);

$json = parse_json($myVoiceIt->getGroup($groupId));
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

$json = parse_json($myVoiceIt->groupExists($groupId));
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

$json = parse_json($myVoiceIt->addUserToGroup($groupId, $userId));
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

$json = parse_json($myVoiceIt->getGroupsForUser($userId));
assertEqual(200, $json->{status});
assertEqual('SUCC', $json->{responseCode}, __LINE__);
assertEqual(1, $json->{count}, __LINE__);

$json = parse_json($myVoiceIt->removeUserFromGroup($groupId, $userId));
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

$json = parse_json($myVoiceIt->createUserToken($userId, 5));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

$json = parse_json($myVoiceIt->expireUserTokens($userId));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

$json = parse_json($myVoiceIt->deleteUser($userId));
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

$json = parse_json($myVoiceIt->deleteGroup($groupId));
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

$json = parse_json($myVoiceIt->getPhrases('en-US'));
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

print "**** Basic Tests All Passed ****\n";

# Test SubAccounts

my $json = parse_json($myVoiceIt->createManagedSubAccount('Test','Perl', '', '', ''));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);
my $managedSubAccountAPI = $json->{apiKey};

my $json = parse_json($myVoiceIt->createUnmanagedSubAccount('Test','Perl', '', '', ''));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);
my $unmanagedSubAccountAPI = $json->{apiKey};

my $json = parse_json($myVoiceIt->regenerateSubAccountAPIToken($managedSubAccountAPI));
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

my $json = parse_json($myVoiceIt->deleteSubAccount($managedSubAccountAPI));
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

my $json = parse_json($myVoiceIt->deleteSubAccount($unmanagedSubAccountAPI));
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);
print "**** Sub Account Tests All Passed ****\n";

# Test Video
$json = parse_json($myVoiceIt->createUser());
my $userId1 = $json->{userId};
$json = parse_json($myVoiceIt->createUser());
my $userId2 = $json->{userId};
$json = parse_json($myVoiceIt->createGroup('Sample Group Description'));
$groupId = $json->{groupId};
$myVoiceIt->addUserToGroup($groupId, $userId1);
$myVoiceIt->addUserToGroup($groupId, $userId2);

# Video Enrollments
getstore('https://drive.voiceit.io/files/videoEnrollmentB1.mov', './videoEnrollmentB1.mov');
getstore('https://drive.voiceit.io/files/videoEnrollmentB2.mov', './videoEnrollmentB2.mov');
getstore('https://drive.voiceit.io/files/videoEnrollmentB3.mov', './videoEnrollmentB3.mov');
getstore('https://drive.voiceit.io/files/videoVerificationB1.mov', './videoVerificationB1.mov');
getstore('https://drive.voiceit.io/files/videoEnrollmentC1.mov', './videoEnrollmentC1.mov');
getstore('https://drive.voiceit.io/files/videoEnrollmentC2.mov', './videoEnrollmentC2.mov');
getstore('https://drive.voiceit.io/files/videoEnrollmentC3.mov', './videoEnrollmentC3.mov');
eval {
$json = parse_json($myVoiceIt->createVideoEnrollment($userId1, 'en-US', 'Never Forget Tomorrow is a new day', './notareeal.file'));
};
if ($@) {
  my @exception = split(':', $@);
  assertEqual('FileNotFound',@exception[0]);
} else {
  die "Testing Failed";
}

$json = parse_json($myVoiceIt->createVideoEnrollment($userId1, 'en-US', 'Never Forget Tomorrow is a new day','./videoEnrollmentB1.mov'));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);
my $enrollmentId1 = $json->{id};
$json = parse_json($myVoiceIt->createVideoEnrollment($userId1, 'en-US','Never Forget Tomorrow is a new day', './videoEnrollmentB2.mov'));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);
my $enrollmentId2 = $json->{id};
$json = parse_json($myVoiceIt->createVideoEnrollment($userId1, 'en-US', 'Never Forget Tomorrow is a new day','./videoEnrollmentB3.mov'));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);
my $enrollmentId3 = $json->{id};
$json = parse_json($myVoiceIt->getAllVideoEnrollments($userId1));
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);
assertEqual(3, $json->{count}, __LINE__);
$json = parse_json($myVoiceIt->createVideoEnrollment($userId2, 'en-US', 'Never Forget Tomorrow is a new day','./videoEnrollmentC1.mov'));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);
$json = parse_json($myVoiceIt->createVideoEnrollment($userId2, 'en-US','Never Forget Tomorrow is a new day', './videoEnrollmentC2.mov'));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);
$json = parse_json($myVoiceIt->createVideoEnrollment($userId2, 'en-US','Never Forget Tomorrow is a new day', './videoEnrollmentC3.mov'));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);


# Video Verification
eval {
$json = parse_json($myVoiceIt->videoVerification($userId1, 'en-US','Never Forget Tomorrow is a new day', './notareeal.file'));
};
if ($@) {
  my @exception = split(':', $@);
  assertEqual('FileNotFound',@exception[0]);
} else {
  die "Testing Failed";
}
$json = parse_json($myVoiceIt->videoVerification($userId1, 'en-US', 'Never Forget Tomorrow is a new day','./videoVerificationB1.mov'));
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

# Video Identification
eval {
$json = parse_json($myVoiceIt->videoIdentification($groupId, 'en-US','Never Forget Tomorrow is a new day', './notareeal.file'));
};
if ($@) {
  my @exception = split(':', $@);
  assertEqual('FileNotFound',@exception[0]);
} else {
  die "Testing Failed";
}
$json = parse_json($myVoiceIt->videoIdentification($groupId, 'en-US','Never Forget Tomorrow is a new day', './videoVerificationB1.mov'));
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);
assertEqual($userId1, $json->{userId}, __LINE__);

# Reset for ...byUrl calls

$myVoiceIt->deleteAllEnrollments($userId1);
$myVoiceIt->deleteAllEnrollments($userId2);
$myVoiceIt->deleteUser($userId1);
$myVoiceIt->deleteUser($userId2);
$myVoiceIt->deleteGroup($groupId);


$json = parse_json($myVoiceIt->createUser());
my $userId1 = $json->{userId};
$json = parse_json($myVoiceIt->createUser());
my $userId2 = $json->{userId};
$json = parse_json($myVoiceIt->createGroup('Sample Group Description'));
$groupId = $json->{groupId};
$myVoiceIt->addUserToGroup($groupId, $userId1);
$myVoiceIt->addUserToGroup($groupId, $userId2);


# Video Enrollment By URL
$json = parse_json($myVoiceIt->createVideoEnrollmentByUrl($userId1, 'en-US', 'Never Forget Tomorrow is a new day','https://drive.voiceit.io/files/videoEnrollmentB1.mov'));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

$json = parse_json($myVoiceIt->createVideoEnrollmentByUrl($userId1, 'en-US','Never Forget Tomorrow is a new day', 'https://drive.voiceit.io/files/videoEnrollmentB2.mov'));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

$json = parse_json($myVoiceIt->createVideoEnrollmentByUrl($userId1, 'en-US', 'Never Forget Tomorrow is a new day','https://drive.voiceit.io/files/videoEnrollmentB3.mov'));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

$json = parse_json($myVoiceIt->createVideoEnrollmentByUrl($userId2, 'en-US', 'Never Forget Tomorrow is a new day','https://drive.voiceit.io/files/videoEnrollmentC1.mov'));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

$json = parse_json($myVoiceIt->createVideoEnrollmentByUrl($userId2, 'en-US','Never Forget Tomorrow is a new day', 'https://drive.voiceit.io/files/videoEnrollmentC2.mov'));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

$json = parse_json($myVoiceIt->createVideoEnrollmentByUrl($userId2, 'en-US','Never Forget Tomorrow is a new day', 'https://drive.voiceit.io/files/videoEnrollmentC3.mov'));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

# Video Verification By URL
$json = parse_json($myVoiceIt->videoVerificationByUrl($userId1, 'en-US', 'Never Forget Tomorrow is a new day','https://drive.voiceit.io/files/videoVerificationB1.mov'));
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

# Video Identification By URL
$json = parse_json($myVoiceIt->videoIdentificationByUrl($groupId, 'en-US','Never Forget Tomorrow is a new day', 'https://drive.voiceit.io/files/videoVerificationB1.mov'));
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);
assertEqual($userId1, $json->{userId}, __LINE__);


$myVoiceIt->deleteAllEnrollments($userId1);
$myVoiceIt->deleteAllEnrollments($userId2);
$myVoiceIt->deleteUser($userId1);
$myVoiceIt->deleteUser($userId2);
$myVoiceIt->deleteGroup($groupId);

unlink './videoEnrollmentB1.mov';
unlink './videoEnrollmentB2.mov';
unlink './videoEnrollmentB3.mov';
unlink './videoVerificationB1.mov';
unlink './videoEnrollmentC1.mov';
unlink './videoEnrollmentC2.mov';
unlink './videoEnrollmentC3.mov';

print "**** Video Tests All Passed ****\n";

# Test Voice
$json = parse_json($myVoiceIt->createUser());
$userId1 = $json->{userId};
$json = parse_json($myVoiceIt->createUser());
$userId2 = $json->{userId};
$json = parse_json($myVoiceIt->createGroup('Sample Group Description'));
$groupId = $json->{groupId};
$myVoiceIt->addUserToGroup($groupId, $userId1);
$myVoiceIt->addUserToGroup($groupId, $userId2);


# Voice Enrollments
getstore('https://drive.voiceit.io/files/enrollmentA1.wav', './enrollmentA1.wav');
getstore('https://drive.voiceit.io/files/enrollmentA2.wav', './enrollmentA2.wav');
getstore('https://drive.voiceit.io/files/enrollmentA3.wav', './enrollmentA3.wav');
getstore('https://drive.voiceit.io/files/verificationA1.wav', './verificationA1.wav');
getstore('https://drive.voiceit.io/files/enrollmentC1.wav', './enrollmentC1.wav');
getstore('https://drive.voiceit.io/files/enrollmentC2.wav', './enrollmentC2.wav');
getstore('https://drive.voiceit.io/files/enrollmentC3.wav', './enrollmentC3.wav');

eval {
$json = parse_json($myVoiceIt->createVoiceEnrollment($userId1, 'en-US','Never Forget Tomorrow is a new day', './enrollmentArmaa.wav'));
};
if ($@) {
  my @exception = split(':', $@);
  assertEqual('FileNotFound',@exception[0]);
} else {
  die "Testing Failed";
}

$json = parse_json($myVoiceIt->createVoiceEnrollment($userId1, 'en-US','Never Forget Tomorrow is a new day', './enrollmentA1.wav'));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

$json = parse_json($myVoiceIt->createVoiceEnrollment($userId1, 'en-US', 'Never Forget Tomorrow is a new day','./enrollmentA2.wav'));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

$json = parse_json($myVoiceIt->createVoiceEnrollment($userId1, 'en-US','Never Forget Tomorrow is a new day', './enrollmentA3.wav'));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);
my $voiceEnrollmentId1 = $json->{id};

$json = parse_json($myVoiceIt->getAllVoiceEnrollments($userId1));
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);
assertEqual(3, $json->{count}, __LINE__);

$json = parse_json($myVoiceIt->createVoiceEnrollment($userId2, 'en-US','Never Forget Tomorrow is a new day', './enrollmentC1.wav'));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

$json = parse_json($myVoiceIt->createVoiceEnrollment($userId2, 'en-US','Never Forget Tomorrow is a new day', './enrollmentC2.wav'));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

$json = parse_json($myVoiceIt->createVoiceEnrollment($userId2, 'en-US','Never Forget Tomorrow is a new day', './enrollmentC3.wav'));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

# Voice Verification
eval {
$json = parse_json($myVoiceIt->voiceVerification($userId1, 'en-US','Never Forget Tomorrow is a new day', './verificationArmaaewd.wav'));
};
if ($@) {
  my @exception = split(':', $@);
  assertEqual('FileNotFound',@exception[0]);
} else {
  die "Testing Failed";
}

$json = parse_json($myVoiceIt->voiceVerification($userId1, 'en-US','Never Forget Tomorrow is a new day', './verificationA1.wav'));
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

# Voice Identification
$json = parse_json($myVoiceIt->voiceIdentification($groupId, 'en-US', 'Never Forget Tomorrow is a new day','./verificationA1.wav'));
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);
assertEqual($userId1, $json->{userId}, __LINE__);

$myVoiceIt->deleteAllEnrollments($userId1);
$myVoiceIt->deleteAllEnrollments($userId2);

# Reset for ...byUrl calls

$myVoiceIt->deleteUser($userId1);
$myVoiceIt->deleteUser($userId2);
$myVoiceIt->deleteGroup($groupId);

$json = parse_json($myVoiceIt->createUser());
my $userId1 = $json->{userId};
$json = parse_json($myVoiceIt->createUser());
my $userId2 = $json->{userId};
$json = parse_json($myVoiceIt->createGroup('Sample Group Description'));
$groupId = $json->{groupId};
$myVoiceIt->addUserToGroup($groupId, $userId1);
$myVoiceIt->addUserToGroup($groupId, $userId2);


# Voice Enrollment By URL
$json = parse_json($myVoiceIt->createVoiceEnrollmentByUrl($userId1, 'en-US', 'Never Forget Tomorrow is a new day','https://drive.voiceit.io/files/enrollmentA1.wav'));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

$json = parse_json($myVoiceIt->createVoiceEnrollmentByUrl($userId1, 'en-US','Never Forget Tomorrow is a new day', 'https://drive.voiceit.io/files/enrollmentA2.wav'));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

$json = parse_json($myVoiceIt->createVoiceEnrollmentByUrl($userId1, 'en-US', 'Never Forget Tomorrow is a new day','https://drive.voiceit.io/files/enrollmentA3.wav'));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

$json = parse_json($myVoiceIt->createVoiceEnrollmentByUrl($userId2, 'en-US', 'Never Forget Tomorrow is a new day','https://drive.voiceit.io/files/enrollmentC1.wav'));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

$json = parse_json($myVoiceIt->createVoiceEnrollmentByUrl($userId2, 'en-US', 'Never Forget Tomorrow is a new day','https://drive.voiceit.io/files/enrollmentC2.wav'));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

$json = parse_json($myVoiceIt->createVoiceEnrollmentByUrl($userId2, 'en-US','Never Forget Tomorrow is a new day', 'https://drive.voiceit.io/files/enrollmentC3.wav'));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

# Voice Verification By URL
$json = parse_json($myVoiceIt->voiceVerificationByUrl($userId1, 'en-US','Never Forget Tomorrow is a new day', 'https://drive.voiceit.io/files/verificationA1.wav'));
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

# Voice Identification By URL
$json = parse_json($myVoiceIt->voiceIdentificationByUrl($groupId, 'en-US','Never Forget Tomorrow is a new day', 'https://drive.voiceit.io/files/verificationA1.wav'));
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);
assertEqual($userId1, $json->{userId}, __LINE__);


$myVoiceIt->deleteAllEnrollments($userId1);
$myVoiceIt->deleteAllEnrollments($userId2);
$myVoiceIt->deleteUser($userId1);
$myVoiceIt->deleteUser($userId2);
$myVoiceIt->deleteGroup($groupId);

unlink './enrollmentA1.wav';
unlink './enrollmentA2.wav';
unlink './enrollmentA3.wav';
unlink './verificationA1.wav';
unlink './enrollmentC1.wav';
unlink './enrollmentC2.wav';
unlink './enrollmentC3.wav';

print "****Voice Tests All Passed ****\n";


# Test Face
$json = parse_json($myVoiceIt->createUser());
$userId1 = $json->{userId};
$json = parse_json($myVoiceIt->createUser());
$userId2 = $json->{userId};
$json = parse_json($myVoiceIt->createGroup('Sample Group Description'));
$groupId = $json->{groupId};
$myVoiceIt->addUserToGroup($groupId, $userId1);
$myVoiceIt->addUserToGroup($groupId, $userId2);

# Face Enrollments
getstore('https://drive.voiceit.io/files/faceEnrollmentB1.mp4', './faceEnrollmentB1.mp4');
getstore('https://drive.voiceit.io/files/faceEnrollmentB2.mp4', './faceEnrollmentB2.mp4');
getstore('https://drive.voiceit.io/files/faceEnrollmentB3.mp4', './faceEnrollmentB3.mp4');
getstore('https://drive.voiceit.io/files/videoEnrollmentC1.mov', './faceEnrollmentC1.mov');
getstore('https://drive.voiceit.io/files/faceVerificationB1.mp4', './faceVerificationB1.mp4');

eval {
$json = parse_json($myVoiceIt->createFaceEnrollment($userId1, './faceEnrollmentBds.mp4'));
};
if ($@) {
  my @exception = split(':', $@);
  assertEqual('FileNotFound',@exception[0]);
} else {
  die "Testing Failed";
}
$json = parse_json($myVoiceIt->createFaceEnrollment($userId1, './faceEnrollmentB1.mp4'));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

$json = parse_json($myVoiceIt->createFaceEnrollmentByUrl($userId1, 'https://drive.voiceit.io/files/faceEnrollmentB1.mp4'));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);
my $faceEnrollmentId1 = $json->{faceEnrollmentId};

$json = parse_json($myVoiceIt->createFaceEnrollment($userId2, './faceEnrollmentC1.mov'));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);
my $faceEnrollmentId2 = $json->{faceEnrollmentId};

# Get All Face Enrollments for User
$json = parse_json($myVoiceIt->getAllFaceEnrollments($userId1));
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);
assertEqual(2, $json->{count}, __LINE__);

# Face Verification
eval {
$json = parse_json($myVoiceIt->faceVerification($userId1, './faceVerificationArma.mp4'));
};
if ($@) {
  my @exception = split(':', $@);
  assertEqual('FileNotFound',@exception[0]);
} else {
  die "Testing Failed";
}

$json = parse_json($myVoiceIt->faceVerification($userId1, './faceVerificationB1.mp4'));
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

$json = parse_json($myVoiceIt->faceVerificationByUrl($userId1, 'https://drive.voiceit.io/files/faceVerificationB1.mp4'));
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

$json = parse_json($myVoiceIt->faceIdentification($groupId, './faceVerificationB1.mp4'));
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);
assertEqual($userId1, $json->{userId}, __LINE__);

$json = parse_json($myVoiceIt->faceIdentificationByUrl($groupId, 'https://drive.voiceit.io/files/faceVerificationB1.mp4'));
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);
assertEqual($userId1, $json->{userId}, __LINE__);

$myVoiceIt->deleteUser($userId1);
$myVoiceIt->deleteUser($userId2);

unlink './faceEnrollmentB1.mp4';
unlink './faceEnrollmentB2.mp4';
unlink './faceEnrollmentB3.mp4';
unlink './faceVerificationB1.mp4';
unlink './faceEnrollmentC1.mov';

print "**** Face Tests All Passed **** \n";
print "**** All Tests Passed **** \n";



sub assertEqual {
  my ($arg1, $arg2, $line) = @_;
  if (!$arg1 & ~$arg1) {
    if ($arg1 != $arg2) {
      print $arg1.' does not == '.$arg2.' on line '.$line."\n";
      exit 1;
    }
  } else {
    if ($arg1 ne $arg2) {
      print $arg1.' does not == '.$arg2.' on line '.$line."\n";
      exit 1;
    }
  }
}

sub assertGreaterThan {
  my ($arg1, $arg2, $line) = @_;
  if (!$arg1 > $arg2) {
    print $arg1.' is not > '.$arg2.' on line '.$line."\n";
    exit 1;
  }
}
