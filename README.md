# DriftCtl to Amazon EventBridge

This repository contains Python that converts the summary data from a [DriftCtl](https://driftctl.com/) scan into an Amazon EventBridge event.

It additionally includes the required Terraform to capture and forward the event to and Amazon EventBridge bus of your choosing.

## Prerequisites

- [Pipenv](https://pipenv.pypa.io/en/latest/index.html#install-pipenv-today) (developed with v2022.8.15)
- [Terraform](https://www.terraform.io/downloads) (developed with v1.3)
- [DriftCtl](https://driftctl.com) (developed with v0.35)
- Make (developed with v3.81)

## To scan an account and produce the event

1. Assume a role in the target account
2. Set a `STATEFILES` environment variable containing a space delimited list of state file locations. E.g. `export STATEFILES="terraform.tfstate s3://my-state-bucket/terraform.tfstate"`
3. `make run`

## To forward the event centrally

1. Create a `terraform.tfvars` file
2. Add variables for `centralised_account_id` and `target_bus_name` as required
3. Ensure the target Amazon EventBridge bus will accept events from the account
4. Validate your configuration with `make plan`
5. `make deploy`
