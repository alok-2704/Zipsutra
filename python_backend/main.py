import sys
import json
from zip_manager import ZipManager


def main():
    if len(sys.argv) < 2:
        print("Usage:")
        print("  python main.py create output.zip file1 file2 ...")
        print("  python main.py extract archive.zip output_folder")
        print("  python main.py info archive.zip")
        return

    command = sys.argv[1]

    try:
        if command == "create":
            if len(sys.argv) < 4:
                raise ValueError("Not enough arguments for create")

            output_zip = sys.argv[2]
            files = sys.argv[3:]

            result = ZipManager.create_zip(files, output_zip)

            print(json.dumps({
                "success": True,
                "output": result
            }))

        elif command == "extract":
            if len(sys.argv) != 4:
                raise ValueError("Usage: extract archive.zip output_folder")

            zip_path = sys.argv[2]
            extract_to = sys.argv[3]

            result = ZipManager.extract_zip(zip_path, extract_to)

            print(json.dumps({
                "success": True,
                "output": result
            }))

        elif command == "info":
            if len(sys.argv) != 3:
                raise ValueError("Usage: info archive.zip")

            zip_path = sys.argv[2]
            info = ZipManager.get_zip_info(zip_path)

            print(json.dumps({
                "success": True,
                "files": info
            }, indent=2))

        else:
            raise ValueError(f"Unknown command: {command}")

    except Exception as e:
        print(json.dumps({
            "success": False,
            "error": str(e)
        }))


if __name__ == "__main__":
    main()