# Introduction
This repository contains a Dockerfile that creates an environment containing all the 
dependencies to develop [Rasa](https://github.com/RasaHQ/rasa/). The detais of the 
dependencies are described in the repo's [README](https://github.com/RasaHQ/rasa/#development-internals).

# Usage

1. Navigate to this project's root directory.

2. Build the image:

    ```bash
    docker build -t rasa-dev .
    ```
3. Run the container:
    
   ```bash
    docker run -p 23:22 -p 8000:8000 -v /PATH/TO/RASA:/app --name rasa-dev rasa-dev:latest  
   ```
   where `/PATH/TO/RASA` is the path to the root of your local Rasa repo.

4. Set up a remote interpreter via SSH
 
   You may use your IDE to set up a remote interpreter via SSHing into the container using port 23
   using username `root` and password `abc123`.
   
   The python interpreter is located at `/usr/local/bin/python`.
   
# Feedback
Feel free to raise an issue if you have any questions, feedback, etc.