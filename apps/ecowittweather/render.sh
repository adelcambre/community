#!/bin/bash -
#===============================================================================
#
#          FILE: render.sh
#
#         USAGE: ./render.sh
#
#   DESCRIPTION: Render the ecowitt tidbyt image and push to my device
#
#===============================================================================

set -o nounset                              # Treat unset variables as an error
set -x

PATH=/opt/homebrew/bin:$PATH

ECOWITT_IP_ADDRESS=10.0.3.74
# ECOWITT_IP_ADDRESS=169.254.169.254

script_path=$(readlink -f $0)
script_dir=$(dirname $script_path)
star_path=$script_dir/ecowitt_weather.star
fallback_path=$script_dir/fallback_time.star
out_path=$script_dir/out.webp

temp_file=$(mktemp -t ecowitt_tidbytt.XXXX.webp)
trap "rm -f $temp_file" 0 2 3 15

if ! pixlet render $star_path ip_address=$ECOWITT_IP_ADDRESS -o $temp_file >> /tmp/ecowitt_star.out 2>&1; then
  pixlet render $fallback_path ip_address=$ECOWITT_IP_ADDRESS -o $temp_file
fi

cp $temp_file $out_path
