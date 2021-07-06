#!/bin/bash
set -e
flutter build apk --no-tree-shake-icons
cd android 
fastlane android upload_to_firebase

flutter build ios --no-tree-shake-icons
cd ../ios 
fastlane ios upload_to_firebase

echo "Deoloy firebase Android & iOS Done !!!"