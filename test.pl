require './voiceIt2.pm';
use JSON::Parse 'parse_json';
use LWP::Simple;
print "****Started Testing**** \n";
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

$json = parse_json($myVoiceIt->getAllPhrases('en-US'));
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

print "****Basic Tests All Passed ****\n";

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
eval {
$json = parse_json($myVoiceIt->createVideoEnrollment($userId1, 'en-US', 'Never Forget Tomorrow is a new day', './videoEnrollmentArmaa.mov', 0));
};
if ($@) {
  my @exception = split(':', $@);
  assertEqual('FileNotFound',@exception[0]);
} else {
  die "Testing Failed";
}

$json = parse_json($myVoiceIt->createVideoEnrollment($userId1, 'en-US', 'Never Forget Tomorrow is a new day','./videoEnrollmentArmaan1.mov', 0));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);
my $enrollmentId1 = $json->{id};
$json = parse_json($myVoiceIt->createVideoEnrollment($userId1, 'en-US','Never Forget Tomorrow is a new day', './videoEnrollmentArmaan2.mov', 0));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);
my $enrollmentId2 = $json->{id};
$json = parse_json($myVoiceIt->createVideoEnrollment($userId1, 'en-US', 'Never Forget Tomorrow is a new day','./videoEnrollmentArmaan3.mov', 0));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);
my $enrollmentId3 = $json->{id};
$json = parse_json($myVoiceIt->getAllVideoEnrollments($userId1));
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);
assertEqual(3, $json->{count}, __LINE__);
$json = parse_json($myVoiceIt->createVideoEnrollment($userId2, 'en-US', 'Never Forget Tomorrow is a new day','./videoEnrollmentStephen1.mov', 0));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);
$json = parse_json($myVoiceIt->createVideoEnrollment($userId2, 'en-US','Never Forget Tomorrow is a new day', './videoEnrollmentStephen2.mov', 0));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);
$json = parse_json($myVoiceIt->createVideoEnrollment($userId2, 'en-US','Never Forget Tomorrow is a new day', './videoEnrollmentStephen3.mov', 0));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);


# Video Verification
eval {
$json = parse_json($myVoiceIt->videoVerification($userId1, 'en-US','Never Forget Tomorrow is a new day', './videoVerificationArmaa.mov', 0));
};
if ($@) {
  my @exception = split(':', $@);
  assertEqual('FileNotFound',@exception[0]);
} else {
  die "Testing Failed";
}
$json = parse_json($myVoiceIt->videoVerification($userId1, 'en-US', 'Never Forget Tomorrow is a new day','./videoVerificationArmaan1.mov', 0));
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

# Video Identification
eval {
$json = parse_json($myVoiceIt->videoIdentification($groupId, 'en-US','Never Forget Tomorrow is a new day', './videoVerificationArmas.mov', 0));
};
if ($@) {
  my @exception = split(':', $@);
  assertEqual('FileNotFound',@exception[0]);
} else {
  die "Testing Failed";
}
$json = parse_json($myVoiceIt->videoIdentification($groupId, 'en-US','Never Forget Tomorrow is a new day', './videoVerificationArmaan1.mov', 0));
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);
assertEqual($userId1, $json->{userId}, __LINE__);

#Delete Video Enrollment
$json = parse_json($myVoiceIt->deleteVideoEnrollment($userId1, $enrollmentId1));
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

#Delete all video enrollments
$json = parse_json($myVoiceIt->deleteAllVideoEnrollments($userId1));
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

# Delete All Enrollments
$json = parse_json($myVoiceIt->deleteAllEnrollments($userId2));
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
$json = parse_json($myVoiceIt->createVideoEnrollmentByUrl($userId1, 'en-US', 'Never Forget Tomorrow is a new day','https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/videoEnrollmentArmaan1.mov', 0));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

$json = parse_json($myVoiceIt->createVideoEnrollmentByUrl($userId1, 'en-US','Never Forget Tomorrow is a new day', 'https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/videoEnrollmentArmaan2.mov', 0));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

$json = parse_json($myVoiceIt->createVideoEnrollmentByUrl($userId1, 'en-US', 'Never Forget Tomorrow is a new day','https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/videoEnrollmentArmaan3.mov', 0));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

