LOCAL_DIR=$(pwd)
REF_APP_NAME=eir-chw

echo "Setting up your app building environment"
echo "----------------------------------------"
echo "Current directory: $LOCAL_DIR"
echo "----------------------------------------"

echo "Cloning the reference-apps"
git clone https://github.com/ona-health/reference-apps.git

echo "Cloning and building fhircore"
git clone https://github.com/opensrp/fhircore.git

mkdir -p fhircore/android/quest/src/$REF_APP_NAME/assets/configs
ln -s reference-apps/eir-chw/app_configurations android/quest/src/$REF_APP_NAME/assets/configs

pushd fhircore/android
./gradlew :quest:assembleOpensrpDebug
popd



