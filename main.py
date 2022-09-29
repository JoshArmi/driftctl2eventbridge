import json

import boto3

eventbridge = boto3.client("events")

with open("result.json") as file:
  result = json.loads(file.read())
  response = eventbridge.put_events(
      Entries=[
          {
              'Source': 'josharmi.driftsummary',
              'DetailType': 'v1',
              'Detail': json.dumps({
                "account_id": boto3.client('sts').get_caller_identity().get('Account'),
                "total_resources": result["summary"]["total_resources"],
                "total_changed": result["summary"]["total_changed"],
                "total_unmanaged": result["summary"]["total_unmanaged"],
                "total_missing": result["summary"]["total_missing"],
                "total_managed": result["summary"]["total_resources"],
              }),
          },
      ],
  )
