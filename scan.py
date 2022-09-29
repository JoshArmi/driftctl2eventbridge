import functools
import os
import subprocess

state_files = os.getenv("STATEFILES")

if not state_files:
  state_files = "terraform.tfstate"

files = [file for file in state_files.split(" ")]
file_parameters = []
for file in files:
  if "://" in file:
    file_parameters.append(f"-f tfstate+{file}")
  else:
    file_parameters.append(f"-f tfstate://{file}")

file_parameter = functools.reduce(lambda p, q: f"{p} {q}", file_parameters)
command = f"driftctl scan --output json://result.json {file_parameter}"
subprocess.run(command, shell=True)
