---
external help file: KaspaAPI-help.xml
Module Name: KaspaAPI
online version:
schema: 2.0.0
---

# Get-KasTop50

## SYNOPSIS
Retrieves top 50 data for a given token tick from Kasplex API and optionally exports the results to a CSV file.

## SYNTAX

### FilePathSet
```
Get-KasTop50 -Tick <String> [-ReturnAddressesOnly] [-FilePath <String>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### SelectPathSet
```
Get-KasTop50 -Tick <String> [-ReturnAddressesOnly] [-SelectPathToExport] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
This function validates the input tick symbol to ensure it is between 4 and 6 characters in length.
It fetches data from the Kasplex API for the specified token tick and can return either the full API data or
only the addresses of the top 50 holders.
Use \`-FilePath\` or \`-SelectPathToExport\` for exporting results to a CSV file.
The parameters \`-FilePath\` and \`-SelectPathToExport\` are mutually exclusive.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -Tick
Validates the length of the Tick parameter

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReturnAddressesOnly
{{ Fill ReturnAddressesOnly Description }}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilePath
{{ Fill FilePath Description }}

```yaml
Type: String
Parameter Sets: FilePathSet
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SelectPathToExport
Optional file path for saving results
Prompts for save location if specified

```yaml
Type: SwitchParameter
Parameter Sets: SelectPathSet
Aliases:

Required: False
Position: Named
Default value: False
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
