# This demo will show how to use PowerShell remoting to either start a 
# session on a remote system, just like SSH, or to execute commands on a 
# remote session without having to enter a session.

# Before this will work, there is some setup that must be done. Please see
# the file Configure Remoting on Ubuntu.md for full instructions. 

# Let's start by creating a session against a remote server. Note that as we
# enabled ssh key login on the remote server, we won't be prompted for a 
# password. 
$session = New-PSSession -HostName ubuntu -UserName cknapp

# Display the contents of the session variable.
$session

# Use the following command to start an interactive session with the remote
# server. Note how the command line prompt in the terminal window updates
# to show the remote server name. 
Enter-PSSession -Session $session

# You will see the prompt change to the server name. Now any commands you
# run will be executed on the server.

Get-Process | Sort-Object CPU | Select-Object -First 10

# You can also run commands on a remote machine without having to enter its
# interactive terminal. First, exit the current remote session to return
# to the local computer
Exit-PSSession

# You can use Invoke-Command to execute a script block on a remote system
# Even though we only have one simple command, it still must be in a
# script block. 
Invoke-Command $session -ScriptBlock { Get-ChildItem }

# We can compose a more complex script block to pass in
$command = { Get-Process |
             Sort-Object CPU |
             Select-Object Name, WorkingSet, PrivateMemorySize, VirtualMemorySize, Id, SI -First 5 |
             Format-Table -AutoSize
           }

# Now  you can run the command on the remote machine without 
# having to Enter into a PSSession (aka ssh) into it
Invoke-Command $session -ScriptBlock $command |
  Format-Table -AutoSize

