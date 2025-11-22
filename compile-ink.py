import argparse
from pathlib import Path
import sys
import platform

ink_root = Path("./Ink")
ink_out = Path("./Godot/Assets/InkFiles")
inklecate_root = Path("./bin")
inklecate_temp_zip = Path("./inklecate.zip")

match platform.system():
    case "Windows":
        inklecate_filename = "inklecate.exe"
        inklecate_zip = "https://github.com/inkle/ink/releases/download/v.1.2.0/inklecate_windows.zip"
    case "Linux":
        inklecate_filename = "inklecate"
        inklecate_zip = "https://github.com/inkle/ink/releases/download/v.1.2.0/inklecate_linux.zip"
    case "Darwin":
        inklecate_filename = "inklecate"
        inklecate_zip = "https://github.com/inkle/ink/releases/download/v.1.2.0/inklecate_mac.zip"
    case _:
        print("Unknown OS")
        sys.exit(1)

inklecate = inklecate_root / inklecate_filename

if not ink_root.exists() or not ink_out.exists():
    print("Please run this script from the root of the project.")
    sys.exit(1)


parser = argparse.ArgumentParser(description="Compiles ink files from the Ink folder")
parser.add_argument("--recompile", "-r", action="store_true", help="Recompiles all files, even those older than their target.")

args = parser.parse_args()

recompile = args.recompile

def download_inklecate():
    import urllib.request

    print(f"Downloading {inklecate_zip} to {inklecate_temp_zip}")
    res = urllib.request.urlopen(inklecate_zip)

    print("Reading data...")
    data = res.read()
    with open(inklecate_temp_zip, "wb") as f:
        print("Writing to zip...")
        f.write(data)

    import zipfile

    print(f"Extracting zip to {inklecate_root}...")
    with zipfile.ZipFile(inklecate_temp_zip) as zipfile:
        zipfile.extractall(inklecate_root)

    print("Deleting temporary zip...")
    inklecate_temp_zip.unlink()

if not inklecate.exists():
    yn = ""
    while yn not in ["y", "n"]:
        yn = input("Inklecate not found. Download? (y/n) ")

    if yn == "n":
        print("Aborting...")
        sys.exit(1)

    download_inklecate()

import subprocess
import json
from typing import Sequence

def compile_ink(ink_path: Path, json_path: Path) -> subprocess.Popen:
    cmd = [
        inklecate,
        "-o",
        json_path,
        ink_path
    ]
    return subprocess.Popen(cmd)

def format_json(json_path: Path):
    print(json_path)
    with open(json_path, "r+", encoding="utf-8") as f:
        data = json.load(f)
        f.seek(0)
        json.dump(data, f, indent=2)

processes: Sequence[subprocess.Popen] = []
out_files: Sequence[Path] = []

ink_files = ink_root.glob("**/*.ink")
for file in ink_files:
    out_name = file.with_suffix(".ink.json").name
    out_path = ink_out / out_name

    if not recompile and out_path.exists():
        file_mtime = file.stat().st_mtime
        out_mtime = out_path.stat().st_mtime
        
        if out_mtime > file_mtime:
            print(f"Skipping {file}")
            continue

    processes.append(compile_ink(file, out_path))
    out_files.append(out_path)

for process in processes:
    process.wait()

for file in out_files:
    format_json(file)
