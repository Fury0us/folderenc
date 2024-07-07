#!/bin/bash

# Function to encrypt a folder
encrypt_folder() {
  local folder=$1
  local password=$2
  local encrypted_folder="${folder}.enc"

  # Create a tar archive of the folder
  tar -cf "${folder}.tar" "${folder}"

  # Encrypt the tar archive using OpenSSL
  openssl enc -aes-256-cbc -in "${folder}.tar" -out "${encrypted_folder}" -pass pass:"${password}"

  # Remove the original tar archive
  rm "${folder}.tar"
}

# Function to decrypt a folder
decrypt_folder() {
  local encrypted_folder=$1
  local password=$2
  local folder="${encrypted_folder%.enc}"

  # Decrypt the encrypted folder using OpenSSL
  openssl enc -d -aes-256-cbc -in "${encrypted_folder}" -out "${folder}.tar" -pass pass:"${password}"

  # Extract the tar archive
  tar -xf "${folder}.tar"

  # Remove the tar archive
  rm "${folder}.tar"
}

# Main script
if [ $# -ne 3 ]; then
  echo "Usage: $0 <encrypt|decrypt> <folder> <password>"
  exit 1
fi

action=$1
folder=$2
password=$3

if [ "$action" = "encrypt" ]; then
  encrypt_folder "$folder" "$password"
elif [ "$action" = "decrypt" ]; then
  decrypt_folder "$folder" "$password"
else
  echo "Invalid action. Use 'encrypt' or 'decrypt'."
  exit 1
fi
