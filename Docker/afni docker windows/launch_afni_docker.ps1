# Currently this program must be run from the command line.
# This program launches AFNI as a docker image. It also mounts into the container the volume "volume".
# To learn about volumes (they're wacky!), visit https://docs.docker.com/storage/volumes/
# To transfer files to and from a volume, learn how at https://docs.docker.com/engine/reference/commandline/cp/
# Remember to place start_docker_process.py in the same folder.
# Also, remember to start XLaunch if you want to use AFNI's GUI.
# I began writing this on July 17, 2020. Please feel free to ask me any questions 🙂
# Ben Velie, veliebm@gmail.com
#-----------------------------------------------------------------------------------------------------------#

# Each of these parameters can be set from the command line, but they default to the values here.
Param(
    [String]
    $image = "afni/afni",

    [CmdletBinding(PositionalBinding=$False)]
    [String]
    $source = "volume",

    [CmdletBinding(PositionalBinding=$False)]
    [String]
    $destination = "/volume"
)

$vcxsrv_running = Get-Process vcxsrv -ErrorAction SilentlyContinue
if (!$vcxsrv_running) {
    C:\"Program Files"\VcXsrv\vcxsrv.exe :0 -multiwindow -clipboard -wgl
    Write-Output "Starting X Windows"
}


# start_docker_process.py launches docker as an administrator if it isn't already running. You must run docker
# as an administrator on Windows. If you don't, then you won't be able to connect to the server.
python ./start_docker_process.py

Write-Output "Mounting the volume '$source'"
Write-Output "You can access the files inside '$source' from inside your container by navigating to '$destination'"
Write-Output "To transfer data into or out of your container, use the command 'docker cp' in PowerShell"

# Launch the container.
docker run --interactive --tty --rm --mount source=$source,destination=$destination -p 8888:8888 --env DISPLAY=host.docker.internal:0 $image bash