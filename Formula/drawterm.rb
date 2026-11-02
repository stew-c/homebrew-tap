class Drawterm < Formula
  desc "Connect to Plan 9 and 9front CPU servers from a non-Plan 9 machine"
  homepage "https://drawterm.9front.org/"
  # Upstream (git.9front.org) has no release tags or tarballs, so pin a commit
  # from the GitHub mirror and version it by commit date.
  url "https://github.com/9front/drawterm/archive/be39bbaa88fda83bf75be642d093b20956297c8c.tar.gz"
  version "2026.11.01"
  sha256 "6731f53d8aeca2a75ebd9b5a990725b9c9c47fc53e8aa5b8b1b2056f04725b77"
  license "MIT"
  head "https://github.com/9front/drawterm.git", branch: "front"

  # No releases or tags upstream: report the date of the newest commit on
  # front, in the same YYYY.MM.DD form as version above.
  livecheck do
    url "https://api.github.com/repos/9front/drawterm/commits/front"
    strategy :json do |json|
      json.dig("commit", "committer", "date")&.slice(0, 10)&.tr("-", ".")
    end
  end

  depends_on :macos

  def install
    system "make", "CONF=osx-cocoa", "CC=#{ENV.cc}"
    bin.install "drawterm"
    man1.install "drawterm.1"
  end

  test do
    # No server to dial here; a bad flag must print usage and exit 1.
    assert_match "usage:", shell_output("#{bin}/drawterm -Z 2>&1", 1)
  end
end