$json = parse_json($myVoiceIt->createVideoEnrollmentByUrl($userId2, 'en-US', 'Never Forget Tomorrow is a new day','https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/videoEnrollmentStephen1.mov', 0));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

$json = parse_json($myVoiceIt->createVideoEnrollmentByUrl($userId2, 'en-US','Never Forget Tomorrow is a new day', 'https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/videoEnrollmentStephen2.mov', 0));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

$json = parse_json($myVoiceIt->createVideoEnrollmentByUrl($userId2, 'en-US','Never Forget Tomorrow is a new day', 'https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/videoEnrollmentStephen3.mov', 0));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

# Video Verification By URL
$json = parse_json($myVoiceIt->videoVerificationByUrl($userId1, 'en-US', 'Never Forget Tomorrow is a new day','https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/videoVerificationArmaan1.mov', 0));
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

# Video Identification By URL
$json = parse_json($myVoiceIt->videoIdentificationByUrl($groupId, 'en-US','Never Forget Tomorrow is a new day', 'https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/videoVerificationArmaan1.mov', 0));
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);
assertEqual($userId1, $json->{userId}, __LINE__);


$myVoiceIt->deleteAllEnrollments($userId1);
$myVoiceIt->deleteAllEnrollments($userId2);
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

print "****Video Tests All Passed****\n";

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

eval {
$json = parse_json($myVoiceIt->createVoiceEnrollment($userId1, 'en-US','Never Forget Tomorrow is a new day', './enrollmentArmaa.wav'));
};
if ($@) {
  my @exception = split(':', $@);
  assertEqual('FileNotFound',@exception[0]);
} else {
  die "Testing Failed";
}

$json = parse_json($myVoiceIt->createVoiceEnrollment($userId1, 'en-US','Never Forget Tomorrow is a new day', './enrollmentArmaan1.wav'));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

$json = parse_json($myVoiceIt->createVoiceEnrollment($userId1, 'en-US', 'Never Forget Tomorrow is a new day','./enrollmentArmaan2.wav'));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

$json = parse_json($myVoiceIt->createVoiceEnrollment($userId1, 'en-US','Never Forget Tomorrow is a new day', './enrollmentArmaan3.wav'));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);
my $voiceEnrollmentId1 = $json->{id};

$json = parse_json($myVoiceIt->getAllVoiceEnrollments($userId1));
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);
assertEqual(3, $json->{count}, __LINE__);

$json = parse_json($myVoiceIt->createVoiceEnrollment($userId2, 'en-US','Never Forget Tomorrow is a new day', './enrollmentStephen1.wav'));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

$json = parse_json($myVoiceIt->createVoiceEnrollment($userId2, 'en-US','Never Forget Tomorrow is a new day', './enrollmentStephen2.wav'));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

$json = parse_json($myVoiceIt->createVoiceEnrollment($userId2, 'en-US','Never Forget Tomorrow is a new day', './enrollmentStephen3.wav'));
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

$json = parse_json($myVoiceIt->voiceVerification($userId1, 'en-US','Never Forget Tomorrow is a new day', './verificationArmaan1.wav'));
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

# Voice Identification
$json = parse_json($myVoiceIt->voiceIdentification($groupId, 'en-US', 'Never Forget Tomorrow is a new day','./verificationArmaan1.wav'));
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);
assertEqual($userId1, $json->{userId}, __LINE__);

# Delete Voice Enrollment
$json = parse_json($myVoiceIt->deleteVoiceEnrollment($userId1, $voiceEnrollmentId1));
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

# Delete all voice enrollments
$json = parse_json($myVoiceIt->deleteAllVoiceEnrollments($userId1));
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

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
$json = parse_json($myVoiceIt->createVoiceEnrollmentByUrl($userId1, 'en-US', 'Never Forget Tomorrow is a new day','https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/enrollmentArmaan1.wav'));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

$json = parse_json($myVoiceIt->createVoiceEnrollmentByUrl($userId1, 'en-US','Never Forget Tomorrow is a new day', 'https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/enrollmentArmaan2.wav'));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

$json = parse_json($myVoiceIt->createVoiceEnrollmentByUrl($userId1, 'en-US', 'Never Forget Tomorrow is a new day','https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/enrollmentArmaan3.wav'));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

$json = parse_json($myVoiceIt->createVoiceEnrollmentByUrl($userId2, 'en-US', 'Never Forget Tomorrow is a new day','https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/enrollmentStephen1.wav'));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

