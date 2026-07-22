param(
    [Parameter(Mandatory = $false)]
    [string]$FlowUrl = $env:FLOW_URL,

    [Parameter(Mandatory = $false)]
    [string]$Message = "Connectivity test from PowerShell script",

    [Parameter(Mandatory = $false)]
    [string]$IssueKey = "TEST-123",

    [Parameter(Mandatory = $false)]
    [string]$Assignee = "Unassigned",

    [Parameter(Mandatory = $false)]
    [string]$DueDate = "Not set",

    [Parameter(Mandatory = $false)]
    [string]$Priority = "Medium",

    [Parameter(Mandatory = $false)]
    [string]$JiraIssueUrl = "https://example.invalid/browse/TEST-123",

    [Parameter(Mandatory = $false)]
    [switch]$ShowPayload
)

$ErrorActionPreference = 'Stop'

function New-AdaptiveCardPayload {
    param(
        [string]$IssueKey,
        [string]$Message,
        [string]$Assignee,
        [string]$DueDate,
        [string]$Priority,
        [string]$JiraIssueUrl
    )

    $safeAssignee = if ([string]::IsNullOrWhiteSpace($Assignee)) { 'Unassigned' } else { $Assignee }
    $safeDueDate = if ([string]::IsNullOrWhiteSpace($DueDate)) { 'Not set' } else { $DueDate }
    $safePriority = if ([string]::IsNullOrWhiteSpace($Priority)) { 'Medium' } else { $Priority }
    $safeIssueKey = if ([string]::IsNullOrWhiteSpace($IssueKey)) { 'Unknown' } else { $IssueKey }
    $safeMessage = if ([string]::IsNullOrWhiteSpace($Message)) { 'No summary provided.' } else { $Message }
    $safeJiraIssueUrl = if ([string]::IsNullOrWhiteSpace($JiraIssueUrl)) { 'https://example.invalid/' } else { $JiraIssueUrl }

    return [ordered]@{
        type = 'AdaptiveCard'
        '$schema' = 'http://adaptivecards.io/schemas/adaptive-card.json'
        version = '1.5'
        body = @(
            [ordered]@{
                type = 'TextBlock'
                text = 'Jira Action Item'
                weight = 'Bolder'
                size = 'Large'
                wrap = $true
            },
            [ordered]@{
                type = 'FactSet'
                facts = @(
                    [ordered]@{
                        title = 'Issue Key'
                        value = $safeIssueKey
                    },
                    [ordered]@{
                        title = 'Summary'
                        value = $safeMessage
                    },
                    [ordered]@{
                        title = 'Assignee'
                        value = $safeAssignee
                    },
                    [ordered]@{
                        title = 'Due Date'
                        value = $safeDueDate
                    },
                    [ordered]@{
                        title = 'Priority'
                        value = $safePriority
                    }
                )
            }
        )
        actions = @(
            [ordered]@{
                type = 'Action.OpenUrl'
                title = 'Open Jira'
                url = $safeJiraIssueUrl
            }
        )
    }
}

if ([string]::IsNullOrWhiteSpace($FlowUrl)) {
    Write-Error "Flow URL is required. Pass -FlowUrl or set FLOW_URL environment variable."
    exit 1
}

$payload = New-AdaptiveCardPayload -IssueKey $IssueKey -Message $Message -Assignee $Assignee -DueDate $DueDate -Priority $Priority -JiraIssueUrl $JiraIssueUrl

$jsonBody = $payload | ConvertTo-Json -Depth 10

if ($ShowPayload) {
    Write-Output $jsonBody
}

try {
    $resp = Invoke-WebRequest -Uri $FlowUrl -Method Post -Body $jsonBody -ContentType 'application/json' -UseBasicParsing
    Write-Output ("STATUS:" + [string]$resp.StatusCode)

    if ([string]::IsNullOrWhiteSpace($resp.Content)) {
        Write-Output "NO_CONTENT"
    }
    else {
        Write-Output $resp.Content
    }

    if ($resp.StatusCode -ge 200 -and $resp.StatusCode -lt 300) {
        exit 0
    }

    exit 2
}
catch {
    if ($_.Exception.Response) {
        $statusCode = [int]$_.Exception.Response.StatusCode
        Write-Output ("STATUS:" + [string]$statusCode)

        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $errorBody = $reader.ReadToEnd()

        if ([string]::IsNullOrWhiteSpace($errorBody)) {
            Write-Output $_.Exception.Message
        }
        else {
            Write-Output $errorBody
        }
    }
    else {
        Write-Output $_.Exception.Message
    }

    exit 1
}
