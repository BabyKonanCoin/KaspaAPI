---
external help file: KaspaAPI-help.xml
Module Name: KaspaAPI
online version:
schema: 2.0.0
---

# Import-KasAddressPool

## SYNOPSIS
Imports a pool of addresses from a CSV file.

## SYNTAX

```
Import-KasAddressPool [[-FilePath] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
This function imports a pool of addresses from a CSV file.
You can either
provide the file path directly via the \`-FilePath\` parameter or use a file
selection dialog to choose the file.
The function extracts only the
\`address\` field from the CSV and returns the addresses while displaying
their count.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -FilePath
Optional file path to a CSV file

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

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

## NOTES

## RELATED LINKS