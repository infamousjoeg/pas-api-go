#!/bin/bash
# application information
POLICY_BRANCH="root"
HOST_ID="team1/app1"
SAFE_NAME="team1_app1"
VAULT_NAME="vaultName"
LOB_USER="LOBUser_n1"

# Account information
DATABASE_ACCOUNT_NAME="mysql"
DATABASE_ADDRESS="10.0.1.12"
DATABASE_USERNAME="firstapp"
DATABASE_DEFAULT_PASSWORD="thisIsTheDefaultPassword"
DATABASE_PLATFORM="MySQL"

cybr logon -a ldap -b $PAS_HOSTNAME -u $PAS_USERNAME --non-interactive

found=$(cybr safes list | grep SafeName | grep "$SAFE_NAME")
if [ "$found" = "" ]; then
  # safe does not exists so create it
  cybr safes add -s "$SAFE_NAME" --days 0 --desc "Safe for application "$HOST_ID""
fi

found=$(cybr safes list-members -s App_FirstApplication | grep UserName | grep "$LOB_USER")
if [ "$found" = "" ]; then
    # LOB User is not a member of the safe so add them
	cybr safes add-member -m "$LOB_USER" -s "$SAFE_NAME" --list-accounts --retrieve-accounts --access-content-without-confirmation
fi

# add the account to the target safe and trigger a password change process to rotate the default password
account=$(cybr accounts add --safe "$SAFE_NAME" -n "$DATABASE_ACCOUNT_NAME" -a "$DATABASE_ADDRESS" -u "$DATABASE_USERNAME" -t password -c "$DATABASE_DEFAULT_PASSWORD" -p "$DATABASE_PLATFORM" --automatic-management)
id=$(echo "$account" | jq -r .id)
cybr accounts change -i "$id"

E=!
conjurPolicy="$(cat <<-END
- ${E}host ${HOST_ID}
- ${E}group ${VAULT_NAME}/${LOB_USER}/${SAFE_NAME}/delegation/consumers
- ${E}grant
  role: ${E}group ${VAULT_NAME}/${LOB_USER}/${SAFE_NAME}/delegation/consumers
  member: ${E}host ${HOST_ID}
END
)"

datestamp=$(date +%s)
fileFriendlyHostID=$(echo "${HOST_ID}" | sed 's/\//-/g')
fileName="${datestamp}-${fileFriendlyHostID}.yml"

echo "$conjurPolicy" > "$fileName"

cybr conjur logon-non-interactive
cybr conjur append-policy -b "$POLICY_BRANCH" -f "$fileName"





