$json = parse_json($myVoiceIt->createVoiceEnrollmentByUrl($userId2, 'en-US', 'Never Forget Tomorrow is a new day','https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/enrollmentStephen2.wav'));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

$json = parse_json($myVoiceIt->createVoiceEnrollmentByUrl($userId2, 'en-US','Never Forget Tomorrow is a new day', 'https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/enrollmentStephen3.wav'));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

# Voice Verification By URL
$json = parse_json($myVoiceIt->voiceVerificationByUrl($userId1, 'en-US','Never Forget Tomorrow is a new day', 'https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/verificationArmaan1.wav'));
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

# Voice Identification By URL
$json = parse_json($myVoiceIt->voiceIdentificationByUrl($groupId, 'en-US','Never Forget Tomorrow is a new day', 'https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/verificationArmaan1.wav'));
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);
assertEqual($userId1, $json->{userId}, __LINE__);


$myVoiceIt->deleteAllEnrollments($userId1);
$myVoiceIt->deleteAllEnrollments($userId2);
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

print "****Voice Tests All Passed****\n";


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
getstore('https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/faceEnrollmentArmaan1.mp4', './faceEnrollmentArmaan1.mp4');
getstore('https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/faceEnrollmentArmaan2.mp4', './faceEnrollmentArmaan2.mp4');
getstore('https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/faceEnrollmentArmaan3.mp4', './faceEnrollmentArmaan3.mp4');
getstore('https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/videoEnrollmentStephen1.mov', './faceEnrollmentStephen1.mov');
getstore('https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/faceVerificationArmaan1.mp4', './faceVerificationArmaan1.mp4');

eval {
$json = parse_json($myVoiceIt->createFaceEnrollment($userId1, './faceEnrollmentArmaands.mp4', 0));
};
if ($@) {
  my @exception = split(':', $@);
  assertEqual('FileNotFound',@exception[0]);
} else {
  die "Testing Failed";
}
$json = parse_json($myVoiceIt->createFaceEnrollment($userId1, './faceEnrollmentArmaan1.mp4', 0));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

$json = parse_json($myVoiceIt->createFaceEnrollmentByUrl($userId1, 'https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/faceEnrollmentArmaan1.mp4', 0));
assertEqual(201, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);
my $faceEnrollmentId1 = $json->{faceEnrollmentId};

$json = parse_json($myVoiceIt->createFaceEnrollment($userId2, './faceEnrollmentStephen1.mov', 0));
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
$json = parse_json($myVoiceIt->faceVerification($userId1, './faceVerificationArma.mp4', 0));
};
if ($@) {
  my @exception = split(':', $@);
  assertEqual('FileNotFound',@exception[0]);
} else {
  die "Testing Failed";
}

$json = parse_json($myVoiceIt->faceVerification($userId1, './faceVerificationArmaan1.mp4', 0));
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

$json = parse_json($myVoiceIt->faceVerificationByUrl($userId1, 'https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/faceVerificationArmaan1.mp4', 0));
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

$json = parse_json($myVoiceIt->faceIdentification($groupId, './faceVerificationArmaan1.mp4'));
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);
assertEqual($userId1, $json->{userId}, __LINE__);

$json = parse_json($myVoiceIt->faceIdentificationByUrl($groupId, 'https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/faceVerificationArmaan1.mp4'));
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);
assertEqual($userId1, $json->{userId}, __LINE__);

# Delete Face Enrollment
$json = parse_json($myVoiceIt->deleteFaceEnrollment($userId1, $faceEnrollmentId1));
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

# Delete all video enrollments
$json = parse_json($myVoiceIt->deleteAllFaceEnrollments($userId1));
assertEqual(200, $json->{status}, __LINE__);
assertEqual('SUCC', $json->{responseCode}, __LINE__);

$myVoiceIt->deleteUser($userId1);
$myVoiceIt->deleteUser($userId2);

unlink './faceEnrollmentArmaan1.mp4';
unlink './faceEnrollmentArmaan2.mp4';
unlink './faceEnrollmentArmaan3.mp4';
unlink './faceVerificationArmaan1.mp4';
unlink './faceEnrollmentStephen1.mov';

print "****Face Tests All Passed**** \n";
print "****All Tests Passed**** \n";



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
