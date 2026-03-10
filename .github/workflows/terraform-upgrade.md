---
on:
  workflow_dispatch:
    inputs:
      terraform_version:
        description: 'Target Terraform version to upgrade to'
        required: false
        type: string
      provider_upgrade:
        description: 'Upgrade Terraform providers'
        required: false
        type: boolean
        default: "true"
      create_pr:
        description: 'Create a pull request with changes'
        required: false
        type: boolean
        default: "true"

engine: copilot

permissions:
  pull-requests: read
  issues: read
  contents: read

tools:
  github:
    toolsets: [default, pull_requests]

mcp-servers:
  terraform:
    container: "hashicorp/terraform-mcp-server:0.3.3"
    env:
      TF_LOG: "INFO"
    allowed: ["*"]
  

safe-outputs:
  create-pull-request:
    title-prefix: "[terraform] "
    labels: [terraform, automation]
    draft: true
  create-issue:
    title-prefix: "[terraform] "
    labels: [terraform, recommendations]
  update-issue:

network:
  allowed:
    - defaults
    - github
    - terraform

imports:
  - thomast1906/github-copilot-agent-skills/.github/agents/terraform-provider-upgrade.agent.md@main
  - thomast1906/github-copilot-agent-skills/.github/skills/terraform-provider-upgrade/SKILL.md@main
---

# Terraform Upgrade Workflow

Perform safe Terraform and provider upgrades for this repository.

## Workflow Context

**Trigger**: This workflow runs weekly on Mondays at 9 AM UTC, or can be triggered manually.

**Inputs**:
- `terraform_version`: Optional target Terraform version (e.g., "1.7.0"). If not specified, check for latest stable version.
- `provider_upgrade`: Whether to upgrade providers (default: true)
- `create_pr`: Whether to create a pull request with changes (default: true). If false, create an issue with recommendations instead.

## Your Task

Perform Terraform upgrades according to your imported expertise and methodology. Use the workflow inputs to guide your work.

**Important:** Only modify files under the `terraform/` directory. Do NOT create or modify any files under `.github/`.

In addition to version and breaking-change analysis, you must always perform a deprecation scan.

### Required deprecation handling

1. Detect deprecated Terraform/provider arguments, blocks, and resources used in this repository.
2. Attempt safe auto-fixes for deprecations when there is a clear, low-risk replacement.
3. If an auto-fix is not safe or requires human input, keep the current code and document the recommendation.

### PR/Issue output requirements

When complete, create a pull request (if `create_pr` is true) or an issue (if false) with findings and changes.

Your output must always include a **Deprecations** section with:
- Deprecated item found (argument/resource/block)
- File and resource context
- Recommended replacement
- Auto-fix status: `applied` or `manual-action-required`
- Reason when not auto-fixed

If no deprecations are found, explicitly state: **"No deprecated arguments/resources detected."**
