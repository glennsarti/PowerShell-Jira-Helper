function Get-JiraBaseURL {
  $url = $ENV:JIRA_URL
  if ($url -eq $null) { $url = "" }
  Write-Output $url
}

function Get-JiraRapidBoard {
  $value = $ENV:JIRA_RAPID_BOARD
  if ($value -eq $null) { $value = "" }
  Write-Output $value
}

function Invoke-Jira {
  [CmdletBinding(DefaultParameterSetName='FreeText')]
  Param (
    [Parameter(Mandatory=$true, ParameterSetName='NewIssue')]
    [Switch] $NewIssue,

    [Parameter(Mandatory=$true, ParameterSetName='Dashboard')]
    [Switch] $Dashboard,

    [Parameter(Mandatory=$true, ParameterSetName='Branch')]
    [Switch] $Branch,

    [Parameter(Mandatory=$true, ParameterSetName='IssueName')]
    [String] $IssueName = '',

    [Parameter(Mandatory=$false, ValueFromRemainingArguments=$true, ParameterSetName='FreeText')]
    [AllowEmptyCollection()]
    [String[]] $FreeText
  )

  Begin {
    if ((Get-JiraBaseURL) -eq "") {
      Write-Error "Missig JIRA_URL environment variable e.g. https://tickets.company.com"
      return
    }

    if ($PsCmdlet.ParameterSetName -eq 'FreeText') {
      if ($FreeText.Count -eq 0) {
        $Branch = $true
      } else {
        switch ($FreeText[0]) {
          'new' { $NewIssue = $true; break; }
          'dashboard' { $Dashboard = $true; break; }
          'reported' { break; }
          'assigned' { break; }
          'branch' { break; }
          default {
            $IssueName = $FreeText[0]
            break;
          }
        }
      }
    }
  }

  Process {
    $url = ''
    if ($Branch) {
      $gitBranch = (& git rev-parse --abbrev-ref HEAD)
      if ($gitBranch -match '^[a-zA-Z]+-[\d]+') {
        $url = ( (Get-JiraBaseURL) + "/secure/CreateIssue!default.jspa")
      } else {
        Write-Output "Unable to determin Jira ticket from branch '${gitbranch}'"
      }
    }
    if ($NewIssue) {
      $url = ( (Get-JiraBaseURL) + "/secure/CreateIssue!default.jspa")
    }
    if ($Dashboard) {
      $rapidBoard = (Get-JiraRapidBoard)
      if ($rapidBoard -ne "") {
        $url = ( (Get-JiraBaseURL) + "/secure/RapidBoard.jspa?rapidView=" + $rapidBoard)
      } else {
        $url = ( (Get-JiraBaseURL) + "/secure/Dashboard.jspa")
      }
    }
    if ($IssueName -ne '') {
      $url = ( (Get-JiraBaseURL) + "/browse/" + $IssueName)
    }

    if ($url -ne '') { Start-Process $url }
  }
}

Set-Alias -Name jira -Value Invoke-Jira
