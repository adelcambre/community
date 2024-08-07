#!/bin/bash -
#===============================================================================
#
#          FILE: push.sh
#
#         USAGE: ./push.sh
#
#   DESCRIPTION: Render the ecowitt tidbyt image and push to my device
#
#===============================================================================

set -o nounset                              # Treat unset variables as an error
set -x

PATH=/opt/homebrew/bin:$PATH

TIDBYT_DEVICE_ID='radically-certain-upstanding-bunting-3ca'
# TIDBYT_API_KEY='eyJhbGciOiJFUzI1NiIsImtpZCI6IjY1YzFhMmUzNzJjZjljMTQ1MTQyNzk5ODZhMzYyNmQ1Y2QzNTI0N2IiLCJ0eXAiOiJKV1QifQ.eyJhdWQiOiJodHRwczovL2FwaS50aWRieXQuY29tIiwiZXhwIjoxNjg3ODkwNTM1LCJpYXQiOjE2NTYzNTQ1MzUsImlzcyI6Imh0dHBzOi8vYXBpLnRpZGJ5dC5jb20iLCJzdWIiOiJzQjFSVW9QMUFNY3Fmdk5IU090TlQzekRVNlcyIiwic2NvcGUiOiJkZXZpY2UiLCJkZXZpY2UiOiJyYWRpY2FsbHktY2VydGFpbi11cHN0YW5kaW5nLWJ1bnRpbmctM2NhIn0.FxoUNJ1Bw7YgRtKq413RZDBwp7cnNXsBwC9elH-E7OouWiqLqH56p5D3UBRQAoc8VBnsvrtChgml5TQ25NxoMQ'
TIDBYT_API_KEY='eyJhbGciOiJFUzI1NiIsImtpZCI6IjY1YzFhMmUzNzJjZjljMTQ1MTQyNzk5ODZhMzYyNmQ1Y2QzNTI0N2IiLCJ0eXAiOiJKV1QifQ.eyJhdWQiOiJodHRwczovL2FwaS50aWRieXQuY29tIiwiZXhwIjozMjY1MTM0MTU1LCJpYXQiOjE2ODgzMzQxNTUsImlzcyI6Imh0dHBzOi8vYXBpLnRpZGJ5dC5jb20iLCJzdWIiOiJzQjFSVW9QMUFNY3Fmdk5IU090TlQzekRVNlcyIiwic2NvcGUiOiJkZXZpY2UiLCJkZXZpY2UiOiJyYWRpY2FsbHktY2VydGFpbi11cHN0YW5kaW5nLWJ1bnRpbmctM2NhIn0.O11kK9l2ttSNvXileujvYAzzP0q5wMDyP1USNHsUc78hEdxXJofT2PlI-AeXLpLvcFXwyI2GNG998bL1O78eaQ'
TIDBYT_INSTALLATION_ID=Ecowitt

script_path=$(readlink -f $0)
script_dir=$(dirname $script_path)
out_path=$script_dir/out.webp

$script_dir/render.sh

echo $out_path
echo `stat $out_path`

pixlet push --background --api-token $TIDBYT_API_KEY --installation-id $TIDBYT_INSTALLATION_ID $TIDBYT_DEVICE_ID $out_path


