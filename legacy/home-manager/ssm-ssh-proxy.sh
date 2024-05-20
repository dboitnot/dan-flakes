#!/usr/bin/env bash

#
# To use, add something like this to your SSH config
#
#   Host *.sig
#     ProxyCommand ~/projects/sig-automation/scripts/ssm-ssh-proxy.sh -f 1 -h %h -p %p -v
#

ALL_REGIONS="us-east-2 us-west-2 us-west-1 us-east-1"

INST_NAME=''
INST_PORT='22'
HOST_FIELD=''
HOST_FIELD_SEP='.'
DEBUG=''

die () {
    >&2 echo "ERROR: $*"
    exit 1
}

debug () {
    [ -z "$DEBUG" ] && return
    >&2 echo "$*"
}

get_inst_id_cur_region () {
    debug "Looking for EC2 instance named '$INST_NAME' in $AWS_DEFAULT_REGION"
    aws ec2 describe-instances --filter "Name=tag:Name,Values=$1" |jq -r '.Reservations[].Instances[].InstanceId' || die "Instance lookup failed"
}

while :; do
    opt="$1"; shift
    arg="$1"
    [ -z "$opt" ] && break

    case "$opt" in
        -h | --host)
            INST_NAME="$arg"; shift
            ;;

        -p | --port)
            INST_PORT="$arg"; shift
            ;;

        -f | --host_field)
            HOST_FIELD="$arg"; shift
            ;;

        -d | --host_separator)
            HOST_FIELD_SEP="$arg"; shift
            ;;

        -r | --profile)
            export AWS_PROFILE="$arg"; shift
            ;;

        -R | --regions)
            export ALL_REGIONS="$arg"; shift
            ;;

        -v)
            DEBUG='yes'
            ;;

        *)
            die "Unrecognized option: $opt"
            ;;
    esac
done

[ -z "$INST_NAME" ] && die "Missing required option: --host"

if [ -n "$HOST_FIELD" ]; then
    INST_NAME=$(echo "$INST_NAME" | cut -d $HOST_FIELD_SEP -f $HOST_FIELD)
fi

for AWS_DEFAULT_REGION in $ALL_REGIONS; do
    export AWS_DEFAULT_REGION
    inst_id=$(get_inst_id_cur_region "$INST_NAME")
    if [ -n "$inst_id" ]; then
        debug "Connecting to instance $inst_id in region $AWS_DEFAULT_REGION via SSM..."
        exec aws ssm start-session --target "$inst_id" --document-name AWS-StartSSHSession --parameters "portNumber=$INST_PORT"
    fi
done
die "Did not find an instance named '$INST_NAME' in regions: $ALL_REGIONS"
