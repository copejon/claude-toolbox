---
name: aws-stack
description: Create, delete, describe, and manage AWS EC2 instances via CloudFormation using scripts/aws/manage_aws_stack.sh. Subcommands — create, delete, describe, logs, ami.
argument-hint: <create|delete|describe|logs|ami> [name] [--os rhel-10] [--inst-type m5.xlarge] [--region us-west-2]
user-invocable: true
allowed-tools:
  - Bash
  - Read
  - AskUserQuestion
---

# AWS Stack Management

Wraps `scripts/aws/manage_aws_stack.sh` for managing EC2 instances via CloudFormation.

## Defaults

Always apply these unless the user overrides:

| Setting | Default |
|---------|---------|
| Region | `us-west-2` |
| Instance type | `m5.xlarge` |
| Stack naming | `jcope-ushift-<purpose>` |
| SSH key | `~/.ssh/id_rsa.pub` |
| AWS profile | `AWS_PROFILE=microshift-dev` |
| OS | ask the user |

## Environment

Always prefix all commands with `AWS_PROFILE=microshift-dev`.

The script is at `scripts/aws/manage_aws_stack.sh` relative to the repo root. Use `$CWD` or the microshift repo root as the working directory.

## Argument Parsing

Parse `$ARGUMENTS` to extract the subcommand and any flags:

```
$ARGUMENTS = "<subcommand> [name] [--os <os>] [--inst-type <type>] [--region <region>] [--arch <arch>]"
```

If `$ARGUMENTS` is empty, show usage help and stop.

## Subcommands

### `create [name] [--os <os>] [--inst-type <type>] [--region <region>]`

1. If no name is provided, ask the user. Prepend `jcope-ushift-` if they give a bare name (e.g., `test` becomes `jcope-ushift-test`).
2. If no OS is provided, ask the user which OS to use. Suggest `rhel-9.4` and `rhel-10` as options.
3. Apply defaults for region and instance type if not provided.
4. Run the `ami` subcommand first to verify AMIs exist for the selected OS/region/arch. Show the latest AMI to the user.
5. Confirm the full configuration with the user before creating.
6. Run:
   ```bash
   AWS_PROFILE=microshift-dev ./scripts/aws/manage_aws_stack.sh create \
       --stack-name <name> \
       --region <region> \
       --inst-type <inst-type> \
       --os <os>
   ```
   Use a 600-second timeout — CloudFormation is slow.
7. When done, report the public IP and print the SSH command:
   ```
   ssh ec2-user@<public-ip>
   ```

### `delete [name] [--region <region>]`

1. If no name is provided, list active CloudFormation stacks to help the user pick:
   ```bash
   AWS_PROFILE=microshift-dev aws --region us-west-2 cloudformation list-stacks \
       --stack-status-filter CREATE_COMPLETE UPDATE_COMPLETE \
       --query 'StackSummaries[?starts_with(StackName, `jcope-ushift`)].{Name:StackName,Created:CreationTime,Status:StackStatus}' \
       --output table
   ```
   Then ask which stack to delete.
2. **Always confirm with the user before deleting.**
3. Run:
   ```bash
   AWS_PROFILE=microshift-dev ./scripts/aws/manage_aws_stack.sh delete \
       --stack-name <name> \
       --region <region>
   ```
   Use a 600-second timeout.

### `describe [name] [--region <region>]`

1. If no name is provided, ask the user.
2. Run:
   ```bash
   AWS_PROFILE=microshift-dev ./scripts/aws/manage_aws_stack.sh describe \
       --stack-name <name> \
       --region <region>
   ```

### `logs [name] [--region <region>]`

1. If no name is provided, ask the user.
2. Run:
   ```bash
   AWS_PROFILE=microshift-dev ./scripts/aws/manage_aws_stack.sh logs \
       --stack-name <name> \
       --region <region>
   ```

### `ami [--os <os>] [--arch <arch>] [--region <region>]`

1. Apply defaults if not provided (region=us-west-2). OS and arch are optional filters.
2. Run:
   ```bash
   AWS_PROFILE=microshift-dev ./scripts/aws/manage_aws_stack.sh ami \
       --region <region> \
       [--os <os>] \
       [--arch <arch>]
   ```
3. Present results as a table.

## Usage Help

When no arguments are provided, display:

```
/aws-stack — Manage AWS EC2 instances via CloudFormation

  /aws-stack create [name] [--os rhel-10] [--inst-type m5.xlarge] [--region us-west-2]
  /aws-stack delete [name] [--region us-west-2]
  /aws-stack describe [name] [--region us-west-2]
  /aws-stack logs [name] [--region us-west-2]
  /aws-stack ami [--os rhel-10] [--arch x86_64] [--region us-west-2]

Defaults: region=us-west-2, inst-type=m5.xlarge, naming=jcope-ushift-*
```
