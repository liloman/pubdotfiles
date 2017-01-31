#!/usr/bin/env bash
#Vault safely a directory with your openssh private/public keys

#Based on https://gist.github.com/colinstein/de1755d2d7fbe27a0f1e 
# and https://gist.github.com/colinstein/51d686c8f877294e5ab1

#Encrypt
#0. Execute dir/install.sh -e if exist
#1. Make a random 192 password
#2. Use that random password to encrypt a dir (using aes-256-cbc by default)
#3. Encrypt the random password with your rsa public key
#4. Pack everything to tgz
#Decrypt
#1. Unpack the tgz
#2. Decrypt the random password with your rsa private key (assume strong passphrase)
#3. Use that random 192 password to decrypt the dir (using aes-256-cbc by default)
#4. Clean keyfiles
#5. Execute dir/install.sh -d if exist
#Generate
#1. Generate the private/public/pkcs8 keys needed to encrypt/decrypt with rsa 4096 :)
#2. Must use a really strong passphrase!
#set_keys_profile
# Change the default "profile", so you can have keys for github, backups, servers,...



do_vault() {
    #default private/public and pkcs8 profile. Use ./$0 -p name to change it
    local private_key=~/.ssh/vault_$USER.pem
    local public_key=${private_key%.pem}.pub
    local pkcs8_key=$public_key.pkcs8
    #default dir to vault
    local vault_dir=secrets/
    #if suffix changed "globbings"
    local vault_dir_enc=$vault_dir.dir.enc
    local keyfile=secret_key
    #default resulting tgz
    local tgz=fool.tgz
    #operation to do
    local cmd=usage
    #KDF with sha256 (not possible to set the iteration count for now :( )
    local dgst_algo=SHA256
    #Simmetric algorithm
    local sym_algo=aes-256-cbc


    generate(){ 
        local count=1
        local profile=$(get_profile)
        local comment=$profile@$HOSTNAME
        err() {
            echo "$@"
            rm -f "$private_key" "$public_key" "$pkcs8_key"
            echo "ERROR!"
            exit 1
        }

        if [[ -f $private_key ]]; then
            read -p "$private_key already exists. Do you want to overwrite it (Yy/Nn)? " -n 1 -r
            echo "" #move to newline
            [[ $REPLY =~ ^[Yy]$ ]] || err "$private_key exists. Exit!"
            rm -f "$private_key" "$public_key" "$pkcs8_key"
        fi

        echo "$((count++)).Generating $private_key. Type a really strong passphrase!"
        if ! openssl genpkey -algorithm RSA -$sym_algo -outform PEM -out "$private_key" -pkeyopt rsa_keygen_bits:4096 ; then
            err "$private_key couldn't be generated. Exit!"
        fi
        chmod 0400 "$private_key"

        echo "$((count++)).Generating $public_key"
        if ! ssh-keygen -y -f "$private_key" > "$public_key"; then
            err "$public_key couldn't be generated. Exit!"
        fi
        #Append the comment in the end of $public_key 
        #if it has already a @ such a john@mymail.com don't add the hostname
        [[ $profile == *@* ]] && comment=$profile
        echo "$(cat $public_key) $comment" > $public_key 
        chmod 0400 "$public_key"

        echo "$((count++)).Generating $pkcs8_key"
        if ! ssh-keygen -e -f "$public_key" -m PKCS8 > "$pkcs8_key"; then
            err "$pkcs8_key couldn't be generated. Exit!"
        fi
        chmod 0400 "$pkcs8_key"

        echo "Done. Keys for profile:\"$profile\" generated!"
        echo "To login with ssh:"
        echo "ssh-copy-id -f -i $public_key remote-machine"
    }

    decrypt() { 
        local count=1
        err() {
            echo "$@"
            \rm -f $keyfile $keyfile.enc enc.sha256 "$vault_dir_enc" 
            echo "ERROR!"
            exit 1
        }

        echo "Decrypting $tgz" for profile: $(get_profile)
        echo "============================================"

        [[ -f $private_key ]] ||  err "$private_key not found. Use $0 -g to generate one. Exit!"
        [[ -f $tgz ]] || err "$tgz not found. Exit!"


        if ! tar zxf "$tgz"; then
             err "$tz couldn't be unpacked. Exit!"; 
        fi

        #Don't bother with private passphrases for openssl sign
        #sha256 does the job
        echo "$((count++)).Checking checksums of *.enc"
        if ! sha256sum -c enc.sha256; then
            err "Checksum failed for *.enc files. Exit!"
        fi
    
        #[[ -f $keyfile.enc ]] ||  err "$keyfile.enc not found. Exit!"
        #get "dynamic" dir
        vault_dir_enc=$(echo *.dir.enc)
        [[ -f $vault_dir_enc ]] ||  err "$vault_dir_enc not found. Exit!"


        #Introduce your passphrase
        echo "$((count++)).Decrypting unique $keyfile"
        if ! openssl rsautl -decrypt -ssl -inkey "$private_key" -in $keyfile.enc -out $keyfile; then
             err "$keyfile couldn't be generated. Exit!" 
        fi

        echo "$((count++)).Decrypting $vault_dir_enc with $sym_algo and KDF $dgst_algo"

        #print salt,key and iv first (fast)
        if ! openssl $sym_algo -d -P -in "$vault_dir_enc" -pass pass:nothing; then
             err "$vault_dir_enc couldn't be inspected. Exit!" 
        fi

        if ! openssl $sym_algo -md $dgst_algo -d -in "$vault_dir_enc" -pass file:$keyfile | tar xz; then
             err "$vault_dir_enc couldn't be unpacked. Exit!" 
        fi

        echo "$((count++)).Cleanning up files"
        \rm -f $keyfile $keyfile.enc enc.sha256 "$vault_dir_enc" 

        vault_dir=${vault_dir_enc%.dir.enc}
        echo "Done. Directory ${vault_dir}/ generated!"

        if [[ -x $vault_dir/install.sh ]]; then
            read -p "Do you want to execute $vault_dir/install.sh (Yy/Nn)? " -n 1 -r
            echo "" #move to newline
            [[ $REPLY =~ ^[Yy]$ ]] && "$vault_dir/install.sh" -d
        fi
    }

    encrypt() {
        local count=1
        #if dir passed
        vault_dir_enc=$vault_dir.dir.enc

        err() {
            echo "$@"
            \rm -f $keyfile $keyfile.enc enc.sha256 "$vault_dir_enc"
            echo "ERROR!"
            exit 1
        }

        echo "Encrypting $vault_dir/" directory for profile: $(get_profile)
        echo "============================================================"

        [[ -d $vault_dir ]] ||  err "dir $vault_dir not found!"

        #Execute install before packing
        if [[ -x $vault_dir/install.sh ]]; then
            read -p "Do you want to execute $vault_dir/install.sh before encrypt (Yy/Nn)? " -n 1 -r
            echo "" #move to newline
            [[ $REPLY =~ ^[Yy]$ ]] && "$vault_dir/install.sh" -e
        fi

        #generate an unique key
        echo "$((count++)).Generating unique $keyfile"; 
        if ! openssl rand 192 -out $keyfile; then
             err "$keyfile couldn't be generated. Exit!" 
        fi

        #encrypt the targzed dir printing (salt,key, and the iv)
        echo "$((count++)).Generating $vault_dir_enc with $sym_algo and KDF $dgst_algo"
        if ! tar czf - "$vault_dir" | openssl $sym_algo -p -md $dgst_algo -salt -out "$vault_dir_enc" -pass file:$keyfile; then
                err "$vault_dir_enc couldn't be generated. Exit!"
        fi


        if [[ ! -f $pkcs8_key ]]; then
            echo "$((count++)).Generating $pkcs8_key"
            [[ -f $public_key ]] || err "$public_key not found. Use $0 -g to generate one. Exit!"
            if ! ssh-keygen -e -f "$public_key" -m PKCS8 > "$pkcs8_key"; then
                err "$pkcs8_key couldn't be generated. Exit!"
            fi
            chmod 0400 "$pkcs8_key"
        fi

        #encrypt the keyfile
        echo "$((count++)).Generating $keyfile.enc with rsa"
        if ! openssl rsautl -encrypt -pubin -inkey "$pkcs8_key" -in $keyfile -out $keyfile.enc; then
                err "$keyfile.enc couldn't be generated from $pkcs8_key. Exit!"
        fi

        #Don't bother with private passphrases for openssl sign
        #sha256 does the job
        echo "$((count++)).Doing digest of *.enc"
        if ! sha256sum *.enc > enc.sha256; then
            err "enc.sha256 couldn't be generated from *.enc files. Exit!"
        fi

        #package everything
        echo "$((count++)).Packing *.enc and enc.sha256 into $tgz"
        tar -czf "$tgz" *.enc enc.sha256

        echo "$((count++)).Cleanning up files"
        \rm -rf $keyfile $keyfile.enc "$vault_dir_enc" "$vault_dir" enc.sha256
        echo "Done. File $tgz generated!"
    }

    usage() {
    local msg=(
        "Usage :  $0 [options] [--]"
        " "
        "Options:"
        "  -h|help       Display this message"
        "  -e|encrypt    Encrypt $vault_dir into $tgz" 
        "  -d|decrypt    Decrypt $tgz into $vault_dir"
        "  -g|generate   Generate a new certificate"
        "  -p|profile    Change keys profile"
        "  -s|sign       Sign a file with your private key"
        "  -v|verify     Verify a sign with your public key"
        " "
        "Examples:"
        "1.Generate your keys for the default profile:"
        "  $0 -g "
        "2.Generate your github's keys:"
        "  $0 -p github -g"
        "3.Encrypt 'my secret dir' with the default profile:"
        "  $0 -e \"my secret dir\":"
        "4.Decrypt $tgz with backup's profile"
        "  $0 -p backups -d"
        "5.Decrypt private.tgz with the default profile:"
        "  $0 -d private.tgz"
        "6.Sign private.tgz:"
        "  $0 -s private.tgz"
        "7.Verify sign of private.tgz:"
        "  $0 -v private.tgz"
        )
    printf '%s\n' "${msg[@]}"
    exit 0
    
    }    

    get_profile() {
        local profile=${private_key##*/}
        echo "${profile%.pem}"
    }

    #Change the default keys profile to work in
    set_keys_profile() {
        local profile=$1
        local orig=vault_$USER
        private_key=${private_key/$orig/$profile} 
        public_key=${public_key/$orig/$profile} 
        pkcs8_key=${pkcs8_key/$orig/$profile} 
    }

    #Sign a file with your private key
    sign_file() {
        local file=$1
        openssl dgst -$dgst_algo -sign $private_key "$file" > "$file.sig"
        exit $?
    }

    #Verify the sign of a file with your public key
    verify_file() {
        local file=$1
        local sig=$file.sig
        openssl dgst -$dgst_algo -verify $pkcs8_key -signature "$sig" "$file"
        exit $?
    }
    
    while getopts ":hedgp:s:v:" opt
    do
      case $opt in
        h|help      )  usage; exit 0   ;;
        e|encrypt   )  cmd=encrypt     ;;
        d|decrypt   )  cmd=decrypt     ;;
        g|generate  )  cmd=generate    ;;
        p|profile   )  set_keys_profile "$OPTARG"   ;;
        s|sign      )  sign_file "$OPTARG" ; exit 0 ;;
        v|verify    )  verify_file "$OPTARG" ; exit 0 ;;
        : )  echo -e "Option $OPTARG needs an argument\n"; usage; exit 1 ;; 
        * )  echo -e "Option does not exist : $OPTARG\n"; usage; exit 1 ;; 
      esac  
    done
    shift $(($OPTIND-1))

    if [[ $cmd == encrypt ]]; then
        #If passed a dir 
        [[ -n $1 ]] && vault_dir=$1
    elif [[ $cmd == decrypt ]]; then
        #If passed a tgz 
        [[ -n $1 ]] && tgz=$1
    fi

    #sane $vault_dir (expect maximum one ending /)
    [[ ${vault_dir: -1} == / ]] && vault_dir=${vault_dir:0:-1}

    #Execute the option
    $cmd 
}

do_vault "$@"


