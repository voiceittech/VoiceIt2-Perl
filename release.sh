#!/bin/bash
commit=$(git log -1 --pretty=%B | head -n 1)
version=$(echo $(curl -H "Authorization: token $GH_TOKEN" -s https://api.github.com/repos/voiceittech/VoiceIt2-Perl/releases/latest | grep '"tag_name":' |sed -E ' s/.*"([^"]+)".*/\1/') | tr "." "\n")
set -- $version
major=$1
minor=$2
wrapperplatformversion=$(cat ~/platformVersion)
reponame=$(basename $(git remote get-url origin) | sed 's/.\{4\}$//')

if [[ $commit = *"RELEASE"* ]];
then

  if [[ $major = "" ]] || [[ $minor = "" ]];
  then
    curl -X POST -H 'Content-type: application/json' --data '{
      "icon_url": "https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/TravisCI-Mascot-1.png",
      "username": "Release Wrapper Gate",
        "attachments": [
            {
                "text": "Packaging '$reponame' failed because script could not get current version",
                "color": "danger"
            }
        ]
    }' 'https://hooks.slack.com/services/'$SLACKPARAM1'/'$SLACKPARAM2'/'$SLACKPARAM3
    echo "Unable to get current version: cannot release." 1>&2
    exit 1
  fi

  echo 'old version='$major'.'$minor

  if [[ $commit = *"RELEASEMAJOR"* ]];
  then
    releasetype="RELEASEMAJOR"
    major=$(($major+1))
    minor=0
  elif [[ $commit = *"RELEASEMINOR"* ]];
  then
    releasetype="RELEASEMINOR"
    minor=$(($minor+1))
  elif [[ $commit = *"RELEASEPATCH"* ]];
  then
    curl -X POST -H 'Content-type: application/json' --data '{
      "icon_url": "https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/TravisCI-Mascot-1.png",
      "username": "Release Wrapper Gate",
        "attachments": [
            {
                "text": "Packaging '$reponame' failed. RELEASEPATCH is not a valid option for '$reponame' in the commit title",
                "color": "danger"
            }
        ]
    }' 'https://hooks.slack.com/services/'$SLACKPARAM1'/'$SLACKPARAM2'/'$SLACKPARAM3
    echo "Must specify RELEASEMAJOR or RELEASEMINOR in the title." 1>&2
    echo "Patch release not available in Perl due to the expected behavior used in h2xs" 1>&2
    exit 1
  else
    curl -X POST -H 'Content-type: application/json' --data '{
      "icon_url": "https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/TravisCI-Mascot-1.png",
      "username": "Release Wrapper Gate",
        "attachments": [
            {
                "text": "Packaging '$reponame' failed. You need to specify RELEASEMAJOR or RELEASEMINOR in the commit title",
                "color": "danger"
            }
        ]
    }' 'https://hooks.slack.com/services/'$SLACKPARAM1'/'$SLACKPARAM2'/'$SLACKPARAM3
    echo "Must specify RELEASEMAJOR or RELEASEMINOR in the title." 1>&2
    exit 1
  fi

  echo 'new version='$major'.'$minor
  version=$major'.'$minor

  if [[ $wrapperplatformversion = $version ]];
  then
    uploadurl=$(curl -s -H "Authorization: token $GH_TOKEN" -H "Content-Type: application/json" --request POST --data '{"tag_name": "'$version'", "target_commitish": "master", "name": "'$version'", "body": "", "draft": false, "prerelease": false}' https://api.github.com/repos/voiceittech/VoiceIt2-Perl/releases | grep upload_url | awk '{print $2}' | cut -d '"' -f2 | cut -f1 -d '{')
    curl -H "Authorization: token $GH_TOKEN" -H "Content-Type: text/plain" -X POST --data-binary '@./voiceIt2.pm' $uploadurl'?name=voiceIt2.pm' 1>&2

    if [ "$?" != "0" ]
    then
      curl -X POST -H 'Content-type: application/json' --data '{
        "icon_url": "https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/TravisCI-Mascot-1.png",
        "username": "Release Wrapper Gate",
          "attachments": [
              {
                  "text": "Packaging '$reponame' version '$version' failed.",
                  "color": "danger"
              }
          ]
      }' 'https://hooks.slack.com/services/'$SLACKPARAM1'/'$SLACKPARAM2'/'$SLACKPARAM3
      exit 1
    fi

    curl -X POST -H 'Content-type: application/json' --data '{
      "icon_url": "https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/TravisCI-Mascot-1.png",
      "username": "Release Wrapper Gate",
        "attachments": [
            {
                "text": "Packaging '$reponame' version '$version' succeeded.",
                "color": "good"
            }
        ]
    }' 'https://hooks.slack.com/services/'$SLACKPARAM1'/'$SLACKPARAM2'/'$SLACKPARAM3



    # Just the git commit message title
    title=$(git log -1 --pretty=%B | head -n 1)
    git checkout master
    # Save the messages into an array called message
    IFS=$'\n' message=($(git log -1 --pretty=%B | sed -e '1,2d'))

    if [[ $title = *"SENDEMAIL"* ]];
    then
      formattedmessages=''
      for i in "${message[@]}"
      do
        formattedmessages=$formattedmessages'|'$i
      done

      json='{"authenticationPassword":"'$EMAILAUTHPASS'", "messages" : "'$formattedmessages'", "packageManaged": "false", "instructions": "https://github.com/voiceittech/VoiceIt2-Perl/releases/download/'$wrapperplatformversion'/voiceIt2.pm"}'
      curl -X POST -H "Content-Type: application/json" -d $json "https://api.voiceit.io/platform/38"
    fi

    exit 0

  else
    curl -X POST -H 'Content-type: application/json' --data '{
      "icon_url": "https://s3.amazonaws.com/voiceit-api2-testing-files/test-data/TravisCI-Mascot-1.png",
      "username": "Release Wrapper Gate",
        "attachments": [
            {
                "text": "Packaging '$reponame' version '$version' failed because the specified release version to update package management (specified by including '$releasetype' in the commit title) does not match the platform version inside the wrapper ('$wrapperplatformversion').",
                "color": "danger"
            }
        ]
    }' 'https://hooks.slack.com/services/'$SLACKPARAM1'/'$SLACKPARAM2'/'$SLACKPARAM3
    echo "Specified release version to update package management (specified by including "$releasetype" in the commit title) does not match the platform version in wrapper source." 1>&2
    exit 1
  fi

fi
