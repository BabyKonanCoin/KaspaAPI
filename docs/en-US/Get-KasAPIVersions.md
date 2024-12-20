---
external help file: KaspaAPI-help.xml
Module Name: KaspaAPI
online version:
schema: 2.0.0
---

# Get-KasAPIVersions

## SYNOPSIS
Loads API versions from the JSON file in the Config directory.

## SYNTAX

```
Get-KasAPIVersions [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function retrieves the \`api_versions.json\` file stored in the \`Config\` directory under the KaspaAPI application data path.
If the file does not exist, it creates a default JSON file with standard API URLs.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Collections.Hashtable
## NOTES

## RELATED LINKS
