🧠 Automated Backup System — Bash Scripting Project
📋 Overview

The Automated Backup System is a bash-based tool that allows users to automatically back up important files and directories.
It compresses your files into timestamped archives, logs every action, and optionally cleans up old backups.
Think of it like a smart “copy–paste” that never forgets what it did and verifies success.

This project is perfect for beginners learning bash scripting, logging, and automation in Linux or Git Bash on Windows.

🚀 Features

✅ Automated Backups — Backup any folder with a single command
✅ Timestamped Archives — Backups are labeled with date & time
✅ Logging System — Every backup, error, and action is logged with timestamps
✅ Error Handling — Detects missing folders or permission issues
✅ Cleanup Mode — Easily delete all old backups
✅ Screenshot Capture (Windows) — Automatically take a screenshot after each backup (via PowerShell)
✅ Cross-platform — Works on Linux, macOS, and Windows (Git Bash)
✅ Customizable Paths — Change where backups and logs are stored
✅ Verbose Output — Shows live progress in terminal

🗂️ Folder Structure
backup-system/
│
├── backup.sh              # Main backup script
├── backups/               # Folder where archives (.tar.gz) are saved
├── screenshots/           # Folder where screenshots are saved (Windows)
├── logs/                  # Contains backup.log file
├── testfile.txt           # Example file to test backups
└── README.md              # Project documentation

🛠️ Requirements
System	Requirement	Description
Linux / macOS	bash, tar	Pre-installed on most systems
Windows	Git Bash + PowerShell	For command-line and screenshots
Optional	scrot (Linux)	To capture screenshots
⚙️ Setup Instructions

Follow these steps carefully to set up and test the project.

1️⃣ Clone or create the project folder
mkdir backup-system
cd backup-system

2️⃣ Create the backup script

Create a file named backup.sh using:

3️⃣ Make the script executable
chmod +x backup.sh

4️⃣ Create folder structure
mkdir -p backups logs screenshots

5️⃣ Test a sample file or folder

Create something to back up:

echo "This is a test file" > testfile.txt

6️⃣ Run your first backup
./backup.sh testfile.txt


Expected output:

[2025-11-04 15:10:26] INFO: Starting backup of testfile.txt
[2025-11-04 15:10:27] INFO: Backup created: backups/backup-2025-11-04-1510.tar.gz
[2025-11-04 15:10:27] INFO: Backup completed successfully!

7️⃣ View backup archives
ls backups/


Example output:

backup-2025-11-04-1510.tar.gz

8️⃣ View logs
cat logs/backup.log


You’ll see a history of backups and errors (if any).

9️⃣ Automatically capture screenshot (Windows only)

After running your backup, take a screenshot:

1️⃣0️⃣ Run cleanup command (delete all old backups)
./backup.sh --cleanup


This will remove all .tar.gz files from the backups/ folder.

🧩 Example backup session
$ ./backup.sh /home/user/documents
[2025-11-04 15:13:56] INFO: Starting backup of /home/user/documents
[2025-11-04 15:14:01] INFO: Backup created: ./backups/backup-2025-11-04-1514.tar.gz
[2025-11-04 15:14:01] INFO: Taking screenshot of backup completion...
[2025-11-04 15:14:02] INFO: Screenshot saved to ./screenshots/backup_2025-11-04-1514.png
[2025-11-04 15:14:02] INFO: Backup process finished successfully

🧾 Logging Format

Each log entry is stored in logs/backup.log with a timestamp:

[YYYY-MM-DD HH:MM:SS] INFO: message
[YYYY-MM-DD HH:MM:SS] ERROR: message


Example:

[2025-11-04 14:12:34] INFO: Starting backup of /home/user/documents
[2025-11-04 14:12:36] INFO: Backup created: ./backups/backup-2025-11-04-1412.tar.gz
[2025-11-04 14:12:36] INFO: Backup completed successfully!

🧹 Cleanup Functionality

To delete all backup archives:

./backup.sh --cleanup


Example output:

[2025-11-04 14:20:56] INFO: Cleaning up backup directory...
[2025-11-04 14:20:57] INFO: All backups removed successfully.

📸 Screenshot Feature

Automatically captures a screenshot after every successful backup (on Windows).

Stored in the screenshots/ folder with timestamp-based filenames:

backup_2025-11-04-1422.png

⚡ Advanced Usage
Command	Description
./backup.sh /path/to/folder	Create a backup of a specific folder
./backup.sh --cleanup	Delete all existing backups
./backup.sh --log	Display recent backup log
./backup.sh --help	Show help menu
⚠️ Error Examples and Fixes
Error	Cause	Fix
Source folder not found	Wrong path entered	Use full path like /home/user/Documents
Permission denied	Folder not accessible	Use sudo or change permissions
command not found	Missing bash or wrong syntax	Use ./backup.sh foldername
tar: Cannot open: No such file or directory	Folder doesn’t exist	Check input folder
🧪 Testing Your Script

Try different test cases:

Backup single file → ./backup.sh testfile.txt

Backup folder → ./backup.sh Documents

Wrong path → ./backup.sh /invalid/path

Cleanup → ./backup.sh --cleanup

Run twice and check timestamps → ls backups

💡 Tips

Always run the script from the project root folder.

Use absolute paths for reliability.

Add a cron job to schedule backups automatically.

Customize the backup retention policy (e.g., keep last 5 backups only).

🕓 Scheduling Automatic Backups (Optional)

You can automate backups using cron (Linux) or Task Scheduler (Windows).

🐧 Linux
crontab -e


Add:

0 9 * * * /home/user/backup-system/backup.sh /home/user/Documents


→ Runs backup every day at 9 AM.

🪟 Windows

Use Task Scheduler:

Create new task

Run: bash.exe -c "./backup.sh /c/Users/YourName/Documents"

Set trigger (daily, weekly, etc.)

🧰 Customization Ideas

Email notification after successful backup

Encrypt backups using gpg

Auto-upload to Google Drive or Dropbox

Compress with password protection

Create restore script

🧭 Future Enhancements

Add checksum verification for archive integrity

Add incremental backups (only changed files)

Add colorized terminal output

Add progress bar while compressing

Add GUI (optional)

👨‍💻 Author

Pooja Devarmani
💬 Student | Developer | Bash Automation Learner
📅 Created on: November 2025
📂 Project: Automated Backup System (Bash)
