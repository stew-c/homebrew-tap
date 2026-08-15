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

  # Upstream ships unsigned/un-notarized builds, so Gatekeeper blocks a normal
  # launch. Install with `--no-quarantine` to skip the quarantine attribute.
  depends_on macos: :big_sur

  app "Lite XL.app"
  binary "#{appdir}/Lite XL.app/Contents/MacOS/lite-xl"

  zap trash: [
    "~/.config/lite-xl",
    "~/Library/Saved Application State/com.lite-xl.savedState",
  ]
end
