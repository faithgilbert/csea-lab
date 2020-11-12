#!/usr/bin/env python3

"""
This module contains functions I find myself using again and again across the entire leipzig project.

Created 11/11/2020 by Benjamin Velie
veliebm@gmail.com
"""

import re
from pathlib import Path


def subject_id_of(path) -> str:
    """
    Returns the subject ID closest to the end of the input string or Path.

    Inputs
    ------
    path : str or Path
        String or Path containing the subject ID.

    Returns
    -------
    str
        Subject ID found in the filename

    Raises
    ------
    RuntimeError
        If no subject ID found in input filename.
    """

    try:
        subject_ids = re.findall(r"sub-(\d+)", str(path))
        return subject_ids[-1]
    except IndexError:
        raise RuntimeError(f"No subject ID found in {path}. Is this file named correctly?")


def task_name_of(path) -> str:
    """
    Returns the task name closest to the end of the input string or Path.

    Inputs
    ------
    path : str or Path
        String or Path containing the task name.

    Returns
    -------
    str
        Task name found in the filename

    Raises
    ------
    RuntimeError
        If no task name found in input filename.
    """

    try:
        tasks = re.findall(r"task-(.+)[_\.]", str(path))
        return tasks[-1]
    except IndexError:
        raise RuntimeError(f"No task name found in {path}. Is this file named correctly?")


def the_path_that_matches(pattern: str, in_directory):
    """
    Finds one and only one path matching the specified pattern. Raises an error if it finds 2+ paths or no paths.

    To learn how to use advanced patterns, read http://www.robelle.com/smugbook/wildcard.html

    Parameters
    ----------
    pattern : str
        Pattern to search for.
    in_directory : str or Path
        Directory in which to search for the pattern.

    Returns
    -------
    Path
        Path found by search.

    Raises
    ------
    IOError
        If it finds 2+ paths or no paths.
    """

    matches = list(Path(in_directory).glob(pattern))

    if not Path(in_directory).is_dir():
        raise IOError(f"{in_directory} either doesn't exist or isn't a directory at all!")

    elif(len(matches)) >= 2:
        raise IOError(f"The directory {in_directory} exists but contains more than one path that matches '{pattern}': {[match.name for match in matches]}")

    elif(len(matches)) == 0:
        raise IOError(f"The directory {in_directory} exists but contains no paths that match pattern '{pattern}'")
    
    else:
        return matches[0]