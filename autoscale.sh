#!/bin/bash

PROJECT_ID="virtualbox-assignmnt"
Zone="us-central1-c"
INSTANCE_TEMPLATE="instance-template-ubuntu1804"
INSTANCE_GROUP="instance-group-assignment3"
GCLOUD_BIN="/usr/local/google-cloud-sdk/bin/gcloud"

if ! $GCLOUD_BIN auth list --format="value(account)" | grep -q "@"; then
  echo "ERROR: No Active Google Cloud Account. Please run: gcloud auth login"
  exit 1

fi

set -x

echo "Executing Autoscale Script...." >> /var/log/autoscale_debug.log
echo "Project ID: $PROJECT_ID" >> /var/log/autoscale_debug.log
echo "Instance Group: $INSTANCE_GROUP" >> /var/log/autoscale_debug.log
echo "FETCHING instance count...." >> /var/log/autoscale_debug.log

INSTANCE_COUNT=$($GCLOUD_BIN compute instance-groups managed list-instances $INSTANCE_GROUP --zone $Zone --format="value(instance)" | wc -l)

echo "Instance count: $INSTANCE_COUNT" >> /var/log/autoscale_debug.log

if [ "$INSTANCE_COUNT" -lt 5 ]; then
 echo "Scaling up instance group.....$(date)...." >> /var/log/autoscale.log
 $GCLOUD_BIN compute instance-groups managed resize $INSTANCE_GROUP --size=3 --zone=$Zone

else
  echo "Instance scaling already triggered, Skipping....Manissha..." >> /var/log/autoscale.log

fi

