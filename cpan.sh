#!/bin/bash

commit=$(git log -1 --pretty=%B | head -n 1)
curl -s https://api.github.com/repos/voiceittech/VoiceIt2-Perl/releases/latest | grep '"tag_name":' |sed -E ' s/.*"([^"]+)".*/\1/'
version=$(echo $(curl -s https://api.github.com/repos/voiceittech/VoiceIt2-Perl/releases/latest | grep '"tag_name":' |sed -E ' s/.*"([^"]+)".*/\1/') | tr "." "\n")
set -- $version
major=$1
minor=$2
patch=$3
echo 'major='$major
echo 'minor='$minor
echo 'patch='$patch

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
  echo $version
  # mkdir -p CPAN/lib/voiceIt
  # mv voiceIt2.pm CPAN/lib/voiceIt
  # cd CPAN
  # h2xs -AX --skip-exporter --use-new-tests voiceIt::voiceIt2 -v $version
  # cd voiceIt-voiceIt2
  # perl Makefile.PL
  # make dist

  # echo "ls"
  # ls
  # cpan install CPAN-Uploader-0.103013::cpan-upload
  # which cpan-upload
  # cpan-upload -u $PAUSEPERLUSERNAME -p $PAUSEPERLPASSWORD -d 'voiceIt-voiceIt2-'$version 'voiceIt-voiceIt2-'$version'.tar.gz'
  # echo "PERL PAUSE SUCCESS"
fi
