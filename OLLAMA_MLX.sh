#!/bin/zsh
#create a virtual env / bin for our project
# Environment variables for Ollama configuration
export OLLAMA_MAX_LOADED_MODELS=4
export OLLAMA_DEBUG=true
export OLLAMA_LLM_LIBRARY=/Users/ih0dl/lib/python3.11/site-packages
export OLLAMA_FLASH_ATTENTION=true
export OLLAMA_KEEP_ALIVE=400
export OLLAMA_NOPRUNE=true
export OLLAMA_NUM_PARALLEL=4
export OLLAMA_HOST=0.0.0.0
export OLLAMA_ORIGINS=*
export OLLAMA_TEMPDIR=./ollama/temp

# Start ollama in the background and redirect output to a log file
nohup ollama serve > ollama.log 2>&1 & #this should be refactored to use mlx backend instead

# Check if "open-webui" Docker container is running, if not, run the command
if ! docker ps | grep -q open-webui; then
    if docker images | grep -q ghcr.io/open-webui/open-webui; then
        docker run -d -p 3000:8080 --add-host=host.docker.internal:host-gateway -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:main
    else
        docker pull ghcr.io/open-webui/open-webui:main
        docker run -d -p 3000:8080 --add-host=host.docker.internal:host-gateway -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:main
    fi
fi
# Show an image in the status bar on Mac OS indicating that ollama is running
osascript -e "tell application \"System Events\" to display dialog \"ollama is running\" with icon POSIX file \"/Users/ih0dl/server.png\""

# Function to display server logs
function show_logs {
    tail -f ollama.log
}

# Function to stop all started processes
function stop_processes {
    pkill ollama
    docker stop open-webui
    docker rm open-webui
}

# Integration with context file: server.py
# Assumed that server.py is a script to connect with open-webui

function integrate_context {
    python3 /path/to/server.py
}

