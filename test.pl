require './voiceIt2.pm';
use JSON::Parse 'parse_json';
use LWP::Simple;

my $self;

my $myVoiceIt = voiceIt2->new($ENV{'VIAPIKEY'}, $ENV{'VIAPITOKEN'});

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

$json = parse_json($myVoiceIt->deleteUser($userId));
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

$json = parse_json($myVoiceIt->deleteGroup($groupId));
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

print '****Basic Tests All Passed****
';

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
getstore('https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/videoEnrollmentArmaan1.mov', './videoEnrollmentArmaan1.mov');
getstore('https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/videoEnrollmentArmaan2.mov', './videoEnrollmentArmaan2.mov');
getstore('https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/videoEnrollmentArmaan3.mov', './videoEnrollmentArmaan3.mov');
getstore('https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/videoVerificationArmaan1.mov', './videoVerificationArmaan1.mov');
getstore('https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/videoEnrollmentStephen1.mov', './videoEnrollmentStephen1.mov');
getstore('https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/videoEnrollmentStephen2.mov', './videoEnrollmentStephen2.mov');
getstore('https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/videoEnrollmentStephen3.mov', './videoEnrollmentStephen3.mov');

$json = parse_json($myVoiceIt->createVideoEnrollment($userId1, 'en-US', './videoEnrollmentArmaan1.mov', 0));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);
my $enrollmentId1 = $json->{id};

$json = parse_json($myVoiceIt->createVideoEnrollment($userId1, 'en-US', './videoEnrollmentArmaan2.mov', 0));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);
my $enrollmentId2 = $json->{id};

$json = parse_json($myVoiceIt->createVideoEnrollment($userId1, 'en-US', './videoEnrollmentArmaan3.mov', 0));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);
my $enrollmentId3 = $json->{id};

$json = parse_json($myVoiceIt->createVideoEnrollment($userId2, 'en-US', './videoEnrollmentStephen1.mov', 0));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

$json = parse_json($myVoiceIt->createVideoEnrollment($userId2, 'en-US', './videoEnrollmentStephen2.mov', 0));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

$json = parse_json($myVoiceIt->createVideoEnrollment($userId2, 'en-US', './videoEnrollmentStephen3.mov', 0));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

# Get All Enrollments for User
$json = parse_json($myVoiceIt->getAllEnrollmentsForUser($userId1));
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);
assertEqual(3, $json->{count}, __LINE__);

# Video Verification
$json = parse_json($myVoiceIt->videoVerification($userId1, 'en-US', './videoVerificationArmaan1.mov', 0));
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

# Video Identification
$json = parse_json($myVoiceIt->videoIdentification($groupId, 'en-US', './videoVerificationArmaan1.mov', 0));
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);
assertEqual($userId1, $json->{userId}, __LINE__);

# Delete Enrollment for User
$json = parse_json($myVoiceIt->deleteEnrollment($userId1, $enrollmentId1));
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

$json = parse_json($myVoiceIt->deleteEnrollment($userId1, $enrollmentId2));
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

$json = parse_json($myVoiceIt->deleteEnrollment($userId1, $enrollmentId3));
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

# Delete All Enrollments
$json = parse_json($myVoiceIt->deleteAllEnrollmentsForUser($userId2));
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

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


# Video Enrollment By URL
$json = parse_json($myVoiceIt->createVideoEnrollmentByUrl($userId1, 'en-US', 'https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/videoEnrollmentArmaan1.mov', 0));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

$json = parse_json($myVoiceIt->createVideoEnrollmentByUrl($userId1, 'en-US', 'https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/videoEnrollmentArmaan2.mov', 0));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

$json = parse_json($myVoiceIt->createVideoEnrollmentByUrl($userId1, 'en-US', 'https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/videoEnrollmentArmaan3.mov', 0));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

$json = parse_json($myVoiceIt->createVideoEnrollmentByUrl($userId2, 'en-US', 'https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/videoEnrollmentStephen1.mov', 0));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

$json = parse_json($myVoiceIt->createVideoEnrollmentByUrl($userId2, 'en-US', 'https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/videoEnrollmentStephen2.mov', 0));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

