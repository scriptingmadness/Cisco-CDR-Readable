# CiscoCDRReadable
CUCM CDR Field Processing

The script here takes a single CDR file stated in the script and will then process the CDR file and replace the unreadable fields.

File - IPToReplace.txt is used to set the fields to replace the IP address e.g origIpAddr,destIpAddr
File - TimeToReplace.txt is used to set the filed to replace the UNIX/EPOCH time e.g dateTimeOrigination,dateTimeDisconnect
File - StringReplace.ps1 is the script that will parse the CDR file and make it slightly more readable

