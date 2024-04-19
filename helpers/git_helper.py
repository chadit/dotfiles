#!/usr/bin/env python3

# git.py
# This script clones a list of git repositories, builds them and installs them.
# The configuration is stored in a JSON file.
# The script uses the gitpython library to clone the repositories.

import os
import subprocess
import json
import platform
from git import Repo
from pathlib import Path

# Determine the operating system
os_type = platform.system()

# Function to get home directory based on OS and whether sudo was used
def get_home_directory():
    sudo_user = os.environ.get('SUDO_USER')
    if sudo_user:
        # For macOS and Linux the home directories are usually in different locations
        if os_type == 'Darwin':  # macOS
            return Path('/Users', sudo_user)
        elif os_type == 'Linux':
            return Path('/home', sudo_user)
        else:
            raise EnvironmentError(f"Unsupported operating system: {os_type}")
    else:
        # Use the current user's home directory
        return Path.home()

def main():
  print("Starting the git helper script.")
  # Your configuration JSON
  json_text = '''
  [
    {
      "repo": "git@github.com:junegunn/fzf.git",
      "folder": "***/Projects/src/github.com/junegunn/fzf/",
      "prebuild": "cd ***/Projects/src/github.com/junegunn/fzf/",
      "build": ["git reset --hard", "git pull", "./install"],
      "postbuild": "sudo cp ***/Projects/src/github.com/junegunn/fzf/bin/fzf /usr/local/bin/fzf"
    },
    {
      "repo": "git@github.com:eradman/entr.git",
      "folder": "***/Projects/src/github.com/eradman/entr/",
      "prebuild": "cd ***/Projects/src/github.com/eradman/entr/",
      "build": ["git reset --hard", "git pull", "./configure", "make test", "make install"],
      "postbuild": ""
    }
  ]
  '''

  # Parse the JSON
  projects = json.loads(json_text)

  # todo, elevate permissions if sudo in command
  
  def run_command(command, capture_output=False):
    if capture_output:
        # Capture output for further processing
        result = subprocess.run(command, shell=True, text=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        if result.returncode != 0:
            print(f"Error executing '{command}': {result.stderr}")
        return result.stdout, result.stderr
    else:
        # Display output in real-time
        result = subprocess.run(command, shell=True, text=True)
        if result.returncode != 0:
            print(f"Error: Command '{command}' failed with exit status {result.returncode}")
        return result
  
  # Determine the original user
  original_user = os.getenv('SUDO_USER', os.getenv('USER'))  
  home_dir = str(get_home_directory())
  print(home_dir)
  

  for project in projects:
      p_folder = str(project["folder"]).replace("***", home_dir)
      print(f"{p_folder}")
      folder = Path(p_folder) #os.path.expandvars(p_folder)
      Path(folder).mkdir(parents=True, exist_ok=True)
      
      if not list(Path(folder).glob('.git')):
          print(f"Cloning {project['repo']} into {folder}")
          Repo.clone_from(project['repo'], folder)
          # fix ownership
          run_command(f"chown -R {original_user}:{original_user} {p_folder}")
      
      os.chdir(folder)
      pb_folder = str(project["prebuild"]).replace("***", home_dir)
      print(f"{pb_folder}")
      if pb_folder:
          run_command(pb_folder)
      
      for cmd in project["build"]:
          print(f"Running command: {cmd}")
          run_command(cmd)
      
      pob_folder = str(project["postbuild"]).replace("***", home_dir)
      if pob_folder:
          run_command(pob_folder)

  print("Completed all operations successfully.")

if __name__ == "__main__":
    main()
