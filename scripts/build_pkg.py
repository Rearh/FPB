#!/usr/bin/env python3
import json
import os
import subprocess
import sys
import tarfile
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
RECIPES_DIR = ROOT / "recipes"
PKG_OUT_DIR = ROOT / "packages" / "amd64"
INDEX_FILE = ROOT / "repo.json"

if len(sys.argv) < 2:
    print("Использование: python3 scripts/build_pkg.py <имя_пакета>")
    sys.exit(1)

pkg_name = sys.argv[1]
recipe_script = RECIPES_DIR / pkg_name / "build.sh"
if not recipe_script.exists():
    print(f"[!] Рецепт {recipe_script} не найден.")
    sys.exit(1)

meta = {}
for line in recipe_script.read_text(encoding="utf-8").splitlines()[:15]:
    if line.startswith("# "):
        parts = line[2:].split(":", 1)
        if len(parts) == 2:
            meta[parts[0].strip()] = parts[1].strip()

version = meta.get("version", "0.1.0")
deps_raw = meta.get("depends", "")
depends = [d.strip() for d in deps_raw.split(",") if d.strip()]

PKG_OUT_DIR.mkdir(parents=True, exist_ok=True)
archive_name = f"{pkg_name}-{version}-amd64.tar.xz"
archive_path = PKG_OUT_DIR / archive_name

with tempfile.TemporaryDirectory(prefix=f"pack-{pkg_name}-") as tmpdir:
    tmp_path = Path(tmpdir)
    build_dir = tmp_path / "build"
    dest_dir = tmp_path / "pkg"
    build_dir.mkdir()
    dest_dir.mkdir()

    env = os.environ.copy()
    env["DESTDIR"] = str(dest_dir)

    print(f"[*] Сборка бинарника {pkg_name} ({version})...")
    res = subprocess.run(["/bin/bash", str(recipe_script)], cwd=build_dir, env=env)
    if res.returncode != 0:
        print("[!] Ошибка сборки.")
        sys.exit(1)

    print(f"[*] Упаковка в {archive_name}...")
    with tarfile.open(archive_path, "w:xz") as tar:
        for item in dest_dir.iterdir():
            tar.add(item, arcname=item.name)

repo = json.loads(INDEX_FILE.read_text(encoding="utf-8")) if INDEX_FILE.exists() else {}
repo[pkg_name] = {
    "version": version,
    "url": f"packages/amd64/{archive_name}",
    "depends": depends
}
INDEX_FILE.write_text(json.dumps(repo, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
print(f"[+] Готово! Архив сохранён и добавлен в repo.json.")
