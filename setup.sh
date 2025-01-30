# Variables
LOCAL_DIR=$(pwd)
INSTALL_DIR="$HOME/AndroidStudio"
ANDROID_STUDIO_URL="https://dl.google.com/dl/android/studio/ide-zips/2024.2.2.13/android-studio-2024.2.2.13-linux.tar.gz"
FHIRCORE_REPO_URL="https://github.com/opensrp/fhircore.git"
REFERENCE_APP_REPO_URL="https://github.com/ona-health/reference-apps.git"
FHIRCORE_REPO_DIR="$HOME/test_setup/fhircore"
REFERENCE_APP_REPO_DIR="$HOME/test_setup/reference-apps"
REF_APP_NAME=eir-chw

install_dependencies(){
  echo "Installing dependencies..."
  sudo apt update
  sudo apt install -y wget unzip git openjdk-11-jdk
}

check_android_studio_installed(){
  echo "Searching for Android Studio..."
  if [ -d "$INSTALL_DIR" ] && [ -f "$INSTALL_DIR/bin/studio.sh" ]; then
    echo "Android Studio is already installed."
    return 0
  else
    return 1
  fi
}

install_android_studio(){
  echo "Downloading Android Studio..."
  wget -q $ANDROID_STUDIO_URL -O android-studio.tar.gz

  echo "Extracting Android Studio..."
  mkdir -p "$INSTALL_DIR"
  tar -xzf android-studio.tar.gz -C "$INSTALL_DIR" --strip-components=1
  rm android-studio.tar.gz

  echo "Setting up Android Studio..."
  "$INSTALL_DIR"/bin/studio.sh &
  echo "Waiting for Android Studio to initialize..."
  sleep 30
}

check_repo_exists() {
  local repo_dir="$1"
  if [ -d "$repo_dir" ]; then
    echo "Repository already exists at $repo_dir. Skipping clone."
    return 0
  else
    return 1
  fi
}

clone_repo() {
  local repo_url="$1"
  local repo_dir="$2"
  echo "Cloning $repo_url ..."
  git clone "$repo_url" "$repo_dir"
}

setup_reference_app(){
  mkdir -p "$FHIRCORE_REPO_DIR"/android/quest/src/$REF_APP_NAME/assets/configs
  ln -s "$REFERENCE_APP_REPO_DIR"/$REF_APP_NAME/app_configurations "$FHIRCORE_REPO_DIR"/android/quest/src/$REF_APP_NAME/assets/configs
}

open_repo_in_android_studio() {
  echo "Opening FHIR Core in Android Studio..."
  "$INSTALL_DIR"/bin/studio.sh "$FHIRCORE_REPO_DIR" &
}

main(){
  echo "Setting up your app building environment"
  echo "----------------------------------------"
  echo "Current directory: $LOCAL_DIR"
  echo "----------------------------------------"
  install_dependencies
  if ! check_android_studio_installed; then
    install_android_studio
  fi
  if ! check_repo_exists "$REFERENCE_APP_REPO_DIR"; then
    clone_repo "$REFERENCE_APP_REPO_URL" "$REFERENCE_APP_REPO_DIR"
  fi
  if ! check_repo_exists "$FHIRCORE_REPO_DIR"; then
    clone_repo "$FHIRCORE_REPO_URL" "$FHIRCORE_REPO_DIR"
  fi
  setup_reference_app
  open_repo_in_android_studio

  echo "Setup complete! Android Studio should now be open with your project."
}

# Run the main function
main
