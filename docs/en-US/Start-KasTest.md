---
external help file: KaspaAPI-help.xml
Module Name: KaspaAPI
online version:
schema: 2.0.0
---

# Start-KasTest

## SYNOPSIS
Processes Kaspa wallet addresses to retrieve KRC20 token information.

## SYNTAX

```
Start-KasTest [-Addresses] <Array> [-Tick] <String> [-ModulePath] <String> [-AppenedUniqueAddresses]
 [-AppendTickHolders] [-DumpTxAddresses] [-ReturnUniqueAddresses] [[-MaxJobs] <Int32>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
\`Start-KasTest\` retrieves KRC20 token balances and unique addresses from
transactions for each wallet address.
It supports concurrent jobs to
process addresses in parallel and can output results to CSV or XML files.

## EXAMPLES

### EXAMPLE 1
```
$params = @{
    Addresses              = @("kaspa:address", "kaspa:another address")
    Tick                   = "DOGE"
    ModulePath             = "C:\Modules\KaspaAPI\KaspaAPI.psm1"
    AppenedUniqueAddresses = $true
    AppendTickHolders      = $true
    DumpTxAddresses        = $true
    MaxJobs                = 8
}
Start-KasTest @params
```

### EXAMPLE 2
```
$results = Start-KasTest -Addresses $addresses -Tick "konan"
-AppenedUniqueAddresses -AppendTickHolders -DumpTxAddresses
-Verbose -MaxJobs 8 -ModulePath
```

## PARAMETERS

### -Addresses
Array of Kaspa wallet addresses to process.

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Tick
KRC20 token ticker to filter balance information.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ModulePath
Path to PowerShell module for dependencies.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AppenedUniqueAddresses
Append unique addresses to a CSV file.

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

### -AppendTickHolders
Append verified holders to a CSV file.

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

### -DumpTxAddresses
Dump unique addresses found in transactions to a file.

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

### -ReturnUniqueAddresses
{{ Fill ReturnUniqueAddresses Description }}

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

### -MaxJobs
Maximum number of concurrent jobs (1-8).
If 0 or 1, runs serially.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: 0
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
Requires Kaspa blockchain API and specified module dependencies.

## RELATED LINKS
