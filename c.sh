#!/bin/bash
# 🎨 Farby pre výstup
WHITE="\033[37m"
PURPLE="\033[35m" 
YELLOW="\033[33m"
BLUE="\033[34m"
RED="\033[31m"
BLACK="\033[30m"
WHITE="\033[37m"
GREEN="\033[32m"
YELLOW_BG="\033[43m"
GREEN_BG="\033[42m"
RED_BG="\033[41m"
RESET="\033[0m"
 clear

 echo -e "${GREEN}+=====================================+${RESET}"
 echo -e "${GREEN}|==${RESET} ${GREEN}   OTA FindeR${RESET} ${RED}  by${RESET} ${BLUE}Stano 36${RESET}  ${GREEN}   ==|${RESET}"
 echo -e "${GREEN}|${RESET} ${YELLOW_BG}${BLACK}  realme   ${RESET} ${GREEN_BG}${WHITE}   oppo   ${RESET} ${RED_BG}${WHITE}  OnePlus   ${RESET} ${GREEN}|${RESET}"
 echo -e "${GREEN}+=====================================+${RESET}"
printf "| %-3s | %-14s | %-12s |\n" "No" "Name" "Model"
echo "---------------------------------------"

mapfile -t DEVICES < devices.txt

for i in "${!DEVICES[@]}"; do
    IFS="|" read -r MODEL ANDROID OTA NAME <<< "${DEVICES[$i]}"
    printf "| %-3s | %-14s | %-12s |\n" "$((i+1))" "$NAME" "$MODEL"
done

echo "---------------------------------------"
read -p "Select device number: " CHOICE

INDEX=$((CHOICE-1))
IFS="|" read -r MODEL ANDROID OTA NAME <<< "${DEVICES[$INDEX]}"

# základný model bez regiónu
BASE_MODEL=$(echo "$MODEL" | sed -E 's/(EEA|RU|IN)$//')

# cieľová vetva
if [[ "$MODEL" == *EEA ]]; then
    TARGET="GDPR"
else
    TARGET="export"
fi

OTA_STRING="${BASE_MODEL}${TARGET}_${ANDROID}.${OTA}.00_0000_000000000000"

echo
echo "📱 Device name      : $NAME"
echo "🔢 Model            : $MODEL"
echo "🤖 Android version  : $ANDROID"
echo "🧩 OTA version.     : $OTA"
echo
echo "▶ realme-ota $MODEL $OTA_STRING 1 0"
echo

OUTPUT=$(realme-ota "$MODEL" "$OTA_STRING" 1 0)
OTA_VERSION=$(echo "$OUTPUT" \
  | grep -oP '"otaVersion"\s*:\s*"\K[^"]+')

DOWNLOAD_URL=$(echo "$OUTPUT" \
  | grep -oE 'https://[^"]+\.zip' \
  | head -n 1 \
  | sed 's/gauss-otacostmanual-sg/gauss-opexcostmanual-sg/')

ABOUT_URL=$(echo "$OUTPUT" \
  | grep -oE 'https://[^"]+\.html[^"]*' \
  | sort -u \
  | head -n 1)

if [[ -n "$DOWNLOAD_URL" ]]; then
    echo
    echo "📥 Download:"
    [[ -n "$OTA_VERSION" ]] && echo "$OTA_VERSION"
    echo "$DOWNLOAD_URL"
fi
if [[ -n "$ABOUT_URL" ]]; then
    echo
    echo "ℹ️  About this update:"
    echo "$ABOUT_URL"
fi


echo
echo "🔁 What next?"
echo "1 - Select device"
echo "0 - Exit"
read -rp "Select: " ACTION

case "$ACTION" in
  1)
    bash "$0"
    ;;
  0)
    echo "👋 Exit"
    exit 0
    ;;
  *)
    echo "❌ Invalid choice"
    exit 1
    ;;
esac