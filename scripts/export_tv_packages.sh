#!/bin/zsh

set -euo pipefail

target_endpoint="${1:-192.168.0.107:5555}"
output_file="${2:-XIAOMI_TV_PACKAGES.md}"

adb connect "$target_endpoint" >/dev/null

if [[ "$(adb -s "$target_endpoint" get-state)" != "device" ]]; then
  print -u2 "ADB device is not ready: $target_endpoint"
  exit 1
fi

manufacturer="$(adb -s "$target_endpoint" shell getprop ro.product.manufacturer | tr -d '\r')"
model="$(adb -s "$target_endpoint" shell getprop ro.product.model | tr -d '\r')"
android_version="$(adb -s "$target_endpoint" shell getprop ro.build.version.release | tr -d '\r')"
build_id="$(adb -s "$target_endpoint" shell getprop ro.build.display.id | tr -d '\r')"
home_activity="$(adb -s "$target_endpoint" shell 'cmd package resolve-activity --brief -a android.intent.action.MAIN -c android.intent.category.HOME' | tr -d '\r' | tail -1)"
captured_at="$(TZ=Asia/Ho_Chi_Minh date '+%Y-%m-%d %H:%M:%S %Z')"

package_rows="$(adb -s "$target_endpoint" shell pm list packages -f | tr -d '\r' | sed 's/^package://' | while IFS= read -r package_line; do
  package_name="${package_line##*=}"
  apk_path="${package_line%=*}"
  printf '%s\t%s\n' "$package_name" "$apk_path"
done | sort)"

system_packages="$(adb -s "$target_endpoint" shell pm list packages -s | tr -d '\r' | sed 's/^package://' | sort)"
user_packages="$(adb -s "$target_endpoint" shell pm list packages -3 | tr -d '\r' | sed 's/^package://' | sort)"
disabled_packages="$(adb -s "$target_endpoint" shell pm list packages -d | tr -d '\r' | sed 's/^package://' | sort)"

total_count="$(printf '%s\n' "$package_rows" | sed '/^$/d' | wc -l | tr -d ' ')"
system_count="$(printf '%s\n' "$system_packages" | sed '/^$/d' | wc -l | tr -d ' ')"
user_count="$(printf '%s\n' "$user_packages" | sed '/^$/d' | wc -l | tr -d ' ')"
disabled_count="$(printf '%s\n' "$disabled_packages" | sed '/^$/d' | wc -l | tr -d ' ')"

temporary_file="$(mktemp "${TMPDIR:-/tmp}/tivistore-packages.XXXXXX")"
trap 'rm -f "$temporary_file"' EXIT

{
  printf '# Xiaomi TV package inventory\n\n'
  printf 'Danh sách package được cài trên TV tại thời điểm chụp. File được tạo bởi `scripts/export_tv_packages.sh`.\n\n'
  printf '## Thiết bị\n\n'
  printf -- '- Thời điểm: `%s`\n' "$captured_at"
  printf -- '- ADB endpoint: `%s`\n' "$target_endpoint"
  printf -- '- Manufacturer: `%s`\n' "$manufacturer"
  printf -- '- Model: `%s`\n' "$model"
  printf -- '- Android: `%s`\n' "$android_version"
  printf -- '- Build: `%s`\n' "$build_id"
  printf -- '- Home mặc định: `%s`\n\n' "$home_activity"
  printf '## Tổng quan\n\n'
  printf -- '- Tổng package: **%s**\n' "$total_count"
  printf -- '- Package hệ thống: **%s**\n' "$system_count"
  printf -- '- Package do người dùng cài: **%s**\n' "$user_count"
  printf -- '- Package bị vô hiệu hóa: **%s**\n\n' "$disabled_count"
  printf '## Danh sách package\n\n'
  printf '| Package | Version | Version code | Loại | Trạng thái | APK path |\n'
  printf '|---|---:|---:|---|---|---|\n'

  while IFS=$'\t' read -r package_name apk_path; do
    package_dump="$(adb -s "$target_endpoint" shell dumpsys package "$package_name" </dev/null | tr -d '\r')"
    version_name="$(printf '%s\n' "$package_dump" | sed -n 's/^[[:space:]]*versionName=//p' | head -1)"
    version_code="$(printf '%s\n' "$package_dump" | sed -n 's/^[[:space:]]*versionCode=\([^ ]*\).*/\1/p' | head -1)"

    if printf '%s\n' "$system_packages" | grep -Fxq "$package_name"; then
      package_type='System'
    else
      package_type='User'
    fi

    if printf '%s\n' "$disabled_packages" | grep -Fxq "$package_name"; then
      package_state='Disabled'
    else
      package_state='Enabled'
    fi

    version_name="${version_name:--}"
    version_code="${version_code:--}"
    printf '| `%s` | `%s` | `%s` | %s | %s | `%s` |\n' \
      "$package_name" "$version_name" "$version_code" "$package_type" "$package_state" "$apk_path"
  done <<< "$package_rows"
} > "$temporary_file"

mv "$temporary_file" "$output_file"
trap - EXIT

printf 'Wrote %s packages to %s\n' "$total_count" "$output_file"
