# Win7_to_Win10_RDP_Patch
Simple registry patch to allow Windows 7 clients to connect to Windows 10 hosts over RDP

Simply run `importCredSSP.bat` as an administrator, and the keys will be imported.

To remove the patch, run `importCredSSP.bat delete` as an administrator, and the keys will be deleted entirely.

Will only update the registry if the keys do not exist, or if the values are not set to the correct type.
