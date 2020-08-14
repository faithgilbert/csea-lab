"""
Extracts the necessary metadata from a dataset to make it BIDS compliant. 

The dataset must already be named according to BIDS standards. Thus, I recommend running bidsify_paths.py before this program.

Created 8/13/2020 by Benjamin Velie.
veliebm@gmail.com
"""

import argparse
import bidsify_metadata_template
import os
import pathlib


def main(target_dir):

    target_path = pathlib.Path(target_dir)

    # Gather all file paths into a list.
    path_list = target_path.rglob("*")

    # Iterate through the list of file paths and extract metadata from each file into a dictionary.
    metadata_dict = extract_metadata_from_files(path_list)
    
    #[print(f"{key}  :  {value}") for key, value in metadata_dict.items()]
    
    # Use dictionary of metadata to bidsify the dataset.


def list_all_paths(input_dir: str) -> list:
    """
    Returns a list of all paths in a directory and subdirectories.

    Accesses all files in input dir AND recursively into subdirectories.
    """

    paths = []

    for folder_name, __, filenames in os.walk(input_dir):
        for filename in filenames:
            paths.append(os.path.abspath(os.path.join(folder_name, filename)))
        
    return paths


def extract_metadata_from_files(path_list) -> dict:
    """
    Extracts metadata from each file in a list of files.
    """

    metadata_dict = {}

    for path in path_list:
        metadata_dict[path] = extract_metadata(path)

    return metadata_dict


def extract_metadata(path) -> dict:
    """
    Extracts metadata from a file.

    bidsify_metadata_template.py defines what metadata is extracted.
    """

    file_type = get_file_type(path)
    extraction_template = getattr(bidsify_metadata_template, f"{file_type}_metadata_extraction_template")

    return extraction_template(path)


def get_file_type(path) -> str:
    """
    Returns the type of neuroimaging file the target file is.

    Returns any file type in FILETYPES.
    """

    for file_type, keyword_list in bidsify_metadata_template.FILETYPES.items():
        for keyword in keyword_list:
            if keyword in path.name:
                return file_type


if __name__ == "__main__":

    parser = argparse.ArgumentParser(description="Makes a dataset BIDS compliant.")
    parser.add_argument("directory", type=str, help="Target directory.")

    args = parser.parse_args()

    main(args.directory)