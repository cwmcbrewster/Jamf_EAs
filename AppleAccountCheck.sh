#!/bin/zsh

loggedInUser=$( scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ && ! /loginwindow/ { print $3 }' )

if [[ "${loggedInUser}" ]]; then

  result="${loggedInUser}"

  if [[ -f "/Users/${loggedInUser}/Library/Preferences/MobileMeAccounts.plist" ]]; then
    appleAccounts=$(/usr/libexec/PlistBuddy -c "Print ::Accounts" /Users/${loggedInUser}/Library/Preferences/MobileMeAccounts.plist 2>/dev/null | grep -E "^[[:space:]]+AccountID[[:space:]]=" | awk -F' = ' '{print $2}')
    if [[ ${appleAccounts} ]]; then
      for account in ${(f)appleAccounts}; do
        result+=",${account}"
      done
    else
      result+=",N/A"
    fi
  else
    result+=",N/A"
  fi
fi

echo "<result>${result}</result>"