$json = parse_json($myVoiceIt->createVideoEnrollmentByUrl($userId2, 'en-US', 'https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/videoEnrollmentStephen3.mov', 0));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

# Video Verification By URL
$json = parse_json($myVoiceIt->videoVerificationByUrl($userId1, 'en-US', 'https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/videoVerificationArmaan1.mov', 0));
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

# Video Identification By URL
$json = parse_json($myVoiceIt->videoIdentificationByUrl($groupId, 'en-US', 'https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/videoVerificationArmaan1.mov', 0));
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);
assertEqual($userId1, $json->{userId}, __LINE__);


$myVoiceIt->deleteAllEnrollmentsForUser($userId1);
$myVoiceIt->deleteAllEnrollmentsForUser($userId2);
$myVoiceIt->deleteUser($userId1);
$myVoiceIt->deleteUser($userId2);
$myVoiceIt->deleteGroup($groupId);

unlink './videoEnrollmentArmaan1.mov';
unlink './videoEnrollmentArmaan2.mov';
unlink './videoEnrollmentArmaan3.mov';
unlink './videoVerificationArmaan1.mov';
unlink './videoEnrollmentStephen1.mov';
unlink './videoEnrollmentStephen2.mov';
unlink './videoEnrollmentStephen3.mov';

print '****Video Tests All Passed****
';


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
getstore('https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/enrollmentArmaan1.wav', './enrollmentArmaan1.wav');
getstore('https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/enrollmentArmaan2.wav', './enrollmentArmaan2.wav');
getstore('https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/enrollmentArmaan3.wav', './enrollmentArmaan3.wav');
getstore('https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/verificationArmaan1.wav', './verificationArmaan1.wav');
getstore('https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/enrollmentStephen1.wav', './enrollmentStephen1.wav');
getstore('https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/enrollmentStephen2.wav', './enrollmentStephen2.wav');
getstore('https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/enrollmentStephen3.wav', './enrollmentStephen3.wav');

$json = parse_json($myVoiceIt->createVoiceEnrollment($userId1, 'en-US', './enrollmentArmaan1.wav'));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

$json = parse_json($myVoiceIt->createVoiceEnrollment($userId1, 'en-US', './enrollmentArmaan2.wav'));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

$json = parse_json($myVoiceIt->createVoiceEnrollment($userId1, 'en-US', './enrollmentArmaan3.wav'));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

$json = parse_json($myVoiceIt->createVoiceEnrollment($userId2, 'en-US', './enrollmentStephen1.wav'));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

$json = parse_json($myVoiceIt->createVoiceEnrollment($userId2, 'en-US', './enrollmentStephen2.wav'));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

$json = parse_json($myVoiceIt->createVoiceEnrollment($userId2, 'en-US', './enrollmentStephen3.wav'));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

# Get All Enrollments for User
$json = parse_json($myVoiceIt->getAllEnrollmentsForUser($userId1));
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);
assertEqual(3, $json->{count}, __LINE__);

# Voice Verification
$json = parse_json($myVoiceIt->voiceVerification($userId1, 'en-US', './verificationArmaan1.wav'));
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

# Voice Identification
$json = parse_json($myVoiceIt->voiceIdentification($groupId, 'en-US', './verificationArmaan1.wav'));
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);
assertEqual($userId1, $json->{userId}, __LINE__);

$myVoiceIt->deleteAllEnrollmentsForUser($userId1);
$myVoiceIt->deleteAllEnrollmentsForUser($userId2);

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
$json = parse_json($myVoiceIt->createVoiceEnrollmentByUrl($userId1, 'en-US', 'https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/enrollmentArmaan1.wav'));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

$json = parse_json($myVoiceIt->createVoiceEnrollmentByUrl($userId1, 'en-US', 'https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/enrollmentArmaan2.wav'));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

$json = parse_json($myVoiceIt->createVoiceEnrollmentByUrl($userId1, 'en-US', 'https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/enrollmentArmaan3.wav'));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

$json = parse_json($myVoiceIt->createVoiceEnrollmentByUrl($userId2, 'en-US', 'https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/enrollmentStephen1.wav'));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

$json = parse_json($myVoiceIt->createVoiceEnrollmentByUrl($userId2, 'en-US', 'https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/enrollmentStephen2.wav'));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

