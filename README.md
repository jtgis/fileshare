# File Share Site

A minimal, password-protected file sharing platform built with **Python + Flask**.

Each **user account** is associated with a folder of files they can access.
**Admin** accounts can manage users and files but do not have their own collections.

The site is designed to be:

- Easy to deploy on Debian
- Mobile-friendly
- Lightweight
- Private (no public upload)
- Ideal for hosting family archives, private collections, or customer media

---

## 🚀 Features

### For Users
- Login with username + password
- View/download files in their assigned directory
- Supported previews:
  - 🎥 Video (`.mp4`, `.webm`, `.m4v`, `.ogg`)
  - 🎵 Audio (`.mp3`, `.m4a`, `.wav`, `.flac`)
  - 🖼️ Images (`.jpg`, `.jpeg`, `.png`, `.gif`, `.webp`)
  - 📄 PDF
- Mobile-optimized UI (files stack into cards)
- Long filenames wrap properly on mobile
- Footer help link:
  _“If you have any issues, please see our help guide or contact jarrett.totton@gmail.com.”_

### For Admin
- Admin-only accounts (no media directory)
- Add/remove users
- Reset passwords
- Manage user collections:
  - View all files
  - Preview as the user
  - Delete files
- Prevents deletion of last admin

---

## 🏗️ Tech Stack

| Component     | Choice |
|---------------|---------|
| Language      | Python 3 |
| Framework     | Flask |
| Database      | SQLite (local `.db`) |
| Auth          | Werkzeug password hashing |
| Frontend      | Jinja2 templates + CSS |
| Storage       | Files on disk (`collections/`) |

---

## 📦 Installation

On a Debian server:

```bash
sudo apt update
sudo apt install -y python3-venv python3-pip sqlite3 git
```

---

### 1. Download the project

```bash
git clone https://github.com/YOURNAME/your-repo.git
cd your-repo
```

Or, if using the auto-builder script:

```bash
bash setup_media_portal.sh
cd ~/media_portal
```

---

### 2. Install dependencies

```bash
./install.sh
```

This will:

- Create a virtualenv
- Install requirements
- Create (`site.db`) if missing
- Prompt to create accounts (admin or user)

---

### 3. Run the server

```bash
./run.sh
```

Visit:

```
http://YOUR-SERVER-IP:8000
```

---

## 👤 Accounts

### Create accounts later

```bash
source venv/bin/activate
python db_init.py
```

- Leave **directory blank** to create an **admin**
- Users must have a directory (creates `/collections/<dirname>/`)

### Delete users manually (CLI)

```bash
sqlite3 site.db "DELETE FROM collections WHERE username='bob';"
```

(Optional) remove the files:

```bash
rm -rf collections/bob
```

---

## 📁 Uploading Files

For a user with directory `family_a`, put files here:

```
collections/family_a/
```

Via SCP:

```bash
scp photo.jpg root@SERVER:/root/media_portal/collections/family_a/
```

Or use SFTP (FileZilla, WinSCP, etc.).

---

## 🎨 UI

### Desktop Table View

| File name         | Type  | Size  | Actions       |
|-------------------|--------|--------|----------------|
| video1.mp4        | 🎥 Video | 15 MB | View / Download |
| song.mp3          | 🎵 Audio | 3 MB  | View / Download |
| archive.zip       | 📁 Other | 9 MB  | Download        |

### Mobile View

Each file becomes a stacked card:

```
File name: video1.mp4
Type: 🎥 Video
Size: 15 MB
[View] [Download]
```

---

## 🛠️ Systemd Service (optional)

```ini
[Unit]
Description=File Share Site
After=network.target

[Service]
WorkingDirectory=/root/media_portal
ExecStart=/root/media_portal/venv/bin/flask run --host=0.0.0.0 --port=8000
Environment="SECRET_KEY=change-me"
Environment="FLASK_APP=app.py"
Restart=always

[Install]
WantedBy=multi-user.target
```

Enable:

```bash
sudo cp file_share.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable file_share
sudo systemctl start file_share
```

---

## 📂 Project Structure

```
media_portal/
├── app.py
├── db_init.py
├── site.db
├── install.sh
├── run.sh
├── templates/
│   ├── login.html
│   ├── dashboard.html
│   ├── admin_dashboard.html
│   ├── help.html
├── static/
│   └── style.css
└── collections/
    ├── family_a/
    └── family_b/
```

---

## ⚠️ Security Notes

- Replace the default `SECRET_KEY` in `run.sh` before deploying publicly
- Put behind HTTPS (Nginx, Caddy, Cloudflare Tunnel, Tailscale, etc.)
- No public upload page (only admins manage write access)

---

## 📄 License

MIT — free to use, modify, and distribute.

---
