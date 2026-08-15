cask "lite-xl" do
  version "2.1.8"
  sha256 "b7f7af20926831737618b36b4ea902689d0f16a419cdd73d610f1d9b27027175"

  url "https://github.com/lite-xl/lite-xl/releases/download/v#{version}/lite-xl-v#{version}-addons-macos-universal.dmg"
  name "Lite XL"
  desc "Lightweight text editor written in Lua"
  homepage "https://lite-xl.com/"

  livecheck do
    url :url
    strategy :github_latest
  end

  # Upstream ships unsigned/un-notarized builds, so Gatekeeper blocks the first
  # launch. The postflight below strips the quarantine attribute.
  depends_on macos: :big_sur

  app "Lite XL.app"
  # The binary resolves its data dir relative to its own path, so a plain
  # symlink into HOMEBREW_PREFIX/bin makes it look for core/start.lua there.
  # Link a wrapper that execs the real binary inside the bundle instead.
  shimscript = "#{staged_path}/lite-xl.wrapper.sh"
  binary shimscript, target: "lite-xl"

  preflight do
    File.write shimscript, <<~EOS
      #!/bin/bash
      exec '#{appdir}/Lite XL.app/Contents/MacOS/lite-xl' "$@"
    EOS
  end

  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/Lite XL.app"],
                   sudo: false
  end

  zap trash: [
    "~/.config/lite-xl",
    "~/Library/Saved Application State/com.lite-xl.savedState",
  ]
end