$json = parse_json($myVoiceIt->createVoiceEnrollmentByUrl($userId2, 'en-US', 'https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/enrollmentStephen3.wav'));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

# Voice Verification By URL
$json = parse_json($myVoiceIt->voiceVerificationByUrl($userId1, 'en-US', 'https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/verificationArmaan1.wav'));
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

# Voice Identification By URL
$json = parse_json($myVoiceIt->voiceIdentificationByUrl($groupId, 'en-US', 'https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/verificationArmaan1.wav'));
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);
assertEqual($userId1, $json->{userId}, __LINE__);


$myVoiceIt->deleteAllEnrollmentsForUser($userId1);
$myVoiceIt->deleteAllEnrollmentsForUser($userId2);
$myVoiceIt->deleteUser($userId1);
$myVoiceIt->deleteUser($userId2);
$myVoiceIt->deleteGroup($groupId);

unlink './enrollmentArmaan1.wav';
unlink './enrollmentArmaan2.wav';
unlink './enrollmentArmaan3.wav';
unlink './verificationArmaan1.wav';
unlink './enrollmentStephen1.wav';
unlink './enrollmentStephen2.wav';
unlink './enrollmentStephen3.wav';

print '****Voice Tests All Passed****
';



# Test Face
$json = parse_json($myVoiceIt->createUser());
$userId = $json->{userId};

# Face Enrollments
getstore('https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/faceEnrollmentArmaan1.mp4', './faceEnrollmentArmaan1.mp4');
getstore('https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/faceEnrollmentArmaan2.mp4', './faceEnrollmentArmaan2.mp4');
getstore('https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/faceEnrollmentArmaan3.mp4', './faceEnrollmentArmaan3.mp4');
getstore('https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/faceVerificationArmaan1.mp4', './faceVerificationArmaan1.mp4');


$json = parse_json($myVoiceIt->createFaceEnrollment($userId, './faceEnrollmentArmaan1.mp4', 0));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);
my $faceEnrollmentId1 = $json->{faceEnrollmentId};

$json = parse_json($myVoiceIt->createFaceEnrollment($userId, './faceEnrollmentArmaan2.mp4', 0));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);
my $faceEnrollmentId2 = $json->{faceEnrollmentId};

$json = parse_json($myVoiceIt->createFaceEnrollment($userId, './faceEnrollmentArmaan3.mp4', 0));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);
my $faceEnrollmentId3 = $json->{faceEnrollmentId};

# Get All Face Enrollments for User
$json = parse_json($myVoiceIt->getAllFaceEnrollmentsForUser($userId));
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);
assertEqual(3, $json->{count}, __LINE__);

# Face Verification
$json = parse_json($myVoiceIt->faceVerification($userId, './faceVerificationArmaan1.mp4', 0));
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

# Delete Face Enrollment
$json = parse_json($myVoiceIt->deleteFaceEnrollment($userId, $faceEnrollmentId1));
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

$json = parse_json($myVoiceIt->deleteFaceEnrollment($userId, $faceEnrollmentId2));
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

$json = parse_json($myVoiceIt->deleteFaceEnrollment($userId, $faceEnrollmentId3));
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

$myVoiceIt->deleteUser($userId);

unlink './faceEnrollmentArmaan1.mp4';
unlink './faceEnrollmentArmaan2.mp4';
unlink './faceEnrollmentArmaan3.mp4';
unlink './faceVerificationArmaan1.mp4';

print '****Face Tests All Passed****
';



sub assertEqual {
  my ($arg1, $arg2, $line) = @_;
  if (!$arg1 & ~$arg1) {
    if ($arg1 != $arg2) {
      print $arg1.' does not == '.$arg2.' on line '.$line;
      exit 1;
    }
  } else {
    if ($arg1 ne $arg2) {
      print $arg1.' does not == '.$arg2.' on line '.$line;
      exit 1;
    }
  }
}

sub assertGreaterThan {
  my ($arg1, $arg2, $line) = @_;
  if (!$arg1 > $arg2) {
    print $arg1.' is not > '.$arg2.' on line '.$line;
    exit 1;
  }
}
