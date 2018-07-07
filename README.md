# JiraHelper PowerShell Module

A PowerShell module inspired by the [oh-my-zsh jira](https://github.com/robbyrussell/oh-my-zsh) plugin

## Install

``` powershell

PS> Import-Module JiraHelper.psd1
```

## Usage

This module adds a single PowerSHell alias called `jira`

```
jira            # Opens an existing issues matching the current git branch
jira new        # Opens a new issue
jira dashboard  # Opens your JIRA dashboard
jira branch     # Opens an existing issues matching the current git branch
jira ABC-123    # Opens an existing issue
```

## Setup

* `$ENV:JIRA_URL` **Required**

The base URL for the Jira instance, e.g. `https://jira.company.com`

* `$ENV:JIRA_RAPID_BOARD`

The view id number of the dashboard to display with the `dashboard` command e.g. if the dashboard you want to display is `https://jira.company.com/secure/RapidBoard.jspa?rapidView=783`, then `$ENV:JIRA_RAPID_BOARD` should be set to `783`
