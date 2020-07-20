# This program must be run from the command line.
# This program launches AFNI as a docker image. It also mounts into the container the volume "volume".
# To learn about volumes (they're wacky!) and moving files into or out of your container, see README.
# I began writing this on July 17, 2020. Please feel free to ask me any questions 🙂
# Ben Velie, veliebm@gmail.com
#-----------------------------------------------------------------------------------------------------------#

# Each of these parameters can be set from the command line, but they default to the values here.
Param(
    # Image to run inside the container.
    [String]
    $image = "afni/afni",

    # Volume to mount to the container.
    [CmdletBinding(PositionalBinding=$False)]
    [String]
    $source = "volume",

    # Sets the location of the volume inside the container.
    [CmdletBinding(PositionalBinding=$False)]
    [String]
    $destination = "/volume"
)


# Automatically start X Server if it isn't running.
$vcxsrv_running = Get-Process vcxsrv -ErrorAction SilentlyContinue
if (!$vcxsrv_running) {
    C:\"Program Files"\VcXsrv\vcxsrv.exe :0 -multiwindow -clipboard -wgl
    Write-Output "Starting X Server"
}

# Launch Docker if it isn't running.
docker ps 2>&1 | Out-Null
$docker_running = $?
if (!$docker_running) {
    Write-Output "Starting Docker"
    Start-Process 'C:/Program Files/Docker/Docker/Docker Desktop.exe'
}
while (!$docker_running) {
    Start-Sleep 5
    docker ps 2>&1 | Out-Null
    $docker_running = $?
}
Write-Output "Docker is running"

Write-Output "Mounting the volume '$source'"
Write-Output "You can access the files inside '$source' from inside your container by navigating to '$destination'"
Write-Output "To transfer data into or out of your container, use the command 'docker cp' in PowerShell"

# Launch the container.
docker run --interactive --tty --rm --name afni --mount source=$source,destination=$destination -p 8888:8888 --env DISPLAY=host.docker.internal:0 $image bash