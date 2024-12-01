function Get-KasBanner {
    Clear-Host

 Write-Host "____  _  _____  _   _    _    _   _
| __ )| |/ / _ \| \ | |  / \  | \ | |
|  _ \| ' / | | |  \| | / _ \ |  \| |
| |_) | . \ |_| | |\  |/ ___ \| |\  |
|____/|_|\_\___/|_| \_/_/   \_\_| \_|__ ___
| |/ /__ _ ___ _ __   __ _   / \  |  _ \_ _|
| ' // _` / __| '_ \ / _` | / _ \ | |_) | |
| . \ (_| \__ \ |_) | (_| |/ ___ \|  __/| |
|_|\_\__,_|___/ .__/ \__,_/_/   \_\_|  |___|
              |_|
" -ForegroundColor Green

    $credits =  "Baby Konan Coin" +
                "`nversion 0.1.0" +
                "`nGitHub:https://github.com/BabyKonanCoin/KaspaAPI"
                "`nMkDocs:https://babykonancoin.github.io/KaspaAPI/"

    Write-Host "$credits " -ForegroundColor Gray
}


