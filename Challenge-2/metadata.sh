METADATA_TOKEN=$(curl -fsS -X PUT -H "X-aws-ec2-metadata-token-ttl-seconds: 600" http://169.254.169.254/latest/api/token)

function get {
  curl -fsS -H "X-aws-ec2-metadata-token: $METADATA_TOKEN" http://169.254.169.254/latest/meta-data/$1 2> /dev/null
}

INSTANCE_ID=$(get meta-data/instance-id)
INSTANCE_TYPE=$(get meta-data/instance-type)

echo "instance-id: $INSTANCE_ID"
echo "instance-type: $INSTANCE_TYPE"
