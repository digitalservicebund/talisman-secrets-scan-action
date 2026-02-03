# Detect secrets with Talisman action

This action uses [Talisman](https://thoughtworks.github.io/talisman/) to scan the incoming (pushed) range of commits for
accidentally added secrets and sensitive information. It mimics a pre-push hook for this, thus it works nicely with a
local git hook in tandem, that is as a fallback, last line of defense.

## Example usage

```yml
steps:
  - name: Detect secrets with Talisman in incoming commits
    uses: digitalservicebund/talisman-secrets-scan-action@51e8f53696246ae85288ce56e483a44d96fea241
```

### Example Workflow

```yaml
name: Secret Scan

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]
  workflow_dispatch:

jobs:
  secret-scan:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v5
        with:
          fetch-depth: 0 # Fetch the full history
      - name: Detect secrets with Talisman in incoming commits
        uses: digitalservicebund/talisman-secrets-scan-action@51e8f53696246ae85288ce56e483a44d96fea241
```

## Caveat

The action `actions/checkout@v6` fetches only the current commit by default, not the whole history. That's why you need
to configure it to avoid shallow clone and fetch the full history.

```yml
- uses: actions/checkout@v6
  with:
    fetch-depth: 0 # Fetch the full history
```

Otherwise, you may run into Talisman erroring out while it's trying to execute git with an invalid revision range:

```
time="2021-09-19T07:07:32Z" level=fatal msg="Git command execution failed" command="git diff 0c4a631e70056a95df1c235d238a80828e07cf9c..a32a5c7e1a3d250bf18a080a44a764d9b93b9690 --name-only --diff-filter=ACM" dir=/github/workspace error="exit status 128" output="fatal: Invalid revision range 0c4a631e70056a95df1c235d238a80828e07cf9c..a32a5c7e1a3d250bf18a080a44a764d9b93b9690\n"
```
