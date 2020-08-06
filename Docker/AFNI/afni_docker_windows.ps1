<#
.SYNOPSIS
Launches AFNI within a Docker container.
.DESCRIPTION
First, this program launches X Server and Docker if they aren't running. Then, it launches AFNI within a Docker container.
Contact me via email or Slack if you need help. I'm here whenever you need me 🙂
Created July 17, 2020
Ben Velie
veliebm@ufl.edu
.LINK
Check out our repository!
https://github.com/csea-lab/csea-lab/
#>

#region Parameters 
Param(
    # Image to run inside the container.
    [String]
    $image = "afni/afni",

    # Name of the container.
    [String]
    $name = "afni",

    # Writeable directory to mount to the container.
    [CmdletBinding(PositionalBinding=$False)]
    [String]
    $write_source = "/c/Volumes/volume/",

    # Sets the location of the writeable directory within the container.
    [CmdletBinding(PositionalBinding=$False)]
    [String]
    $write_destination = "/write_host/",

    # Read-only directory to mount to the container.
    [CmdletBinding(PositionalBinding=$False)]
    [String]
    $read_source = "/c/users/$env:UserName/",

    # Sets the location of the read-only directory within the container.
    [CmdletBinding(PositionalBinding=$False)]
    [String]
    $read_destination = "/read_host/",

    # Sets the working directory within the container.
    [CmdletBinding(PositionalBinding=$False)]
    [String]
    $workdir = "/write_host/",

    # Sets the port the container runs on.
    [CmdletBinding(PositionalBinding=$False)]
    [String]
    $p = "8889:8889",

    # Sets whether the AFNI GUI is enabled.
    [CmdletBinding(PositionalBinding=$False)]
    [switch]
    $enableGUI
)
#endregion

#region Test-Process()
function Test-Process{
    <#
    .DESCRIPTION
    Returns true if $process is running.
    #>
    Param($process)
    return Get-Process $process -ErrorAction SilentlyContinue
}
#endregion

#region Test-Docker()
function Test-Docker{
    <#
    .DESCRIPTION
    Returns true if Docker is running.
    .NOTES
    We use this function instead of Test-Process because Test-Process doesn't work well for Docker.
    #>
    docker ps 2>&1 | Out-Null
    return $?
}
#endregion

#region Open-XServer()
function Open-XServer {
    <#
    .DESCRIPTION
    Launches X Server if it isn't running.
    #>
    if (!(Test-Process vcxsrv)) {
        Write-Output "Starting X Server"
        C:\"Program Files"\VcXsrv\vcxsrv.exe :0 -multiwindow -clipboard -wgl
    }
    while (!(Test-Process vcxsrv)) {
        Start-Sleep 5
    }
    Write-Output "X Server is running"
}
#endregion

#region Open-Docker()
function Open-Docker() {
    <#
    .DESCRIPTION
    Opens Docker if it's not already running.
    #>
    if (!(Test-Docker)) {
        Write-Output "Starting Docker"
        Start-Process 'C:/Program Files/Docker/Docker/Docker Desktop.exe'
    }
    while (!(Test-Docker)) {
        Start-Sleep 5
    }
    Write-Output "Docker is running"
}
#endregion

#region Launch Docker and XServer
Open-Docker
if($enableGUI){
    Open-XServer
}
#endregion

#region Set mount locations
Write-Output "From within your container, you can READ anything in $read_source by navigating to $read_destination"
$read_mount = $read_source + ":" + $read_destination + ":ro"
Write-Output "From within your container, you can read OR write anything in $write_source by navigating to $write_destination"
$write_mount = $write_source + ":" + $write_destination
#endregion

#region Launch the container
$GUI = "DISPLAY=host.docker.internal:0"
if ($enableGUI) {
    Write-Output "The GUI is enabled, which can make the container buggy"
    Write-Output "Please run the container without the GUI unless you're using the AFNI viewer"
    docker run --interactive --tty --rm --name $name --volume $write_mount --volume $read_mount --workdir $workdir -p $p --env $GUI $image bash
} else {
    Write-Output "The GUI is disabled"
    Write-Output "To enable the GUI, launch this script with the flag -enableGUI"
    docker run --interactive --tty --rm --name $name --volume $write_mount --volume $read_mount --workdir $workdir -p $p $image bash
}
#endregion