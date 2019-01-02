#!/bin/bash

commit=$(git log -1 --pretty=%B | head -n 1)
version=$(echo $(curl -s https://api.github.com/repos/voiceittech/VoiceIt2-Perl/releases/latest | grep '"tag_name":' |sed -E ' s/.*"([^"]+)".*/\1/') | tr "." "\n")
set -- $version
major=$1
minor=$2
patch=$3
echo 'old version='$major'.'$minor'.'$patch

if [[ $commit = *"RELEASE"* ]];
then

  if [[ $commit = *"RELEASEMAJOR"* ]];
  then
    major=$(($major+1))
    minor=0
    patch=0
  elif [[ $commit = *"RELEASEMINOR"* ]];
  then
    minor=$(($minor+1))
    patch=0
  elif [[ $commit = *"RELEASEPATCH"* ]];
  then
    patch=$(($patch+1))
  else
    echo "Must specify RELEASEMAJOR, RELEASEMINOR, or RELEASEPATCH in the title." 1>&2
    exit 1
  fi

  version=$major'.'$minor'.'$patch
  echo 'new version='$major'.'$minor'.'$patch
  mkdir -p CPAN/lib/voiceIt
  mv voiceIt2.pm CPAN/lib/voiceIt
  cd CPAN
  h2xs -AX --skip-exporter --use-new-tests voiceIt::voiceIt2 -v $version
  cd voiceIt-voiceIt2
  perl Makefile.PL
  make dist

  # cpan install CPAN-Uploader-0.103013::cpan-upload
  cpan CPAN::Uploader
  # curl -u $GITHUBUSERNAME:$GITHUBPASSWORD -H "Content-Type: application/json" --request POST --data '{"tag_name": "'$version'", "target_commitish": "master", "name": "'$version'", "body": "", "draft": false, "prerelease": false}' https://api.github.com/repos/voiceittech/VoiceIt2-Perl/releases
  cpan-upload -u $PAUSEPERLUSERNAME -p $PAUSEPERLPASSWORD -d 'voiceIt-voiceIt2-'$version 'voiceIt-voiceIt2-'$version'.tar.gz'
fi
