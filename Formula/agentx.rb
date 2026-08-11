# typed: false
# frozen_string_literal: true

# Prebuilt AgentX macOS binaries. Version and checksums are stamped by the
# release pipeline after the artifacts are published to app.agentxhq.io —
# do not hand-edit them.
class Agentx < Formula
  desc "AgentX multi-agent host daemon"
  homepage "https://www.agentxhq.com/"
  version "0.91.0"
  license "Proprietary"

  livecheck do
    skip "Version is stamped at release time from the AgentX release feed"
  end

  on_macos do
    on_arm do
      url "https://app.agentxhq.io/releases/agentx-0.91.0-darwin-arm64.tar.gz"
      sha256 "d2251398a2b841dffcabbce74ec469378aebde8db45c0a21d308d5def35b9bfc"
    end
    on_intel do
      url "https://app.agentxhq.io/releases/agentx-0.91.0-darwin-amd64.tar.gz"
      sha256 "5c40189ab767bf03d710d3c91fb720f2c524d1bd783e683e80abf71f75df63d2"
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
