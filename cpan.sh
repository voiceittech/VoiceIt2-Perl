#!/bin/bash

commit=$(git log -1 --pretty=%B | head -n 1)
version=$(echo $(curl -s https://api.github.com/repos/voiceittech/VoiceIt2-Perl/releases/latest | grep '"tag_name":' |sed -E ' s/.*"([^"]+)".*/\1/') | tr "." "\n")
set -- $version
major=$1
minor=$2
echo 'old version='$major'.'$minor

if [[ $commit = *"RELEASE"* ]];
then

  if [[ $commit = *"RELEASEMAJOR"* ]];
  then
    major=$(($major+1))
    minor=0
  elif [[ $commit = *"RELEASEMINOR"* ]];
  then
    minor=$(($minor+1))
  elif [[ $commit = *"RELEASEPATCH"* ]];
  then
    echo "Patch release not available in Perl due to the expected behavior used in h2xs" 1>&2
    exit 1
  else
    echo "Must specify RELEASEMAJOR, RELEASEMINOR, or RELEASEPATCH in the title." 1>&2
    exit 1
  fi

  version=$major'.'$minor
  echo 'new version='$major'.'$minor

  mkdir -p CPAN/lib/voiceIt
  cp voiceIt2.pm CPAN/lib/voiceIt
  cd CPAN
  h2xs -AX --skip-exporter --use-new-tests -v $version -n voiceIt::voiceIt2
  # h2xs -AX --use-new-tests -v $version -n voiceIt::voiceIt2
  cd voiceIt-voiceIt2
  perl Makefile.PL
  make dist

  cpan CPAN::Uploader
  curl -s -u $GITHUBUSERNAME:$GITHUBPASSWORD -H "Content-Type: application/json" --request POST --data '{"tag_name": "'$version'", "target_commitish": "master", "name": "'$version'", "body": "", "draft": false, "prerelease": false}' https://api.github.com/repos/voiceittech/VoiceIt2-Perl/releases > /dev/null
  echo "ls"
  ls
  cpan-upload --ignore-errors -u $PAUSEPERLUSERNAME -p $PAUSEPERLPASSWORD 'voiceIt-voiceIt2-'$version'.tar.gz'
  sleep 10
  curl -s https://metacpan.org/release/voiceIt-voiceIt2 > /dev/null
fi
