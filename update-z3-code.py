import argparse
import os
import shutil
import subprocess
import sys
import stat

from platform import system
from typing import Optional, Callable
from pathlib import Path
from os import PathLike

# -----
# Utility functions
# -----

def echo_call(bin: PathLike | str, *args: str):
    print('>', str(bin), *args)

def run(bin_name: str, *args: str, cwd: str | Path | None=None, echo: bool = True, silent: bool = False):
    if echo:
        echo_call(bin_name, *args)
    
    if silent:
        subprocess.check_output([bin_name] + list(args), cwd=cwd)
    else:
        subprocess.check_call([bin_name] + list(args), cwd=cwd)

def git(command: str, *args: str, cwd: str | Path | None=None, echo: bool = True):
    run('git', command, *args, cwd=cwd, echo=echo)

def git_output(*args: str, cwd: str | None=None, echo: bool = True) -> str:
    if echo:
        echo_call('git', *args)

    return subprocess.check_output(['git'] + list(args), cwd=cwd).decode('UTF8')

def path(root: PathLike | str, *args: PathLike | str) -> Path:
    return Path(root).joinpath(*args)

def cwd_path(*args: PathLike | str) -> Path:
    return path(Path.cwd(), *args)

# From: https://github.com/gitpython-developers/GitPython/blob/ea43defd777a9c0751fc44a9c6a622fc2dbd18a0/git/util.py#L101
# Windows has issues deleting readonly files that git creates
def git_rmtree(path: os.PathLike) -> None:
    """Remove the given recursively.
    :note: we use shutil rmtree but adjust its behaviour to see whether files that
        couldn't be deleted are read-only. Windows will not remove them in that case"""

    def onerror(func: Callable, path: os.PathLike, _) -> None:
        # Is the error an access error ?
        os.chmod(path, stat.S_IWUSR)

        try:
            func(path)  # Will scream if still not possible to delete.
        except Exception:
            raise

    return shutil.rmtree(path, False, onerror)

# ----
# Main logic
# ----

Z3_REPO='https://github.com/Z3Prover/z3.git'

CZ3_SOURCES_PATH=cwd_path('Sources', 'CZ3')
Z3_DEST_PATH=path(CZ3_SOURCES_PATH, 'z3')

TEMP_FOLDER_NAME='temp'

FOLDERS_TO_REMOVE=[
    path('api', 'c++'),
    path('api', 'dotnet'),
    path('api', 'dll'),
    path('api', 'julia'),
    path('api', 'java'),
    path('api', 'ml'),
    path('api', 'python'),
    path('shell'),
    path('test'),
]
"List of folders from CZ3 to remove after copying the new files. Removal happens relative to Z3_DEST_PATH."
 
FILES_TO_REMOVE=[
    'CMakeLists.txt',
    'README',
    'database.smt',
    'database.smt2',
    '*.cmake.in',
    '*.pyg',
    '*.in',
    '*.txt',
    'xor_solver.d',
    '*.disabled',
]
"List of file patterns to remove. Searches recursively on all folders. Removal happens relative to Z3_DEST_PATH."


def clone_repo(tag: str | None):
    print('Creating temporary path folder ./temp...')
    
    temp_path = cwd_path(TEMP_FOLDER_NAME)
    if temp_path.exists():
        git_rmtree(temp_path)
    
    z3_clone_path = str(path(temp_path, 'z3').absolute())
    
    if tag is None:
        git('clone', Z3_REPO, '--depth=1', z3_clone_path)
    else:
        git('clone', Z3_REPO, z3_clone_path)
        git('checkout', tag, cwd=z3_clone_path)
    
    return temp_path, z3_clone_path


def run_post_clone(clone_path: Path):
    if system() == 'Windows':
        run('python', str(Path('scripts').joinpath('mk_make.py')), '-x', cwd=clone_path)
    else:
        run('python', str(Path('scripts').joinpath('mk_make.py')), cwd=clone_path)

def backup_includes(include_target_path: Path, include_backup_path: Path):
    print(f'Backing up {include_target_path}...')

    shutil.copytree(include_target_path, include_backup_path)

def copy_z3_files(include_target_path: Path, include_backup_path: Path, src_path: Path):
    print('Copying over Z3 files...')

    if Z3_DEST_PATH.exists():
        shutil.rmtree(Z3_DEST_PATH)
    if include_target_path.exists():
        shutil.rmtree(include_target_path)
    
    shutil.copytree(src_path, Z3_DEST_PATH)
    shutil.copytree(include_backup_path, include_target_path)

def remove_extraneous_files():
    print('Removing extraneous files...')

    for folder in FOLDERS_TO_REMOVE:
        folder_path = path(Z3_DEST_PATH, folder)
        print(f'rm {folder_path}')
        shutil.rmtree(folder_path)
    
    for file_pattern in FILES_TO_REMOVE:
        for file in Z3_DEST_PATH.rglob(file_pattern):
            print(f'rm {file}')
            os.remove(file)


def update_z3_code(tag: Optional[str], force: bool) -> int:
    if (not force) and len(git_output('status', '--porcelain', echo=False).strip()) > 0:
        print("Current git repo's state is not committed! Please commit and try again.")
        return 1
    
    temp_path, z3_clone_path = clone_repo(tag)

    z3_src_path = path(temp_path, 'z3', 'src')
    include_backup_path = path(temp_path, 'include')
    include_target_path = path(CZ3_SOURCES_PATH, 'include')

    run_post_clone(z3_clone_path)
    backup_includes(include_target_path, include_backup_path)
    copy_z3_files(include_target_path, include_backup_path, z3_src_path)
    remove_extraneous_files()

    print("Success!")

    git_status = git_output('status', '--porcelain').strip()
    if len(git_status) > 0:
        print('New unstaged changes:')
        print(git_status)
    
    git_rmtree(temp_path)

    return 0

# -----
# Entry point
# -----

def main() -> int:    
    def make_argparser() -> argparse.ArgumentParser:
        argparser = argparse.ArgumentParser()
        argparser.add_argument('-t', '--tag',
                            type=str,
                            help='A tag or branch to clone from the Z3 repository.')
        argparser.add_argument('-f', '--force',
                            action='store_true',
                            help='Whether to ignore non-commited state of the repository. By default, the script fails if the repository has changes that are not commited to avoid conflicts and unintended changes.')

        return argparser

    argparser = make_argparser()
    args = argparser.parse_args()

    return update_z3_code(args.tag, args.force)

if __name__=='__main__':
    try:
        sys.exit(main())
    except subprocess.CalledProcessError as err:
        sys.exit(err.returncode)
    except KeyboardInterrupt:
        sys.exit(1)
