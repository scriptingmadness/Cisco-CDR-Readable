##This file has 2 text files that will list the items to replace, each text file is needed to set which items to changes
##IPToReplace will execute the IP address change
##TimeToReplace will execute the UNIX time to readable time



##Sets a lower execution level
##If you dont want to change the execution level just highlight the next line, right click, run selection
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
cd $PSScriptRoot

$SourceFile = ".\cdr_StandAloneCluster_07_201605310908_48"
$OutputFile = ".\OutputFile.csv"

$CSVObject = import-csv $SourceFile
$IPToReplaceContent = Get-Content .\IPToReplace.txt
$TimeToReplaceContent = Get-Content .\TimeToReplace.txt

$IPToReplace = $IPToReplaceContent.split(',')
$TimeToReplace = $TimeToReplaceContent.split(',')

$CSVObject | foreach{


 if ($_.origIpAddr -ne "INTEGER") ##First item in the HASHTABLE is the header so this will skip
    {

        foreach ($item in $IPToReplace){

            if ($_.$item -ne "0")##Checks if the value is not zero
            {
                ##Accepts a decimal number then converts to HEX
                [int]$DECInt = $_.$item
                $HexString = '{0:X2}' -f  $DECInt
   
                ##Splits the originak string into HEX pairs
                $ONE = $HEXString.Substring(0,2)
                $TWO = $HEXString.Substring(2,2)
                $THREE = $HEXString.Substring(4,2)
                $FOUR = $HEXString.Substring(6,2)

                ##Converts the HEX pairs to decimal
                $OCT1 = [Convert]::ToInt64($FOUR, 16)
                $OCT2 = [Convert]::ToInt64($THREE, 16)
                $OCT3 = [Convert]::ToInt64($TWO, 16)
                $OCT4 = [Convert]::ToInt64($ONE, 16)

                ##Builds the new string with the 4 octets
                $IPAddr = ($OCT1.ToString() + "." + $OCT2.ToString() + "." + $OCT3.ToString() + "." + $OCT4.ToString())
            
                ##Updates the object with the converted values
                $_.$item = $IPAddr 



            }else{}

        } ##END FOR INNTER FOREACH FOR ITEMS TO REPLACE IP


        ##THIS FOREACH LOOPS PASSES THE 2ND TEXT FILE 


            foreach ($item in $TimeToReplace){
               
            
           if ($_.$item -ne "0") ##Checks if the value is not zero
           {
                $_.$item = (Get-Date '1/1/1970').AddSeconds($_.$item)
      
           }else{}
        } ##END FOR INNTER FOREACH FOR ITEMS TO REPLACE TIME



        

    }  

} #END OF OUTER FOREACH FOR ROWS OF FILE

##THIS WILL OUTPUT ALL FIELD
#$CSVObject |  Export-Csv -Path $OutputFile -NoTypeInformation

##THIS WILL ONLY OUTPUT THE ITEMS IN THE SELECT
$CSVObject | select "cdrRecordType","globalCallID_callManagerId","globalCallID_callId","origLegCallIdentifier","dateTimeOrigination","origNodeId","origSpan","origIpAddr"  | Export-Csv -Path $OutputFile -NoTypeInformation