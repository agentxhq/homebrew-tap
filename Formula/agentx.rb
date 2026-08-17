# typed: false
# frozen_string_literal: true

# Prebuilt AgentX macOS binaries. Version and checksums are stamped by the
# release pipeline after the artifacts are published to app.agentxhq.io —
# do not hand-edit them.
class Agentx < Formula
  desc "AgentX multi-agent host daemon"
  homepage "https://www.agentxhq.com/"
  version "0.99.0"
  license "Proprietary"

  livecheck do
    skip "Version is stamped at release time from the AgentX release feed"
  end

  on_macos do
    on_arm do
      url "https://app.agentxhq.io/releases/agentx-0.99.0-darwin-arm64.tar.gz"
      sha256 "172befc95ba2e21602f2027201ab2c63bbd7c42efd8d38f69ab000fd225c4b1a"
    end
    on_intel do
      url "https://app.agentxhq.io/releases/agentx-0.99.0-darwin-amd64.tar.gz"
      sha256 "78c56ef472565d7e72b034a047a2207ff6f09b308f99320e9f5186e6d2296595"
    end
  end

  def install
    bin.install "agentx-daemon"
    bin.install "agentx"
    bin.install_symlink "agentx" => "agentx-browser"
  end

  def caveats
    <<~EOS
      AgentX state lives in ~/.agentx/ (config, sqlite, logs).

      Start it:
        agentx-daemon background
        agentx-daemon status
        open http://127.0.0.1:3333/console

      Or run it at login:
        brew services start agentx

      These builds are not signed or notarized. Homebrew installs them without
      a Gatekeeper prompt; a manual download would need:
        xattr -dr com.apple.quarantine $(brew --prefix)/bin/agentx-daemon
    EOS
  end

  service do
    run [opt_bin/"agentx-daemon", "serve"]
    keep_alive true
    environment_variables PATH: std_service_path_env
    log_path var/"log/agentx.log"
    error_log_path var/"log/agentx.err.log"
  end

  test do
    assert_match(/\d/, shell_output("#{bin}/agentx-daemon version"))
  end
end
