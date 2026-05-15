import os
import zipfile
from pathlib import Path


class ZipManager:
    @staticmethod
    def create_zip(files, output_zip_path):
        """
        Create a ZIP file from a list of files or folders.

        Args:
            files (list[str]): List of file or folder paths.
            output_zip_path (str): Path where ZIP will be saved.

        Returns:
            str: Path to the created ZIP file.
        """
        with zipfile.ZipFile(output_zip_path, 'w', zipfile.ZIP_DEFLATED) as zipf:
            for item in files:
                item_path = Path(item)

                if item_path.is_file():
                    zipf.write(item_path, arcname=item_path.name)

                elif item_path.is_dir():
                    for root, _, filenames in os.walk(item_path):
                        for filename in filenames:
                            file_path = Path(root) / filename
                            arcname = file_path.relative_to(item_path.parent)
                            zipf.write(file_path, arcname=arcname)

        return output_zip_path

    @staticmethod
    def extract_zip(zip_path, extract_to):
        """
        Extract a ZIP file.

        Args:
            zip_path (str): ZIP file path.
            extract_to (str): Destination folder.

        Returns:
            str: Extraction folder path.
        """
        os.makedirs(extract_to, exist_ok=True)

        with zipfile.ZipFile(zip_path, 'r') as zipf:
            zipf.extractall(extract_to)

        return extract_to

    @staticmethod
    def get_zip_info(zip_path):
        """
        Return metadata about ZIP contents.
        """
        info_list = []

        with zipfile.ZipFile(zip_path, 'r') as zipf:
            for info in zipf.infolist():
                info_list.append({
                    "filename": info.filename,
                    "compressed_size": info.compress_size,
                    "original_size": info.file_size,
                })

        return info_list