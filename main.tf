data "aws_region" "current" {}

resource "aws_cloudwatch_event_rule" "drift_summaries" {
  name        = "drift-summaries"
  description = "Capture infrastructure drift summary for account"

  event_pattern = <<EOF
{
  "source": [
    "josharmi.driftsummary"
  ]
}
EOF
}

resource "aws_iam_role" "forward_events_centrally" {
  name               = "forward-events-centrally"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

locals {
  target_event_bus = join("", [
    "arn:aws:events:",
    data.aws_region.current.name,
    ":",
    var.centralised_account_id,
    ":event-bus/",
    var.target_bus_name
  ])
}

data "aws_iam_policy_document" "forward_events_centrally" {
  statement {
    effect    = "Allow"
    actions   = ["events:PutEvents"]
    resources = [local.target_event_bus]
  }
}

resource "aws_cloudwatch_event_target" "drift_summaries" {
  target_id = "DriftSummaries"
  arn       = local.target_event_bus
  rule      = aws_cloudwatch_event_rule.drift_summaries.name
  role_arn  = aws_iam_role.forward_events_centrally.arn
}
