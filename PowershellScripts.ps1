function ReplaceFiles() {
    Param(
        [Parameter(Mandatory=$true)]
        [System.String]
        $sourceDir,
        [Parameter(Mandatory=$true)]
        [System.String]
        $destinationDir,
        [Parameter(Mandatory=$true)]
        [System.String[]]
        $fileNames)

    foreach ($filename in $fileNames)
    {
        ReplaceFile -sourceDir $sourceDir -destinationDir $destinationDir -fileName $filename
    }
}

function ReplaceFile() {
    Param(
        [Parameter(Mandatory=$true)]
        [System.String]
        $sourceDir,
        [Parameter(Mandatory=$true)]
        [System.String]
        $destinationDir,
        [Parameter(Mandatory=$true)]
        [System.String[]]
        $fileName)

    $sourceFiles = Get-ChildItem -Path $sourceDir -Filter $fileName -Recurse

    if(@($sourceFiles).length -gt 1){
        echo("More than one instances of the source file were found, returning");
        echo($sourceFiles);
        return;
    }

    foreach ($sourceFile in $sourceFiles) {        
        echo ("SourceFile: " + $sourceFile.FullName);
        $destinationFiles = Get-ChildItem -Path $destinationDir -Filter $fileName -Recurse
    
        $localPathForSourceFile = $null;

        foreach($destinationFile in $destinationFiles) {
            $sourcePath = If($localPathForSourceFile -eq $null) {$sourceFile.FullName} else {$localPathForSourceFile}; 

            try {
                Copy-Item -Path $sourcePath -Destination $destinationFile.FullName -force;
                $localPathForSourceFile = $destinationFile.FullName;
                echo ("Copied: " + $sourcePath + " to " + $destinationFile.FullName);
            } catch {
                echo("Following exception encountered while copying: " + $sourcePath + " to " + $destinationFile.FullName)
                echo($_.ErrorDetails.Message);
            }
        }
    }
}